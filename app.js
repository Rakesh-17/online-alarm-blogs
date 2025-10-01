// =========================
// Utility Functions
// =========================
function pad(num, size = 2) {
  return num.toString().padStart(size, '0');
}
function getCurrentTime() {
  const now = new Date();
  let hour = now.getHours();
  const minute = now.getMinutes();
  const second = now.getSeconds();
  const ampm = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if (hour === 0) hour = 12;
  return { hour, minute, second, ampm };
}
function to24Hour(hour, ampm) {
  hour = parseInt(hour, 10);
  if (ampm === 'AM') {
    if (hour === 12) return 0;
    return hour;
  } else {
    if (hour === 12) return 12;
    return hour + 12;
  }
}
// =========================
// Real-time Clock
// =========================
function updateClock() {
  const { hour, minute, second, ampm } = getCurrentTime();
  document.getElementById('clock').textContent = `${pad(hour)}:${pad(minute)}:${pad(second)}`;
  document.getElementById('clock-ampm').textContent = ampm;
}
setInterval(updateClock, 1000);
updateClock();
// =========================
// Alarm Management
// =========================
const alarmSounds = {
  classic: document.getElementById('audio-classic'),
  digital: document.getElementById('audio-digital'),
  chime: document.getElementById('audio-chime'),
  buzzer: document.getElementById('audio-buzzer'),
  birds: document.getElementById('audio-birds'),
};
const SNOOZE_MINUTES = 5;
let alarms = [];
let currentRingingAlarm = null;
let alarmTimeout = null;
function populateAlarmInputs() {
  const hourSel = document.getElementById('alarm-hour');
  const minSel = document.getElementById('alarm-minute');
  hourSel.innerHTML = '';
  minSel.innerHTML = '';
  for (let h = 1; h <= 12; h++) {
    hourSel.innerHTML += `<option value="${h}">${pad(h)}</option>`;
  }
  for (let m = 0; m < 60; m++) {
    minSel.innerHTML += `<option value="${m}">${pad(m)}</option>`;
  }
}
populateAlarmInputs();
function saveAlarms() {
  localStorage.setItem('alarms', JSON.stringify(alarms));
}
function loadAlarms() {
  const data = localStorage.getItem('alarms');
  if (data) {
    alarms = JSON.parse(data);
  } else {
    alarms = [];
  }
}
function renderAlarms() {
  const list = document.getElementById('alarms-list');
  list.innerHTML = '';
  if (alarms.length === 0) {
    list.innerHTML = '<li class="text-gray-500 text-center">No alarms set.</li>';
    return;
  }
  alarms.forEach((alarm, idx) => {
    const li = document.createElement('li');
    li.className = "flex items-center justify-between bg-indigo-50 rounded-lg px-4 py-3";
    const info = document.createElement('div');
    info.className = "flex flex-col";
    info.innerHTML = `
      <span class="text-lg font-semibold text-gray-900">${pad(alarm.hour)}:${pad(alarm.minute)} ${alarm.ampm}</span>
      <span class="text-sm text-gray-600">${alarm.label ? alarm.label : ''}</span>
      <span class="text-xs text-gray-400">${alarm.enabled ? 'Enabled' : 'Disabled'} | ${alarm.sound.charAt(0).toUpperCase() + alarm.sound.slice(1)}</span>
    `;
    const controls = document.createElement('div');
    controls.className = "flex items-center gap-2";
    const toggle = document.createElement('button');
    toggle.setAttribute('aria-label', alarm.enabled ? 'Disable alarm' : 'Enable alarm');
    toggle.className = `w-12 h-7 flex items-center rounded-lg transition ${alarm.enabled ? 'bg-indigo-600' : 'bg-gray-300'}`;
    toggle.innerHTML = `
      <span class="inline-block w-5 h-5 bg-white rounded-full shadow transform transition ${alarm.enabled ? 'translate-x-5' : 'translate-x-1'}"></span>
    `;
    toggle.addEventListener('click', () => {
      alarm.enabled = !alarm.enabled;
      saveAlarms();
      renderAlarms();
    });
    const del = document.createElement('button');
    del.setAttribute('aria-label', 'Delete alarm');
    del.className = "bg-red-500 hover:bg-red-600 text-white rounded-lg px-3 py-1 font-semibold transition";
    del.textContent = "Delete";
    del.addEventListener('click', () => {
      alarms.splice(idx, 1);
      saveAlarms();
      renderAlarms();
    });
    controls.appendChild(toggle);
    controls.appendChild(del);
    li.appendChild(info);
    li.appendChild(controls);
    list.appendChild(li);
  });
}
document.getElementById('alarm-form').addEventListener('submit', function(e) {
  e.preventDefault();
  const hour = document.getElementById('alarm-hour').value;
  const minute = document.getElementById('alarm-minute').value;
  const ampm = document.getElementById('alarm-ampm').value;
  const label = document.getElementById('alarm-label').value.trim();
  const sound = document.getElementById('alarm-sound').value;
  const volume = parseFloat(document.getElementById('alarm-volume').value);
  if (isNaN(hour) || isNaN(minute)) return;
  if (alarms.length >= 10) {
    showModal('Limit Reached', 'You can only set up to 10 alarms.', [
      { text: 'OK', action: closeModal, style: 'bg-indigo-600' }
    ]);
    return;
  }
  alarms.push({
    id: Date.now() + Math.random(),
    hour: parseInt(hour, 10),
    minute: parseInt(minute, 10),
    ampm,
    label,
    enabled: true,
    sound,
    volume,
    snoozeUntil: null
  });
  saveAlarms();
  renderAlarms();
  this.reset();
  document.getElementById('alarm-volume').value = 0.7;
});
setInterval(() => {
  const now = new Date();
  alarms.forEach((alarm, idx) => {
    if (!alarm.enabled) return;
    if (alarm.snoozeUntil) {
      if (now >= new Date(alarm.snoozeUntil)) {
        triggerAlarm(idx);
      }
      return;
    }
    let alarmHour24 = to24Hour(alarm.hour, alarm.ampm);
    if (
      now.getHours() === alarmHour24 &&
      now.getMinutes() === alarm.minute &&
      now.getSeconds() === 0
    ) {
      triggerAlarm(idx);
    }
  });
}, 1000);
function triggerAlarm(idx) {
  if (currentRingingAlarm !== null) return;
  const alarm = alarms[idx];
  currentRingingAlarm = idx;
  playAlarmSound(alarm.sound, alarm.volume, true);
  showModal(
    'Alarm Ringing',
    `${pad(alarm.hour)}:${pad(alarm.minute)} ${alarm.ampm}${alarm.label ? ' - ' + alarm.label : ''}`,
    [
      { text: 'Snooze', action: () => snoozeAlarm(idx), style: 'bg-yellow-500' },
      { text: 'Stop', action: () => stopAlarm(idx), style: 'bg-red-500' }
    ]
  );
}
function playAlarmSound(sound, volume, loop = false) {
  stopAllSounds();
  const audio = alarmSounds[sound] || alarmSounds['classic'];
  audio.currentTime = 0;
  audio.volume = volume;
  audio.loop = loop;
  audio.play();
}
function stopAllSounds() {
  Object.values(alarmSounds).forEach(audio => {
    audio.pause();
    audio.currentTime = 0;
    audio.loop = false;
  });
}
function snoozeAlarm(idx) {
  stopAllSounds();
  closeModal();
  const alarm = alarms[idx];
  const now = new Date();
  now.setMinutes(now.getMinutes() + SNOOZE_MINUTES);
  alarm.snoozeUntil = now.toISOString();
  saveAlarms();
  currentRingingAlarm = null;
  renderAlarms();
}
function stopAlarm(idx) {
  stopAllSounds();
  closeModal();
  const alarm = alarms[idx];
  alarm.enabled = false;
  alarm.snoozeUntil = null;
  saveAlarms();
  currentRingingAlarm = null;
  renderAlarms();
}
// =========================
// Modal Dialog
// =========================
function showModal(title, message, actions) {
  const overlay = document.getElementById('modal-overlay');
  document.getElementById('modal-title').textContent = title;
  document.getElementById('modal-message').textContent = message;
  const actionsDiv = document.getElementById('modal-actions');
  actionsDiv.innerHTML = '';
  actions.forEach(({ text, action, style }) => {
    const btn = document.createElement('button');
    btn.textContent = text;
    btn.className = `${style} hover:brightness-110 text-white font-semibold rounded-lg px-4 py-2 transition min-w-[80px]`;
    btn.addEventListener('click', action);
    btn.addEventListener('touchstart', action);
    actionsDiv.appendChild(btn);
  });
  overlay.classList.remove('hidden');
}
function closeModal() {
  document.getElementById('modal-overlay').classList.add('hidden');
  stopAllSounds();
  currentRingingAlarm = null;
}
document.getElementById('modal-overlay').addEventListener('click', function(e) {
  if (e.target === this) closeModal();
});
document.getElementById('alarm-sound').addEventListener('change', function() {
  const sound = this.value;
  const volume = parseFloat(document.getElementById('alarm-volume').value);
  playAlarmSound(sound, volume, false);
  setTimeout(stopAllSounds, 1500);
});
document.getElementById('alarm-volume').addEventListener('input', function() {
  const sound = document.getElementById('alarm-sound').value;
  const volume = parseFloat(this.value);
  playAlarmSound(sound, volume, false);
  setTimeout(stopAllSounds, 1000);
});
loadAlarms();
renderAlarms();
// =========================
// Countdown Timer
// =========================
let timerInterval = null;
let timerRemaining = 0;
let timerRunning = false;
function updateTimerDisplay() {
  let t = timerRemaining;
  const h = Math.floor(t / 3600);
  t %= 3600;
  const m = Math.floor(t / 60);
  const s = t % 60;
  document.getElementById('timer-display').textContent = `${pad(h)}:${pad(m)}:${pad(s)}`;
}
function startTimer() {
  if (timerRunning || timerRemaining <= 0) return;
  timerRunning = true;
  timerInterval = setInterval(() => {
    if (timerRemaining > 0) {
      timerRemaining--;
      updateTimerDisplay();
      if (timerRemaining === 0) {
        timerRunning = false;
        clearInterval(timerInterval);
        playAlarmSound('classic', 0.8, false);
        showModal('Timer Finished', 'Countdown timer has reached zero.', [
          { text: 'OK', action: closeModal, style: 'bg-indigo-600' }
        ]);
      }
    }
  }, 1000);
}
function pauseTimer() {
  timerRunning = false;
  clearInterval(timerInterval);
}
function resetTimer() {
  pauseTimer();
  timerRemaining = 0;
  updateTimerDisplay();
}
document.getElementById('timer-form').addEventListener('submit', function(e) {
  e.preventDefault();
  const h = parseInt(document.getElementById('timer-hours').value, 10) || 0;
  const m = parseInt(document.getElementById('timer-minutes').value, 10) || 0;
  const s = parseInt(document.getElementById('timer-seconds').value, 10) || 0;
  if (h < 0 || m < 0 || s < 0 || m > 59 || s > 59) {
    showModal('Invalid Input', 'Please enter valid timer values.', [
      { text: 'OK', action: closeModal, style: 'bg-indigo-600' }
    ]);
    return;
  }
  timerRemaining = h * 3600 + m * 60 + s;
  if (timerRemaining <= 0) {
    showModal('Invalid Input', 'Timer duration must be greater than zero.', [
      { text: 'OK', action: closeModal, style: 'bg-indigo-600' }
    ]);
    return;
  }
  updateTimerDisplay();
  startTimer();
});
document.getElementById('timer-pause').addEventListener('click', pauseTimer);
document.getElementById('timer-reset').addEventListener('click', resetTimer);
updateTimerDisplay();
// =========================
// Stopwatch
// =========================
let stopwatchInterval = null;
let stopwatchStart = null;
let stopwatchElapsed = 0;
let stopwatchRunning = false;
let laps = [];
function updateStopwatchDisplay() {
  let ms = stopwatchElapsed;
  const h = Math.floor(ms / 3600000);
  ms %= 3600000;
  const m = Math.floor(ms / 60000);
  ms %= 60000;
  const s = Math.floor(ms / 1000);
  ms %= 1000;
  document.getElementById('stopwatch-display').textContent = `${pad(h)}:${pad(m)}:${pad(s)}.${ms.toString().padStart(3, '0')}`;
}
function startStopwatch() {
  if (stopwatchRunning) return;
  stopwatchRunning = true;
  stopwatchStart = Date.now() - stopwatchElapsed;
  stopwatchInterval = setInterval(() => {
    stopwatchElapsed = Date.now() - stopwatchStart;
    updateStopwatchDisplay();
  }, 31);
}
function stopStopwatch() {
  if (!stopwatchRunning) return;
  stopwatchRunning = false;
  clearInterval(stopwatchInterval);
}
function resetStopwatch() {
  stopStopwatch();
  stopwatchElapsed = 0;
  laps = [];
  updateStopwatchDisplay();
  renderLaps();
}
function lapStopwatch() {
  if (!stopwatchRunning) return;
  laps.push(stopwatchElapsed);
  renderLaps();
}
function renderLaps() {
  const ul = document.getElementById('stopwatch-laps');
  ul.innerHTML = '';
  if (laps.length === 0) return;
  laps.forEach((lap, idx) => {
    let ms = lap;
    const h = Math.floor(ms / 3600000);
    ms %= 3600000;
    const m = Math.floor(ms / 60000);
    ms %= 60000;
    const s = Math.floor(ms / 1000);
    ms %= 1000;
    const li = document.createElement('li');
    li.className = "bg-indigo-50 rounded-lg px-3 py-1 text-gray-800";
    li.textContent = `Lap ${idx + 1}: ${pad(h)}:${pad(m)}:${pad(s)}.${ms.toString().padStart(3, '0')}`;
    ul.appendChild(li);
  });
}
document.getElementById('stopwatch-start').addEventListener('click', startStopwatch);
document.getElementById('stopwatch-stop').addEventListener('click', stopStopwatch);
document.getElementById('stopwatch-reset').addEventListener('click', resetStopwatch);
document.getElementById('stopwatch-lap').addEventListener('click', lapStopwatch);
document.getElementById('stopwatch-start').addEventListener('touchstart', startStopwatch);
document.getElementById('stopwatch-stop').addEventListener('touchstart', stopStopwatch);
document.getElementById('stopwatch-reset').addEventListener('touchstart', resetStopwatch);
document.getElementById('stopwatch-lap').addEventListener('touchstart', lapStopwatch);
updateStopwatchDisplay();
document.querySelectorAll('button').forEach(btn => {
  btn.classList.add('min-h-[44px]', 'min-w-[44px]');
});
// =========================
// Dark Mode Toggle
// =========================
const darkModeToggle = document.getElementById('dark-mode-toggle');
const darkModeIcon = document.getElementById('dark-mode-icon');
const htmlEl = document.documentElement;

function setDarkMode(enabled) {
  if (enabled) {
    htmlEl.classList.add('dark');
    // Change to sun icon
    darkModeIcon.innerHTML = '<path id="sun-icon" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m8.66-13.66l-.71.71M4.05 19.07l-.71.71M21 12h-1M4 12H3m16.66 5.66l-.71-.71M4.05 4.93l-.71-.71M16 12a4 4 0 11-8 0 4 4 0 018 0z" />';
  } else {
    htmlEl.classList.remove('dark');
    // Change to moon icon
    darkModeIcon.innerHTML = '<path id="moon-icon" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12.79A9 9 0 1111.21 3a7 7 0 109.79 9.79z" />';
  }
  localStorage.setItem('darkMode', enabled ? '1' : '0');
}

darkModeToggle.addEventListener('click', () => {
  const isDark = htmlEl.classList.contains('dark');
  setDarkMode(!isDark);
});

// On load, apply dark mode if set
(function() {
  const darkPref = localStorage.getItem('darkMode');
  if (darkPref === '1' || (darkPref === null && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    setDarkMode(true);
  } else {
    setDarkMode(false);
  }
})();

// =========================
// Sidebar Menu Toggle
// =========================
const sidebarToggle = document.getElementById('sidebar-toggle');
const sidebarMenu = document.getElementById('sidebar-menu');
const sidebarOverlay = document.getElementById('sidebar-overlay');
const sidebarClose = document.getElementById('sidebar-close');

function openSidebar() {
  sidebarMenu.classList.remove('-translate-x-full');
  sidebarOverlay.classList.remove('hidden');
  setTimeout(() => sidebarOverlay.classList.add('opacity-100'), 10);
  // Trap focus
  sidebarMenu.setAttribute('tabindex', '-1');
  sidebarMenu.focus();
}
function closeSidebar() {
  sidebarMenu.classList.add('-translate-x-full');
  sidebarOverlay.classList.remove('opacity-100');
  setTimeout(() => sidebarOverlay.classList.add('hidden'), 300);
}
sidebarToggle.addEventListener('click', openSidebar);
sidebarClose.addEventListener('click', closeSidebar);
sidebarOverlay.addEventListener('click', closeSidebar);
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closeSidebar();
}); 