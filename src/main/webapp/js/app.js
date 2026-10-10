// ============================================================
// Aetheria — Core Frontend Logic
// Clock | Theme Toggle | Mood Fetch | Burnout Widget |
// Voice Command | Live Presence | Downloadable Card
// ============================================================

/* ---------- 24h Clock + Date ---------- */
function updateClock() {
    const el = document.getElementById('ambient-clock');
    if (!el) return;
    const now = new Date();
    const time = now.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit', hour12: false });
    const day = now.toLocaleDateString('en-US', { weekday: 'long' });
    el.textContent = `${day} · ${time}`;
}
setInterval(updateClock, 1000 * 30);
updateClock();

/* ---------- Dark / Light Mode Toggle ---------- */
function initTheme() {
    const saved = localStorage.getItem('aetheria-theme') || 'light';
    document.documentElement.setAttribute('data-theme', saved);
}
function toggleTheme() {
    const current = document.documentElement.getAttribute('data-theme');
    const next = current === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('aetheria-theme', next);
}
initTheme();

/* ---------- Mood-Based Session Fetch (Fetch API) ---------- */
async function fetchMoodSessions(mood) {
    try {
        const res = await fetch(`${window.CONTEXT_PATH}/api/sessions?mood=${mood}`);
        const data = await res.json();
        renderSessions(data.sessions);
        if (data.burnoutDetected) {
            showBurnoutWidget(mood);
        }
    } catch (e) {
        console.error('Could not fetch sessions', e);
    }
}

function renderSessions(sessions) {
    const container = document.getElementById('session-results');
    if (!container) return;
    container.innerHTML = '';
    sessions.forEach(s => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${s.title}</h3>
            <p style="color:var(--slate); font-size:0.9rem;">${s.description || ''}</p>
            <p style="margin:0.5rem 0; font-size:0.85rem;">${s.duration} minutes</p>
            <button class="btn jelly" onclick="startSession(${s.id}, ${s.duration})">Start Session</button>
        `;
        container.appendChild(card);
    });
}

/* ---------- Burnout Detector: Floating Conversational Widget ---------- */
const burnoutMessages = {
    OVERWHELMED: "Hey, I've noticed you've been feeling overwhelmed a lot this week. Want to try a longer Deep Recovery session instead?",
    CANT_SLEEP: "Sleep has been tough for you lately. A longer wind-down session might help more than usual tonight.",
    LOW_ENERGY: "Your energy has been low several times this week. Let's try something restorative instead of a quick fix.",
    UNFOCUSED: "Focus has been slipping a lot lately. A deeper recovery session might help reset things."
};

function showBurnoutWidget(mood) {
    const widget = document.getElementById('burnout-widget');
    const msg = document.getElementById('burnout-message');
    if (!widget || !msg) return;
    msg.textContent = burnoutMessages[mood] || "It looks like this week has been heavy. Let's slow down together.";
    widget.classList.add('show');
}
function dismissBurnout() {
    document.getElementById('burnout-widget')?.classList.remove('show');
}
function acceptBurnoutSuggestion() {
    fetchMoodSessions('RECOVERY_DIRECT');
    dismissBurnout();
    document.getElementById('session-results')?.scrollIntoView({ behavior: 'smooth' });
}

/* ---------- Live Presence Counter (simulated, visual-only) ---------- */
function showLivePresence() {
    const el = document.getElementById('live-presence');
    if (!el) return;
    const count = 8 + Math.floor(Math.random() * 20); // simulated range
    document.getElementById('live-count').textContent = count;
    el.classList.add('active');
}
function hideLivePresence() {
    document.getElementById('live-presence')?.classList.remove('active');
}

/* ---------- Start / Complete a Session ---------- */
let activeSessionDuration = 0;
let activeSessionId = null;

function startSession(sessionId, duration) {
    activeSessionId = sessionId;
    activeSessionDuration = duration;
    showLivePresence();
    alert(`Starting "${duration} minute" session. Click "Mark Complete" on your dashboard once finished.`);
}

async function completeSession() {
    try {
        const res = await fetch(`${window.CONTEXT_PATH}/api/complete-session`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `sessionId=${activeSessionId || ''}&duration=${activeSessionDuration || 10}`
        });
        const data = await res.json();
        hideLivePresence();
        updateStreakUI(data.streak);
        generateCompletionCard(data.duration, data.streak);
    } catch (e) {
        console.error('Could not log completion', e);
    }
}

function updateStreakUI(streak) {
    const el = document.getElementById('streak-count');
    if (el) el.textContent = streak;
    const stageEl = document.getElementById('garden-stage');
    if (stageEl) {
        if (streak >= 14) stageEl.textContent = '🌳';
        else if (streak >= 7) stageEl.textContent = '🌿';
        else if (streak >= 3) stageEl.textContent = '🌱';
        else stageEl.textContent = '🌰';
    }
}

/* ---------- Downloadable Completion Card (HTML5 Canvas) ---------- */
function generateCompletionCard(duration, streak) {
    const canvas = document.createElement('canvas');
    canvas.width = 800; canvas.height = 500;
    const ctx = canvas.getContext('2d');

    // Background gradient (ASMR palette)
    const grad = ctx.createLinearGradient(0, 0, 800, 500);
    grad.addColorStop(0, '#FBF9F5');
    grad.addColorStop(1, '#E6E1D5');
    ctx.fillStyle = grad;
    ctx.fillRect(0, 0, 800, 500);

    ctx.fillStyle = '#8A9A86';
    ctx.beginPath();
    ctx.arc(400, 170, 80, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = '#1F2421';
    ctx.font = 'bold 36px Segoe UI';
    ctx.textAlign = 'center';
    ctx.fillText('Aetheria', 400, 300);

    ctx.font = '22px Segoe UI';
    ctx.fillStyle = '#6C7D8E';
    ctx.fillText(`I meditated for ${duration} minutes today`, 400, 350);

    ctx.font = '18px Segoe UI';
    ctx.fillStyle = '#C88A75';
    ctx.fillText(`🔥 Current streak: ${streak} days`, 400, 390);

    ctx.font = 'italic 16px Segoe UI';
    ctx.fillStyle = '#6C7D8E';
    ctx.fillText('"Stillness is where clarity begins."', 400, 440);

    const link = document.createElement('a');
    link.download = `aetheria-session-${Date.now()}.png`;
    link.href = canvas.toDataURL('image/png');
    link.click();
}

/* ---------- Voice Command (Web Speech API, free/built-in) ---------- */
function initVoiceCommand() {
    const micBtn = document.getElementById('mic-btn');
    const input = document.getElementById('command-input');
    if (!micBtn || !input) return;

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition) {
        micBtn.style.display = 'none';
        return;
    }

    const recognition = new SpeechRecognition();
    recognition.continuous = false;
    recognition.lang = 'en-US';

    micBtn.addEventListener('click', () => {
        micBtn.classList.add('listening');
        recognition.start();
    });

    recognition.onresult = (event) => {
        const transcript = event.results[0][0].transcript;
        input.value = transcript;
        handleCommand(transcript);
    };
    recognition.onend = () => micBtn.classList.remove('listening');
    recognition.onerror = () => micBtn.classList.remove('listening');
}

function handleCommand(text) {
    const lower = text.toLowerCase();
    if (lower.includes('breath')) fetchMoodSessions('UNFOCUSED');
    else if (lower.includes('sleep')) fetchMoodSessions('CANT_SLEEP');
    else if (lower.includes('overwhelm') || lower.includes('stress')) fetchMoodSessions('OVERWHELMED');
    else if (lower.includes('energy') || lower.includes('tired')) fetchMoodSessions('LOW_ENERGY');
    else if (lower.includes('ocean') || lower.includes('rain') || lower.includes('sound')) {
        window.location.href = `${window.CONTEXT_PATH}/soundscapes.jsp`;
    } else {
        alert(`Heard: "${text}" — try saying "I'm overwhelmed", "help me sleep", "I'm unfocused", or "low energy".`);
    }
}

document.addEventListener('DOMContentLoaded', initVoiceCommand);

/* ---------- Micro-Journal Popup ---------- */
async function submitJournal() {
    const text = document.getElementById('journal-input')?.value;
    if (!text || !text.trim()) return;
    try {
        await fetch(`${window.CONTEXT_PATH}/api/journal`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `entryText=${encodeURIComponent(text)}`
        });
        document.getElementById('journal-input').value = '';
        document.getElementById('journal-popup')?.classList.remove('show');
        alert('Reflection saved. 🌿');
    } catch (e) {
        console.error('Could not save journal entry', e);
    }
}
function openJournalPopup() {
    document.getElementById('journal-popup')?.classList.add('show');
}
function closeJournalPopup() {
    document.getElementById('journal-popup')?.classList.remove('show');
}
