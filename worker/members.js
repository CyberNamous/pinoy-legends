// Member UIDs (PL + 12 digits, last digit is a Luhn check digit) and feedback reference numbers.
export const TEAM_LABELS = ['Owner', 'Founder', 'Head of Staff', 'Staff', 'Developer', 'Moderator', 'Community Manager', 'Designer'];
const REF_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'; // no I, L, O, 0 or 1
export const SENDER_LINK_DAYS = 90;

function randomInt(max) { // unbiased random integer in [0, max)
  const limit = 256 - (256 % max), b = new Uint8Array(1);
  for (;;) { crypto.getRandomValues(b); if (b[0] < limit) return b[0] % max; }
}

export function luhnCheckDigit(payload) {
  let sum = 0, double = true;
  for (let i = payload.length - 1; i >= 0; i--) {
    let d = payload.charCodeAt(i) - 48;
    if (double) { d *= 2; if (d > 9) d -= 9; }
    sum += d; double = !double;
  }
  return (10 - (sum % 10)) % 10;
}

export function makeUid() {
  let digits = '';
  for (let i = 0; i < 11; i++) digits += randomInt(10);
  return 'PL' + digits + luhnCheckDigit(digits);
}

export function validUid(uid) {
  if (typeof uid !== 'string' || !/^PL\d{12}$/.test(uid)) return false;
  const d = uid.slice(2);
  return luhnCheckDigit(d.slice(0, 11)) === Number(d[11]);
}

export function makeRef() {
  let s = '';
  for (let i = 0; i < 8; i++) s += REF_ALPHABET[randomInt(REF_ALPHABET.length)];
  return 'REF-' + s;
}
export const validRef = (r) => typeof r === 'string' && /^REF-[A-HJKMNP-Z2-9]{8}$/.test(r);

// Gives a member their permanent UID the first time it is needed. Safe to call concurrently.
export async function assignUid(env, discordId) {
  for (let i = 0; i < 8; i++) {
    try {
      await env.DB.prepare('UPDATE users SET uid=? WHERE discord_id=? AND uid IS NULL').bind(makeUid(), discordId).run();
    } catch (e) {
      if (!/UNIQUE|constraint/i.test(String(e.message))) throw e; // a collision: try another
      continue;
    }
    const row = await env.DB.prepare('SELECT uid FROM users WHERE discord_id=?').bind(discordId).first();
    if (row && row.uid) return row.uid;
  }
  throw Object.assign(new Error('Could not create your member ID. Please try again.'), { status: 500 });
}

// Gives every member who still has no UID one, in batches. Runs at most once a minute per isolate.
let lastBackfill = 0;
export async function backfillUids(env) {
  if (Date.now() - lastBackfill < 60000) return;
  lastBackfill = Date.now();
  for (let round = 0; round < 15; round++) {
    const rows = await env.DB.prepare('SELECT discord_id FROM users WHERE uid IS NULL LIMIT 100').all();
    if (!rows.results.length) return;
    try {
      await env.DB.batch(rows.results.map(r => env.DB.prepare('UPDATE users SET uid=? WHERE discord_id=? AND uid IS NULL').bind(makeUid(), r.discord_id)));
    } catch (e) {
      if (!/UNIQUE|constraint/i.test(String(e.message))) throw e; // a rare collision: the next round uses new numbers
    }
  }
}
