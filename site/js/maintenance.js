const wrap = document.querySelector('[data-end]');
const end = wrap && wrap.dataset.end ? Date.parse(wrap.dataset.end) : NaN;
const start = wrap && wrap.dataset.start ? Date.parse(wrap.dataset.start) : NaN;
const $ = id => document.getElementById(id);
const pad = n => String(n).padStart(2, '0');
const PH = 'Asia/Manila';

function expectedText() {
  const day = d => new Intl.DateTimeFormat('en-CA', { timeZone: PH }).format(d);
  const t = new Intl.DateTimeFormat('en-GB', { timeZone: PH, hour: '2-digit', minute: '2-digit', hourCycle: 'h23' }).format(new Date(end));
  const d = new Date(end);
  const date = day(d) === day(new Date()) ? '' : new Intl.DateTimeFormat('en-PH', { timeZone: PH, month: 'short', day: 'numeric' }).format(d) + ', ';
  return 'Expected back around ' + date + t + ' PHT';
}

if (Number.isFinite(end)) {
  $('maint-timer').hidden = false;
  $('maint-until').textContent = expectedText();
} else {
  $('maint-open').hidden = false;
}

async function maintenanceStillActive() {
  try {
    const r = await fetch('/api/maintenance', { cache: 'no-store' });
    return !(r.ok && (await r.json()).phase !== 'active');
  } catch { return true; } // network trouble: stay on the page
}

let checking = false;
async function reopenIfReady() {
  if (checking) return;
  checking = true;
  if (!(await maintenanceStillActive())) { location.reload(); return; }
  checking = false;
}

function tick() {
  if (!Number.isFinite(end)) return;
  const ms = end - Date.now();
  if (ms <= 0) {
    $('maint-countdown').textContent = '0:00:00';
    $('maint-fill').style.width = '100%';
    reopenIfReady();
    setTimeout(tick, 5000);
    return;
  }
  const s = Math.floor(ms / 1000), d = Math.floor(s / 86400), h = Math.floor((s % 86400) / 3600), m = Math.floor((s % 3600) / 60);
  $('maint-countdown').textContent = (d ? d + 'd ' + pad(h) : h) + ':' + pad(m) + ':' + pad(s % 60);
  if (Number.isFinite(start) && end > start) {
    const pct = Math.min(100, Math.max(0, ((Date.now() - start) / (end - start)) * 100));
    $('maint-fill').style.width = pct.toFixed(1) + '%';
  }
  setTimeout(tick, 1000);
}
tick();

$('maint-check').addEventListener('click', async () => {
  const btn = $('maint-check'), out = $('maint-status');
  btn.disabled = true; out.textContent = 'Checking…';
  if (!(await maintenanceStillActive())) { out.textContent = 'We’re back! Reloading…'; location.reload(); return; }
  out.textContent = 'Still under maintenance. We’ll keep checking.';
  setTimeout(() => { btn.disabled = false; out.textContent = ''; }, 3000);
});

// Check again automatically, in case an admin ends maintenance early
setInterval(reopenIfReady, 30000);
