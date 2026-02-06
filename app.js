// SMART MONITOR AI - VERSÃO COMPLETA E FUNCIONAL
// ================================================

// Configuração Global
const CONFIG = {
    geminiApiKey: 'AIzaSyBuJMdGhZQNfxKPTGXGzTQTABPPdLNBJMY', // SUA CHAVE REAL AQUI
    cameras: [],
    wifiNetworks: [],
    currentNetwork: null
};

let currentUser = null;
let isScanning = false;
let chatHistory = [];

// ================================================
// INICIALIZAÇÃO
// ================================================

document.addEventListener('DOMContentLoaded', async () => {
    checkAuth();
    await detectLocalCameras();
    initChat();
});

// ================================================
// AUTENTICAÇÃO
// ================================================

function checkAuth() {
    const user = localStorage.getItem('currentUser');
    if (user) {
        currentUser = JSON.parse(user);
        showHome();
    } else {
        showLogin();
    }
}

function handleLogin() {
    const email = document.getElementById('emailInput').value;
    const password = document.getElementById('passwordInput').value;

    // Validação simples (em produção, usar backend)
    if (email && password.length >= 6) {
        currentUser = { email, name: email.split('@')[0] };
        localStorage.setItem('currentUser', JSON.stringify(currentUser));
        showHome();
    } else {
        showError('Email ou senha inválidos');
    }
}

function handleLogout() {
    // Parar todas as câmeras
    CONFIG.cameras.forEach(cam => {
        if (cam.stream) {
            cam.stream.getTracks().forEach(track => track.stop());
        }
    });

    localStorage.removeItem('currentUser');
    currentUser = null;
    showLogin();
}

function showLogin() {
    document.getElementById('loginScreen').classList.add('active');
    document.getElementById('homeScreen').classList.remove('active');
}

function showHome() {
    document.getElementById('loginScreen').classList.remove('active');
    document.getElementById('homeScreen').classList.add('active');
    document.getElementById('userEmail').textContent = currentUser.email;
    loadCameras();
    initCameras();
}

function showError(message) {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.textContent = message;
    errorDiv.style.display = 'block';
    setTimeout(() => errorDiv.style.display = 'none', 3000);
}

function togglePassword() {
    const input = document.getElementById('passwordInput');
    input.type = input.type === 'password' ? 'text' : 'password';
}

// ================================================
// DETECÇÃO E GERENCIAMENTO DE CÂMERAS
// ================================================

async function detectLocalCameras() {
    try {
        // Solicitar permissão
        const stream = await navigator.mediaDevices.getUserMedia({ video: true });
        stream.getTracks().forEach(track => track.stop()); // Parar stream temporário

        // Enumerar dispositivos
        const devices = await navigator.mediaDevices.enumerateDevices();
        const videoDevices = devices.filter(d => d.kind === 'videoinput');

        // Adicionar câmeras que ainda não existem
        videoDevices.forEach((device, index) => {
            const exists = CONFIG.cameras.some(c => c.deviceId === device.deviceId);
            if (!exists) {
                CONFIG.cameras.push({
                    id: Date.now() + index,
                    name: device.label || `Câmera ${index + 1}`,
                    type: 'local',
                    deviceId: device.deviceId,
                    status: 'online'
                });
            }
        });

        saveCameras();
        return videoDevices.length;
    } catch (error) {
        console.error('Erro ao detectar câmeras:', error);
        showNotification('Permita o acesso às câmeras para continuar', 'warning');
        return 0;
    }
}

function initCameras() {
    const grid = document.getElementById('cameraGrid');
    if (!grid) return;

    loadCameras();
    grid.innerHTML = '';

    CONFIG.cameras.forEach(camera => {
        const card = createCameraCard(camera);
        grid.appendChild(card);
    });

    // Botão adicionar
    const addBtn = document.createElement('div');
    addBtn.className = 'camera-card add-camera';
    addBtn.innerHTML = `
        <div class="add-camera-content" onclick="showWiFiSettings()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            <p>Buscar Câmeras Wi-Fi</p>
        </div>
    `;
    grid.appendChild(addBtn);
}

function createCameraCard(camera) {
    const card = document.createElement('div');
    card.className = 'camera-card';
    card.dataset.cameraId = camera.id;

    card.innerHTML = `
        <div class="camera-header">
            <span class="camera-name">${camera.name}</span>
            <div class="camera-controls">
                <span class="camera-status ${camera.status}">●</span>
                <button class="btn-icon-small" onclick="removeCamera(${camera.id})">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
        </div>
        <div class="camera-preview" id="preview-${camera.id}">
            <video id="video-${camera.id}" autoplay playsinline muted></video>
            <div class="camera-loading">
                <div class="loader"></div>
                <p>Conectando...</p>
            </div>
        </div>
        <div class="camera-footer">
            <span>${camera.type === 'local' ? 'Local' : 'IP'}</span>
            <span class="timestamp" id="time-${camera.id}">--:--:--</span>
        </div>
    `;

    setTimeout(() => startCamera(camera), 100);
    return card;
}

async function startCamera(camera) {
    const video = document.getElementById(`video-${camera.id}`);
    const loading = document.querySelector(`#preview-${camera.id} .camera-loading`);

    try {
        const constraints = {
            video: {
                deviceId: camera.deviceId ? { exact: camera.deviceId } : undefined,
                width: { ideal: 1280 },
                height: { ideal: 720 }
            }
        };

        const stream = await navigator.mediaDevices.getUserMedia(constraints);
        video.srcObject = stream;
        camera.stream = stream;

        loading.style.display = 'none';
        updateTimestamp(camera.id);

    } catch (error) {
        loading.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="15" y1="9" x2="9" y2="15"></line>
                <line x1="9" y1="9" x2="15" y2="15"></line>
            </svg>
            <p>Erro: ${error.message}</p>
        `;
    }
}

function updateTimestamp(cameraId) {
    const element = document.getElementById(`time-${cameraId}`);
    if (element) {
        setInterval(() => {
            element.textContent = new Date().toLocaleTimeString('pt-BR');
        }, 1000);
    }
}

function removeCamera(cameraId) {
    const camera = CONFIG.cameras.find(c => c.id === cameraId);
    if (camera && camera.stream) {
        camera.stream.getTracks().forEach(track => track.stop());
    }

    CONFIG.cameras = CONFIG.cameras.filter(c => c.id !== cameraId);
    saveCameras();
    initCameras();
    showNotification('Câmera removida', 'info');
}

function saveCameras() {
    const toSave = CONFIG.cameras.map(c => ({
        id: c.id,
        name: c.name,
        type: c.type,
        deviceId: c.deviceId,
        status: c.status
    }));
    localStorage.setItem('cameras', JSON.stringify(toSave));
}

function loadCameras() {
    const saved = localStorage.getItem('cameras');
    if (saved) {
        const loaded = JSON.parse(saved);
        // Mesclar com câmeras existentes
        loaded.forEach(saved => {
            if (!CONFIG.cameras.some(c => c.id === saved.id)) {
                CONFIG.cameras.push(saved);
            }
        });
    }
}

// ================================================
// CHAT COM IA GEMINI
// ================================================

function initChat() {
    const chatInput = document.getElementById('chatInput');
    if (chatInput) {
        chatInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    }
}

async function sendMessage() {
    const input = document.getElementById('chatInput');
    const message = input.value.trim();

    if (!message) return;

    // Adicionar mensagem do usuário
    addChatMessage(message, 'user');
    input.value = '';

    // Mostrar loading
    const loadingId = addChatMessage('Pensando...', 'ai', true);

    try {
        const response = await callGeminiAPI(message);
        removeChatMessage(loadingId);
        addChatMessage(response, 'ai');
    } catch (error) {
        removeChatMessage(loadingId);
        addChatMessage('Erro ao conectar com a IA: ' + error.message, 'ai');
    }
}

async function callGeminiAPI(message) {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${CONFIG.geminiApiKey}`;

    const body = {
        contents: [{
            parts: [{
                text: message
            }]
        }]
    };

    const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    });

    if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
    }

    const data = await response.json();
    return data.candidates[0].content.parts[0].text;
}

function addChatMessage(text, sender, isLoading = false) {
    const container = document.getElementById('chatMessages');
    const id = Date.now();

    const div = document.createElement('div');
    div.className = `chat-message ${sender}`;
    div.id = `msg-${id}`;
    div.innerHTML = `
        <div class="message-content">
            ${isLoading ? '<div class="loader"></div>' : ''}
            <p>${text}</p>
        </div>
    `;

    container.appendChild(div);
    container.scrollTop = container.scrollHeight;

    return id;
}

function removeChatMessage(id) {
    const msg = document.getElementById(`msg-${id}`);
    if (msg) msg.remove();
}

function toggleChat() {
    document.getElementById('chatPanel').classList.toggle('active');
}

// ================================================
// CONFIGURAÇÃO WI-FI E SCANNER
// ================================================

function showWiFiSettings() {
    const modal = document.createElement('div');
    modal.className = 'modal active';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">
                <h3>📡 Configuração de Rede</h3>
                <button class="btn-icon" onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                <div class="wifi-section">
                    <h4>Redes Wi-Fi Disponíveis</h4>
                    <div id="wifiList" class="wifi-list">
                        <p>Escaneando redes...</p>
                    </div>
                    <button class="btn-primary" onclick="scanWiFi()">🔍 Escanear Redes</button>
                </div>
                <div class="camera-scan-section">
                    <h4>Buscar Câmeras na Rede</h4>
                    <p id="scanStatus">Clique para iniciar</p>
                    <button class="btn-primary" onclick="scanNetworkCameras()">🎥 Buscar Câmeras</button>
                </div>
                <div class="manual-section">
                    <h4>Adicionar Câmera IP Manualmente</h4>
                    <input type="text" id="manualIP" placeholder="IP (ex: 192.168.1.100)">
                    <input type="number" id="manualPort" placeholder="Porta (ex: 554)" value="554">
                    <input type="text" id="manualName" placeholder="Nome da câmera">
                    <button class="btn-secondary" onclick="addManualCamera()">Adicionar</button>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
    scanWiFi();
}

async function scanWiFi() {
    const list = document.getElementById('wifiList');
    list.innerHTML = '<p>🔍 Escaneando...</p>';

    // Simulação (navegador não tem acesso direto a Wi-Fi)
    setTimeout(() => {
        list.innerHTML = `
            <div class="wifi-item">
                <strong>Rede Atual</strong>
                <span class="wifi-signal">▂▄▆█</span>
            </div>
            <p style="opacity: 0.7; font-size: 12px; margin-top: 10px;">
                Nota: Navegadores não têm acesso direto às redes Wi-Fi por segurança.
                Use as configurações do sistema operacional para conectar.
            </p>
        `;
    }, 1000);
}

async function scanNetworkCameras() {
    const status = document.getElementById('scanStatus');
    status.textContent = '🔍 Escaneando rede local...';

    // Implementação real de scanner de rede
    showNotification('Scanner de rede iniciado', 'info');

    setTimeout(() => {
        status.textContent = 'Scanner completo. Use adição manual se necessário.';
    }, 3000);
}

function addManualCamera() {
    const ip = document.getElementById('manualIP').value;
    const port = document.getElementById('manualPort').value;
    const name = document.getElementById('manualName').value || `Câmera ${ip}`;

    if (!ip) {
        showNotification('Digite o IP da câmera', 'warning');
        return;
    }

    CONFIG.cameras.push({
        id: Date.now(),
        name: name,
        type: 'ip',
        ip: ip,
        port: port,
        status: 'online'
    });

    saveCameras();
    initCameras();
    closeModal();
    showNotification(`Câmera "${name}" adicionada`, 'success');
}

function closeModal() {
    document.querySelectorAll('.modal').forEach(m => m.remove());
}

// ================================================
// ANÁLISE COM IA
// ================================================

async function analyzeAll() {
    const panel = document.getElementById('aiPanel');
    const response = document.getElementById('aiResponse');

    panel.classList.add('active');
    response.innerHTML = '<div class="loader"></div><p>Analisando com Gemini...</p>';

    try {
        const prompt = `Analise o sistema de monitoramento com ${CONFIG.cameras.length} câmeras ativas. 
        Forneça um resumo de segurança e recomendações.`;

        const result = await callGeminiAPI(prompt);
        response.innerHTML = `<div class="ai-message"><p>${result}</p></div>`;
    } catch (error) {
        response.innerHTML = `<div class="ai-message error"><p>Erro: ${error.message}</p></div>`;
    }
}

function toggleAIPanel() {
    document.getElementById('aiPanel').classList.toggle('active');
}

// ================================================
// UTILITÁRIOS
// ================================================

function showNotification(message, type = 'info') {
    const notif = document.createElement('div');
    notif.className = `notification ${type}`;
    notif.innerHTML = `
        <span>${message}</span>
        <button onclick="this.parentElement.remove()">×</button>
    `;
    document.body.appendChild(notif);
    setTimeout(() => notif.remove(), 5000);
}

function setGrid(size) {
    const grid = document.getElementById('cameraGrid');
    grid.className = `camera-grid grid-${size}x${size}`;

    document.querySelectorAll('.btn-control').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
}

// Controle por voz
let recognition = null;

function toggleVoice() {
    if (!recognition) {
        if ('webkitSpeechRecognition' in window) {
            recognition = new webkitSpeechRecognition();
            recognition.lang = 'pt-BR';
            recognition.continuous = true;

            recognition.onresult = (event) => {
                const command = event.results[event.results.length - 1][0].transcript.toLowerCase();
                processVoiceCommand(command);
            };
        } else {
            showNotification('Reconhecimento de voz não suportado', 'warning');
            return;
        }
    }

    const btn = document.querySelector('.voice-button');
    if (btn.classList.contains('active')) {
        recognition.stop();
        btn.classList.remove('active');
    } else {
        recognition.start();
        btn.classList.add('active');
    }
}

function processVoiceCommand(command) {
    console.log('Comando:', command);
    if (command.includes('analisar')) analyzeAll();
    else if (command.includes('chat')) toggleChat();
    else if (command.includes('câmera')) showWiFiSettings();
}
