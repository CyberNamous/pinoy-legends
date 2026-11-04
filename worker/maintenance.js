// Maintenance mode: stored in the settings table, no schema change needed.
const DEFAULT_MESSAGE = 'We are doing some quick maintenance. Please check back soon.';
const KEYS = "'maint_start','maint_end','maint_message','maint_notice'";
let cache = { at: 0, v: null };

export async function loadMaintenance(env, fresh = false) {
  const now = Date.now();
  if (!fresh && cache.v && now - cache.at < 5000) return cache.v;
  const rows = await env.DB.prepare(`SELECT key,value FROM settings WHERE key IN (${KEYS},'discord_url','official_email')`).all();
  const v = Object.fromEntries(rows.results.map(r => [r.key, r.value]));
  cache = { at: now, v };
  return v;
}

// off | scheduled | notice (banner window before start) | active
export function phaseOf(m, now = Date.now()) {
  const start = Date.parse(m.maint_start || '');
  if (!Number.isFinite(start)) return 'off';
  const end = m.maint_end ? Date.parse(m.maint_end) : null;
  if (end !== null && Number.isFinite(end) && now >= end) return 'off';
  if (now >= start) return 'active';
  const lead = Number(m.maint_notice) || 0;
  return lead > 0 && start - now <= lead * 60000 ? 'notice' : 'scheduled';
}

export function publicState(m, now = Date.now()) {
  const phase = phaseOf(m, now);
  return {
    phase,
    start: phase === 'off' ? null : m.maint_start || null,
    end: phase === 'off' ? null : m.maint_end || null,
    message: phase === 'off' ? '' : m.maint_message || DEFAULT_MESSAGE,
  };
}

// Admin API: GET state, PUT start/schedule/extend, DELETE end now / cancel
export async function maintenanceAdmin(request, env, user, method, h) {
  const { body, text, commit, fail, json } = h;
  if (method === 'GET') {
    const m = await loadMaintenance(env, true);
    return json({
      maintenance: { start: m.maint_start || '', end: m.maint_end || '', message: m.maint_message || '', notice_minutes: Number(m.maint_notice) || 0 },
      phase: phaseOf(m),
      now: Date.now(),
    });
  }
  if (method === 'DELETE') {
    await commit(env, user, 'maintenance', 'end maintenance', 'cleared', [
      env.DB.prepare(`DELETE FROM settings WHERE key IN (${KEYS})`),
    ]);
    cache = { at: 0, v: null };
    return json({ ok: true });
  }
  if (method !== 'PUT') fail(405, 'This method is not supported.');

  const b = await body(request);
  const now = Date.now();
  let start = now;
  if (typeof b.start === 'string' && b.start) {
    start = Date.parse(b.start);
    if (!Number.isFinite(start)) fail(400, 'Enter a valid start time.');
    if (start < now - 5 * 60000) fail(400, 'The start time is in the past. Choose “Start now” or a later time.');
  }
  let end = null;
  if (typeof b.end === 'string' && b.end) {
    end = Date.parse(b.end);
    if (!Number.isFinite(end)) fail(400, 'Enter a valid end time.');
    if (end <= start) fail(400, 'The end time must be after the start time.');
    if (end <= now) fail(400, 'The end time has already passed.');
    if (end - start > 30 * 24 * 3600 * 1000) fail(400, 'Maintenance can last at most 30 days. Use “until I turn it off” for open-ended work.');
  }
  const message = text(typeof b.message === 'string' ? b.message : '', 500) || DEFAULT_MESSAGE;
  const notice = Math.max(0, Math.min(10080, Math.floor(Number(b.notice_minutes) || 0)));
  const up = (k, v) => env.DB.prepare('INSERT INTO settings(key,value) VALUES(?,?) ON CONFLICT(key) DO UPDATE SET value=excluded.value').bind(k, v);
  const startIso = new Date(start).toISOString();
  await commit(env, user, 'maintenance', start <= now + 1000 ? 'start maintenance' : 'schedule maintenance', startIso, [
    up('maint_start', startIso),
    up('maint_end', end ? new Date(end).toISOString() : ''),
    up('maint_message', message),
    up('maint_notice', String(notice)),
  ]);
  cache = { at: 0, v: null };
  return json({ ok: true });
}
