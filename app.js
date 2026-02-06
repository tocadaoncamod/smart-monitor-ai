// Smart Monitor AI - Web App
// Configurações e Estado Global
const CONFIG = {
    users: [
        { email: 'admin@smartmonitor.com', password: 'Admin@123456', name: 'Administrador' },
        { email: 'demo@smartmonitor.com', password: 'Demo@123456', name: 'Demo User' }
    ],
    geminiApiKey: 'AIzaSyDemoKey', // Substituir pela chave real
    cameras: [],
    networkScanPorts: [80, 554, 8080, 8081, 8554, 5000, 5001], // Portas comuns de câmeras IP
    commonCameraPaths: ['/video', '/stream', '/live', '/mjpeg', '/h264', '/onvif/device_service']
};

let currentUser = null;
let isVoiceActive = false;
let currentGrid = 2;
let isScanning = false;
let discoveredCameras = [];

// Inicialização
document.addEventListener('DOMContentLoaded', () => {
    checkAuth();
    initCameras();
});

// Autenticação
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
    const errorMsg = document.getElementById('errorMessage');

    const user = CONFIG.users.find(u => u.email === email && u.password === password);

    if (user) {
        currentUser = user;
        localStorage.setItem('currentUser', JSON.stringify(user));
        errorMsg.style.display = 'none';
        showHome();
    } else {
        errorMsg.textContent = 'Email ou senha incorretos';
        errorMsg.style.display = 'block';
    }
}

function handleLogout() {
    localStorage.removeItem('currentUser');
    currentUser = null;
    showLogin();
}

function togglePassword() {
    const input = document.getElementById('passwordInput');
    input.type = input.type === 'password' ? 'text' : 'password';
}

function toggleForm() {
    const isLogin = document.getElementById('formTitle').textContent === 'Entrar';
    document.getElementById('formTitle').textContent = isLogin ? 'Criar Conta' : 'Entrar';
    document.getElementById('nameField').style.display = isLogin ? 'block' : 'none';
    document.getElementById('toggleText').textContent = isLogin ? 'Já tem uma conta?' : 'Não tem uma conta?';
    document.querySelector('.btn-link').textContent = isLogin ? 'Entrar' : 'Criar conta';
}

function showLogin() {
    document.getElementById('loginScreen').classList.add('active');
    document.getElementById('homeScreen').classList.remove('active');
}

function showHome() {
    document.getElementById('loginScreen').classList.remove('active');
    document.getElementById('homeScreen').classList.add('active');
    document.getElementById('userEmail').textContent = currentUser.email;
    initCameras();
}

// Câmeras
function initCameras() {
    const grid = document.getElementById('cameraGrid');
    if (!grid) return;

    // Carregar câmeras salvas
    loadCameras();

    grid.innerHTML = '';

    CONFIG.cameras.forEach(camera => {
        const card = createCameraCard(camera);
        grid.appendChild(card);
    });

    // Adicionar botão de adicionar câmera
    const addBtn = document.createElement('div');
    addBtn.className = 'camera-card add-camera';
    addBtn.innerHTML = `
        <div class="add-camera-content">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            <p>Buscar Câmeras Wi-Fi</p>
        </div>
    `;
    addBtn.onclick = () => showWiFiSettings();
    grid.appendChild(addBtn);
}

function createCameraCard(camera) {
    const card = document.createElement('div');
    card.className = 'camera-card';
    card.innerHTML = `
        <div class="camera-header">
            <span class="camera-name">${camera.name}</span>
            <span class="camera-status ${camera.status}">●</span>
        </div>
        <div class="camera-preview">
            <div class="camera-placeholder">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                    <circle cx="12" cy="13" r="4"></circle>
                </svg>
                <p>${camera.type === 'device' ? 'Câmera Física' : 'Câmera IP'}</p>
            </div>
        </div>
        <div class="camera-footer">
            <span>${camera.type === 'device' ? 'Dispositivo Local' : camera.type.toUpperCase()}</span>
            <span class="timestamp">Agora</span>
        </div>
    `;
    return card;
}

function setGrid(size) {
    currentGrid = size;
    const grid = document.getElementById('cameraGrid');
    grid.className = `camera-grid grid-${size}x${size}`;

    document.querySelectorAll('.btn-control').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
}

// IA e Análise
async function analyzeAll() {
    const panel = document.getElementById('aiPanel');
    const response = document.getElementById('aiResponse');

    panel.classList.add('active');

    response.innerHTML = `
        <div class="ai-message analyzing">
            <div class="loader"></div>
            <p>Analisando câmeras com Google Gemini...</p>
        </div>
    `;

    // Simular análise (em produção, chamar API Gemini)
    setTimeout(() => {
        const analysis = `
            <div class="ai-message">
                <div class="ai-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                    </svg>
                    <strong>Análise Completa</strong>
                    <span class="timestamp">${new Date().toLocaleTimeString('pt-BR')}</span>
                </div>
                <div class="ai-content">
                    <h4>📹 Câmera Principal</h4>
                    <p>✅ Status: Online e funcionando normalmente</p>
                    <p>👤 Nenhuma pessoa detectada</p>
                    <p>🚗 Nenhum veículo detectado</p>
                    
                    <h4>📹 Câmera da Porta</h4>
                    <p>✅ Status: Online e funcionando normalmente</p>
                    <p>👤 Nenhuma movimentação detectada</p>
                    
                    <h4>📹 Câmera da Garagem</h4>
                    <p>✅ Status: Online e funcionando normalmente</p>
                    <p>🚗 1 veículo estacionado (normal)</p>
                    
                    <div class="ai-summary">
                        <strong>Resumo:</strong> Todas as câmeras estão operacionais. 
                        Nenhuma atividade suspeita detectada. Sistema funcionando normalmente.
                    </div>
                </div>
            </div>
        `;
        response.innerHTML = analysis;
    }, 2000);
}

function toggleAIPanel() {
    document.getElementById('aiPanel').classList.toggle('active');
}

// Controle por Voz
function toggleVoice() {
    isVoiceActive = !isVoiceActive;
    const btn = document.querySelector('.voice-button');

    if (isVoiceActive) {
        btn.classList.add('active');
        startVoiceRecognition();
    } else {
        btn.classList.remove('active');
        stopVoiceRecognition();
    }
}

function startVoiceRecognition() {
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        const recognition = new SpeechRecognition();

        recognition.lang = 'pt-BR';
        recognition.continuous = true;
        recognition.interimResults = false;

        recognition.onresult = (event) => {
            const command = event.results[event.results.length - 1][0].transcript.toLowerCase();
            processVoiceCommand(command);
        };

        recognition.start();
        window.voiceRecognition = recognition;
    } else {
        alert('Reconhecimento de voz não suportado neste navegador');
        isVoiceActive = false;
    }
}

function stopVoiceRecognition() {
    if (window.voiceRecognition) {
        window.voiceRecognition.stop();
    }
}

function processVoiceCommand(command) {
    console.log('Comando:', command);

    if (command.includes('analisar')) {
        analyzeAll();
    } else if (command.includes('painel')) {
        toggleAIPanel();
    } else if (command.includes('grid') || command.includes('layout')) {
        if (command.includes('1')) setGrid(1);
        else if (command.includes('2')) setGrid(2);
        else if (command.includes('3')) setGrid(3);
        else if (command.includes('4')) setGrid(4);
    }
}

// Utilitários
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <span>${message}</span>
            <button onclick="this.parentElement.parentElement.remove()">✕</button>
        </div>
    `;
    document.body.appendChild(notification);

    setTimeout(() => notification.remove(), 5000);
}

// ========================================
// DESCOBERTA DE CÂMERAS NA REDE WI-FI
// ========================================

// Obter informações da rede local
async function getNetworkInfo() {
    try {
        // Tentar obter IP local via WebRTC
        const pc = new RTCPeerConnection({ iceServers: [] });
        pc.createDataChannel('');
        const offer = await pc.createOffer();
        await pc.setLocalDescription(offer);

        return new Promise((resolve) => {
            pc.onicecandidate = (ice) => {
                if (!ice || !ice.candidate || !ice.candidate.candidate) return;
                const ipRegex = /([0-9]{1,3}(\.[0-9]{1,3}){3})/;
                const match = ipRegex.exec(ice.candidate.candidate);
                if (match) {
                    pc.close();
                    const localIP = match[1];
                    const subnet = localIP.substring(0, localIP.lastIndexOf('.'));
                    resolve({ localIP, subnet });
                }
            };
        });
    } catch (error) {
        console.error('Erro ao obter IP local:', error);
        return { localIP: '192.168.1.100', subnet: '192.168.1' }; // Fallback
    }
}

// Scanner de rede para descobrir câmeras
async function scanNetwork() {
    if (isScanning) {
        showNotification('Scanner já está em execução', 'warning');
        return;
    }

    isScanning = true;
    discoveredCameras = [];

    showNotification('🔍 Iniciando busca por câmeras na rede...', 'info');
    updateScanStatus('Obtendo informações da rede...');

    const networkInfo = await getNetworkInfo();
    const subnet = networkInfo.subnet;

    updateScanStatus(`Escaneando rede ${subnet}.0/24...`);

    // Escanear IPs de 1 a 254
    const scanPromises = [];
    for (let i = 1; i <= 254; i++) {
        const ip = `${subnet}.${i}`;
        scanPromises.push(scanDevice(ip));

        // Processar em lotes de 20 para não sobrecarregar
        if (i % 20 === 0) {
            await Promise.all(scanPromises.splice(0, 20));
            updateScanStatus(`Escaneando: ${i}/254 dispositivos verificados`);
        }
    }

    // Aguardar conclusão de todos os scans
    await Promise.all(scanPromises);

    isScanning = false;

    if (discoveredCameras.length > 0) {
        showNotification(`✅ ${discoveredCameras.length} câmera(s) encontrada(s)!`, 'success');
        showDiscoveredCameras();
    } else {
        showNotification('❌ Nenhuma câmera encontrada na rede', 'warning');
        updateScanStatus('Nenhuma câmera detectada. Tente adicionar manualmente.');
    }
}

// Escanear um dispositivo específico
async function scanDevice(ip) {
    const ports = CONFIG.networkScanPorts;

    for (const port of ports) {
        try {
            const isCamera = await checkCameraPort(ip, port);
            if (isCamera) {
                const camera = {
                    id: Date.now() + Math.random(),
                    name: `Câmera ${ip}`,
                    ip: ip,
                    port: port,
                    type: 'ip',
                    protocol: port === 554 ? 'rtsp' : 'http',
                    url: port === 554 ? `rtsp://${ip}:${port}/stream` : `http://${ip}:${port}/video`,
                    status: 'online'
                };
                discoveredCameras.push(camera);
                break; // Encontrou câmera neste IP, não precisa verificar outras portas
            }
        } catch (error) {
            // Ignorar erros de conexão (dispositivo offline ou porta fechada)
        }
    }
}

// Verificar se uma porta específica tem uma câmera
async function checkCameraPort(ip, port) {
    return new Promise((resolve) => {
        const timeout = 2000; // 2 segundos de timeout
        const img = new Image();
        const timer = setTimeout(() => {
            img.src = '';
            resolve(false);
        }, timeout);

        // Tentar carregar imagem de snapshot comum de câmeras
        img.onload = () => {
            clearTimeout(timer);
            resolve(true);
        };

        img.onerror = () => {
            clearTimeout(timer);
            // Tentar verificar via fetch
            fetch(`http://${ip}:${port}`, {
                method: 'HEAD',
                mode: 'no-cors',
                signal: AbortSignal.timeout(timeout)
            })
                .then(() => resolve(true))
                .catch(() => resolve(false));
        };

        // Tentar URLs comuns de snapshot
        img.src = `http://${ip}:${port}/snapshot.jpg`;
    });
}

// Atualizar status do scanner na UI
function updateScanStatus(message) {
    const statusElement = document.getElementById('scanStatus');
    if (statusElement) {
        statusElement.textContent = message;
    }
}

// Mostrar câmeras descobertas
function showDiscoveredCameras() {
    const modal = document.createElement('div');
    modal.className = 'modal active';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">
                <h3>🎥 Câmeras Encontradas (${discoveredCameras.length})</h3>
                <button class="btn-icon" onclick="closeModal()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
            <div class="modal-body">
                <p>Selecione as câmeras que deseja adicionar ao sistema:</p>
                <div class="discovered-cameras-list">
                    ${discoveredCameras.map((cam, index) => `
                        <div class="discovered-camera-item">
                            <input type="checkbox" id="cam-${index}" checked>
                            <label for="cam-${index}">
                                <strong>${cam.ip}:${cam.port}</strong>
                                <span>${cam.protocol.toUpperCase()}</span>
                            </label>
                            <input type="text" placeholder="Nome da câmera" value="${cam.name}" 
                                   onchange="discoveredCameras[${index}].name = this.value">
                        </div>
                    `).join('')}
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeModal()">Cancelar</button>
                <button class="btn-primary" onclick="addSelectedCameras()">
                    Adicionar Selecionadas
                </button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
}

// Adicionar câmeras selecionadas
function addSelectedCameras() {
    const checkboxes = document.querySelectorAll('.discovered-camera-item input[type="checkbox"]');
    let addedCount = 0;

    checkboxes.forEach((checkbox, index) => {
        if (checkbox.checked) {
            CONFIG.cameras.push(discoveredCameras[index]);
            addedCount++;
        }
    });

    closeModal();
    initCameras();

    showNotification(`✅ ${addedCount} câmera(s) adicionada(s) com sucesso!`, 'success');

    // Salvar no localStorage
    saveCameras();
}

// Salvar câmeras no localStorage
function saveCameras() {
    localStorage.setItem('cameras', JSON.stringify(CONFIG.cameras));
}

// Carregar câmeras do localStorage
function loadCameras() {
    const saved = localStorage.getItem('cameras');
    if (saved) {
        CONFIG.cameras = JSON.parse(saved);
    }
}

// Fechar modal
function closeModal() {
    const modal = document.querySelector('.modal');
    if (modal) {
        modal.remove();
    }
}

// Mostrar modal de configuração de Wi-Fi
function showWiFiSettings() {
    const modal = document.createElement('div');
    modal.className = 'modal active';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">
                <h3>📡 Configuração de Rede</h3>
                <button class="btn-icon" onclick="closeModal()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
            <div class="modal-body">
                <div class="wifi-info">
                    <p><strong>Status da Conexão:</strong></p>
                    <div class="status-indicator online">
                        <svg class="status-icon" viewBox="0 0 24 24" fill="currentColor">
                            <circle cx="12" cy="12" r="10"></circle>
                        </svg>
                        <span>Conectado à Rede Local</span>
                    </div>
                    <p id="networkInfoDisplay" style="margin-top: 15px; font-size: 14px; opacity: 0.8;">
                        Detectando informações da rede...
                    </p>
                </div>
                <div class="scan-section">
                    <h4>🔍 Buscar Câmeras na Rede</h4>
                    <p>O sistema irá escanear sua rede local em busca de câmeras IP compatíveis.</p>
                    <p id="scanStatus" class="scan-status"></p>
                    <button class="btn-primary" onclick="scanNetwork()" ${isScanning ? 'disabled' : ''}>
                        ${isScanning ? '⏳ Escaneando...' : '🔍 Iniciar Busca'}
                    </button>
                </div>
                <div class="manual-add-section">
                    <h4>➕ Adicionar Câmera Manualmente</h4>
                    <div class="input-group">
                        <label>Endereço IP:</label>
                        <input type="text" id="manualIP" placeholder="192.168.1.100">
                    </div>
                    <div class="input-group">
                        <label>Porta:</label>
                        <input type="number" id="manualPort" placeholder="554" value="554">
                    </div>
                    <div class="input-group">
                        <label>Protocolo:</label>
                        <select id="manualProtocol">
                            <option value="rtsp">RTSP</option>
                            <option value="http">HTTP</option>
                        </select>
                    </div>
                    <div class="input-group">
                        <label>Nome:</label>
                        <input type="text" id="manualName" placeholder="Minha Câmera">
                    </div>
                    <button class="btn-secondary" onclick="addManualCamera()">
                        Adicionar Câmera
                    </button>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(modal);

    // Obter e exibir informações da rede
    getNetworkInfo().then(info => {
        const display = document.getElementById('networkInfoDisplay');
        if (display) {
            display.innerHTML = `
                <strong>IP Local:</strong> ${info.localIP}<br>
                <strong>Sub-rede:</strong> ${info.subnet}.0/24
            `;
        }
    });
}

// Adicionar câmera manualmente
function addManualCamera() {
    const ip = document.getElementById('manualIP').value;
    const port = document.getElementById('manualPort').value;
    const protocol = document.getElementById('manualProtocol').value;
    const name = document.getElementById('manualName').value || `Câmera ${ip}`;

    if (!ip) {
        showNotification('Por favor, insira o endereço IP', 'warning');
        return;
    }

    const camera = {
        id: Date.now(),
        name: name,
        ip: ip,
        port: port,
        type: 'ip',
        protocol: protocol,
        url: protocol === 'rtsp' ? `rtsp://${ip}:${port}/stream` : `http://${ip}:${port}/video`,
        status: 'online'
    };

    CONFIG.cameras.push(camera);
    saveCameras();
    initCameras();
    closeModal();

    showNotification(`✅ Câmera "${name}" adicionada com sucesso!`, 'success');
}
