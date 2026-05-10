if (window._catbellRunning) {
    clearTimeout(window._catbellInterval);
    if (window._catbellObserver) window._catbellObserver.disconnect();
    document.getElementById('catbell-status')?.remove();
    document.getElementById('catbell-mask')?.remove();
    document.getElementById('catbell-btn-wrap')?.remove();
}
window._catbellRunning = true;

const urlParams = new URL(location.href);
const isFinish = /\/finish\//i.test(location.pathname);
const isComplete = urlParams.searchParams.get('qq') === 'complete';
const isGoogleUrl = location.href.includes('google.com/url');
const isUptolink = location.hostname.includes('uptolink.one');

if (!isUptolink) {
    document.head.insertAdjacentHTML('beforeend', `<style>
@import url("https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700&display=swap");
#catbell-status{position:fixed;top:14px;right:14px;z-index:2147483648;background:linear-gradient(145deg,#08080f,#0c0c18);border:1px solid #ffffff10;border-radius:14px;padding:12px 14px;font-family:"Space Grotesk",sans-serif;box-shadow:0 12px 40px #000e,inset 0 1px 0 #ffffff08;min-width:200px;overflow:hidden;}
#catbell-glow{position:absolute;inset:0;border-radius:14px;pointer-events:none;background:radial-gradient(ellipse 90% 50% at 50% 0%,#5aa8ff0f,transparent 65%);}
#catbell-header{display:flex;align-items:center;gap:8px;margin-bottom:4px;position:relative;}
#catbell-icon{width:26px;height:26px;border-radius:8px;flex-shrink:0;background:linear-gradient(135deg,#5aa8ff18,#9d7aff18);border:1px solid #5aa8ff2a;display:flex;align-items:center;justify-content:center;font-size:13px;}
#catbell-status-step{font-weight:700;font-size:12px;flex:1;background:linear-gradient(90deg,#5aa8ff,#9d7aff);-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
#catbell-status-state{font-size:11px;color:#ffffff44;margin-bottom:8px;min-height:14px;position:relative;}
#catbell-steps{display:flex;gap:4px;position:relative;}
.cb-sdot{flex:1;height:3px;border-radius:99px;background:#ffffff08;overflow:hidden;position:relative;}
.cb-sdot-fill{position:absolute;inset:0;width:0%;border-radius:99px;background:linear-gradient(90deg,#5aa8ff,#9d7aff);transition:width .4s;}
.cb-sdot.done .cb-sdot-fill{width:100%;background:#2dd4a0;transition:none;}
.cb-sdot.error .cb-sdot-fill{width:100%;background:#f87171;transition:none;}
</style>`);

    document.body.insertAdjacentHTML('beforeend', `
<div id="catbell-status">
    <div id="catbell-glow"></div>
    <div id="catbell-header">
        <div id="catbell-icon">🐟</div>
        <div id="catbell-status-step">Cat Bell</div>
    </div>
    <div id="catbell-status-state"></div>
    <div id="catbell-steps">
        <div class="cb-sdot" id="cb-sdot-1"><div class="cb-sdot-fill" id="cb-sdot-fill-1"></div></div>
        <div class="cb-sdot" id="cb-sdot-2"><div class="cb-sdot-fill" id="cb-sdot-fill-2"></div></div>
        <div class="cb-sdot" id="cb-sdot-3"><div class="cb-sdot-fill" id="cb-sdot-fill-3"></div></div>
    </div>
</div>`);
}

document.head.insertAdjacentHTML('beforeend', `<style>
#catbell-mask{position:fixed;inset:0;z-index:2147483640;background:rgba(3,3,12,.97);backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);}
#catbell-btn-wrap{position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);z-index:2147483645;pointer-events:auto;}
</style>`);

function stSet(step, state) {
    if (isUptolink) return;
    if (step !== undefined) { const el = document.getElementById('catbell-status-step'); if (el) el.textContent = step; }
    if (state !== undefined) { const el = document.getElementById('catbell-status-state'); if (el) el.textContent = state; }
}

let currentStep = parseInt(sessionStorage.getItem('cb-step') || '0');
const dotFillTimers = {};

function stDotDone(n) {
    if (isUptolink) return;
    if (dotFillTimers['st'+n]) { clearTimeout(dotFillTimers['st'+n]); delete dotFillTimers['st'+n]; }
    const d = document.getElementById('cb-sdot-'+n);
    const f = document.getElementById('cb-sdot-fill-'+n);
    if (d) { d.classList.remove('error'); d.classList.add('done'); }
    if (f) { f.style.transition = 'none'; f.style.width = '100%'; f.style.background = '#2dd4a0'; }
}

function stDotActive(n) {
    if (isUptolink) return;
    const d = document.getElementById('cb-sdot-'+n);
    const f = document.getElementById('cb-sdot-fill-'+n);
    if (d) { d.classList.remove('done','error'); }
    if (f) { f.style.transition = 'none'; f.style.background = 'linear-gradient(90deg,#5aa8ff,#9d7aff)'; f.style.width = '55%'; }
}

function stDotErr(n) {
    if (isUptolink) return;
    const d = document.getElementById('cb-sdot-'+n);
    const f = document.getElementById('cb-sdot-fill-'+n);
    if (d) { d.classList.remove('done'); d.classList.add('error'); }
    if (f) { f.style.transition = 'none'; f.style.width = '100%'; f.style.background = '#f87171'; }
}

function stSyncDots(n, type) {
    if (isUptolink) return;
    for (let i = 1; i <= 3; i++) {
        if (dotFillTimers['st'+i]) continue;
        const d = document.getElementById('cb-sdot-'+i);
        const f = document.getElementById('cb-sdot-fill-'+i);
        if (!d) continue;
        d.classList.remove('done','error');
        if (f) { f.style.transition = 'none'; f.style.width = '0%'; f.style.background = 'linear-gradient(90deg,#5aa8ff,#9d7aff)'; }
        if (type === 'err' && i === n) stDotErr(i);
        else if (n > 0 && i < n) stDotDone(i);
        else if (i === n) stDotActive(i);
    }
}

function stDotFill(n, sec) {
    if (isUptolink) return;
    if (dotFillTimers['st'+n]) return;
    const d = document.getElementById('cb-sdot-'+n);
    const f = document.getElementById('cb-sdot-fill-'+n);
    if (!d || !f) return;
    d.classList.remove('done','error');
    f.style.transition = 'none'; f.style.width = '0%'; f.style.background = 'linear-gradient(90deg,#5aa8ff,#9d7aff)';
    requestAnimationFrame(() => { f.style.transition = 'width '+sec+'s linear'; f.style.width = '100%'; });
    dotFillTimers['st'+n] = setTimeout(() => { delete dotFillTimers['st'+n]; stDotDone(n); }, sec*1000);
}

function setStep(n) {
    currentStep = n;
    sessionStorage.setItem('cb-step', n);
    stSyncDots(n);
}

if (currentStep > 0) stSyncDots(currentStep);

const clearSiteData = () => {
    document.cookie.split(';').forEach(c => {
        document.cookie = c.trim().split('=')[0] + '=;expires=Thu,01 Jan 1970 00:00:00 UTC;path=/';
    });
    try { localStorage.clear(); sessionStorage.clear(); } catch (e) {}
};

let maskShown = false;
let reloadScheduled = false;

function showMask() {
    if (maskShown) return;
    maskShown = true;
    if (!document.getElementById('catbell-mask')) {
        document.body.insertAdjacentHTML('beforeend', '<div id="catbell-mask"></div>');
    }
    if (!document.getElementById('catbell-btn-wrap')) {
        document.body.insertAdjacentHTML('beforeend', '<div id="catbell-btn-wrap"></div>');
    }
}

function moveBtnToCenter() {
    const wrap = document.getElementById('catbell-btn-wrap');
    if (!wrap) return;
    const btn = document.getElementById('countdownBtn');
    if (!btn || wrap.contains(btn)) return;
    btn._origParent = btn.parentNode;
    btn._origNext = btn.nextSibling;
    wrap.appendChild(btn);
}

function removeMask() {
    const wrap = document.getElementById('catbell-btn-wrap');
    if (wrap) {
        const btn = document.getElementById('countdownBtn');
        if (btn && btn._origParent) {
            btn._origParent.insertBefore(btn, btn._origNext || null);
        }
        wrap.remove();
    }
    document.getElementById('catbell-mask')?.remove();
    maskShown = false;
}

const clickBtn = () => {
    const btn = document.getElementById('countdownBtn');
    if (!btn) return;
    const cd = btn.querySelector('.countdown');
    if (cd) cd.click();
};

let captchaClicked = false;

const JSON_MAP_URL = 'https://raw.githubusercontent.com/phatnottaken51/bypass-upto-link/refs/heads/main/link.json';
let _mapCache = null, _mapPromise = null;

function fetchJsonMap() {
    if (_mapCache) return Promise.resolve(_mapCache);
    if (_mapPromise) return _mapPromise;
    _mapPromise = fetch(JSON_MAP_URL, { cache: 'no-store' })
        .then(r => r.json())
        .then(d => { _mapCache = d.redirects || d; return _mapCache; })
        .catch(() => ({}));
    return _mapPromise;
}

const solveMath = () => {
    const txt = document.querySelector('#captchaShortlink')?.innerText || '';
    const m = txt.match(/(\d+)\s*([\+\-\*x×])\s*(\d+)/);
    if (!m) return false;
    const inp = document.getElementById('math-captcha-response');
    if (!inp) return false;
    const a = +m[1], b = +m[3], op = m[2];
    const r = op === '+' ? a+b : op === '-' ? a-b : a*b;
    inp.value = r;
    stSet('Cat Bell', 'Captcha: '+a+op+b+'='+r);
    setTimeout(() => document.getElementById('invisibleCaptchaShortlink')?.click(), (Math.floor(Math.random()*2)+5)*1000);
    return true;
};

const runCaptcha = () => {
    if (solveMath()) return;
    const cap = document.getElementById('invisibleCaptchaShortlink');
    if (!cap) return;
    const go = () => {
        stSet('Cat Bell', 'Xác minh...');
        setTimeout(() => cap.click(), (Math.floor(Math.random()*2)+5)*1000);
    };
    if (!cap.disabled) {
        go();
    } else {
        new MutationObserver((_, o) => {
            const b = document.getElementById('invisibleCaptchaShortlink');
            if (b && !b.disabled && !captchaClicked) {
                captchaClicked = true; o.disconnect();
                if (!solveMath()) go();
            }
        }).observe(cap, { attributes: true, attributeFilter: ['disabled'] });
    }
};

function doScrollOnce() {
    if (!document.querySelector('.countdown')) return;
    const max = document.documentElement.scrollHeight - window.innerHeight;
    if (max <= 0) return;
    window.scrollTo({ top: max, behavior: 'smooth' });
    setTimeout(() => window.scrollTo({ top: 0, behavior: 'smooth' }), 1500);
}

if (document.body && (document.title.includes('404') || document.body.innerText.includes('404'))) {
    stSet('Cat Bell', '❌ 404 - Đổi thiết bị...');
    stSyncDots(currentStep, 'err');
    clearSiteData();
    setTimeout(() => window.location.reload(), 2000);
}

setTimeout(async () => {
    document.querySelector('a.btn-primary')?.click();

    if (isGoogleUrl) {
        const lnk = [...document.querySelectorAll('a[href]')].find(el => {
            const h = el.getAttribute('href');
            return h && h.startsWith('http') && !h.includes('google.com');
        });
        if (lnk) lnk.click();
        return;
    }

    if (isComplete) {
        const key = urlParams.pathname.match(/\/([^\/]+)\/?$/)?.[1];
        if (!key) return;
        stSet('Cat Bell', 'Mã: ' + key);
        const errT = setTimeout(() => {
            stSet('Cat Bell', '❌ Không có nhiệm vụ');
            stSyncDots(currentStep, 'err');
        }, 5000);
        try {
            const map = await fetchJsonMap();
            clearTimeout(errT);
            const domain = map[key];
            if (domain) {
                const target = domain.startsWith('http') ? domain : 'https://' + domain;
                stSet('Cat Bell', 'URL: ' + target.replace(/^https?:\/\//, '').slice(0, 28) + (target.length > 33 ? '...' : ''));
                sessionStorage.removeItem('cb-step');
                setTimeout(() => window.location.replace('https://www.google.com/url?sa=t&source=web&rct=j&url=' + encodeURIComponent(target)), 800);
            } else {
                stSet('Cat Bell', '❌ Không có nhiệm vụ');
                stSyncDots(currentStep, 'err');
            }
        } catch (e) {
            clearTimeout(errT);
            stSet('Cat Bell', '❌ Lỗi tải map');
        }
        return;
    }

    if (isFinish) {
        doScrollOnce();
        runCaptcha();
        return;
    }

    doScrollOnce();
    runCaptcha();

    let lastStep = currentStep, waitAnim = false, errT = null;

    (function run() {
        const texts = [...document.querySelectorAll('.countdown')].map(el => el.textContent.trim());
        const status = texts.find(x =>
            x.includes('BẮT ĐẦU') || x.includes('LẤY MÃ STEP') ||
            x.includes('Vui Lòng Đợi') || x.includes('NHẤN ĐỂ TIẾP TỤC') ||
            x.includes('NHẤN LINK BẤT KỲ')
        ) || texts[0];

        if (!status) { window._catbellInterval = setTimeout(run, 1000); return; }

        const hasBtn = !!document.getElementById('countdownBtn');

        if (hasBtn) {
            showMask();
            moveBtnToCenter();
        } else {
            if (maskShown) removeMask();
        }

        if (status.includes('BẮT ĐẦU') || status.includes('LẤY MÃ STEP') || status.includes('NHẤN ĐỂ TIẾP TỤC')) {
            waitAnim = false;
            const m = status.match(/STEP\s*(\d+)/i) || status.match(/(\d+)/);
            const n = m ? parseInt(m[1]) : (currentStep > 0 ? currentStep : 1);

            if (n !== lastStep || currentStep === 0) {
                if (lastStep > 0 && lastStep < n) stDotDone(lastStep);
                lastStep = n;
                setStep(n);
            }

            if (status.includes('NHẤN ĐỂ TIẾP TỤC')) {
                stSet('Cat Bell', 'Tiếp tục...');
                setTimeout(clickBtn, 3000);
            } else {
                stSet('Cat Bell', 'Step ' + n);
                clickBtn();
                if (errT) clearTimeout(errT);
                errT = setTimeout(() => {
                    stSet('Cat Bell', '❌ Không có nhiệm vụ');
                    stSyncDots(currentStep, 'err');
                }, 5000);
            }

        } else if (status.includes('NHẤN LINK BẤT KỲ')) {
            if (errT) clearTimeout(errT);
            if (reloadScheduled) { window._catbellInterval = setTimeout(run, 1000); return; }
            reloadScheduled = true;
            removeMask();
            stDotDone(currentStep);
            sessionStorage.removeItem('cb-step');
            window._catbellRunning = false;
            stSet('Cat Bell', 'Reload sau 5s...');
            setTimeout(() => window.location.reload(), 5000);
            return;

        } else if (status.includes('Vui Lòng Đợi')) {
            if (errT) clearTimeout(errT);
            const sec = parseInt(status.match(/(\d+)/)?.[1] || '1');
            stSet('Cat Bell', 'Đợi ' + sec + 's');
            if (!waitAnim && currentStep > 0) {
                waitAnim = true;
                stDotFill(currentStep, sec);
            }
        }

        window._catbellInterval = setTimeout(run, 1000);
    })();
}, 2000);