// Smart Monitor AI - Web App
// Configurações e Estado Global
const CONFIG = {
    users: [
        { email: 'admin@smartmonitor.com', password: 'Admin@123456', name: 'Administrador' },
        { email: 'demo@smartmonitor.com', password: 'Demo@123456', name: 'Demo User' }
    ],
    geminiApiKey: 'AIzaSyDemoKey', // Substituir pela chave real
    cameras: [
        { id: 1, name: 'Câmera Principal', type: 'device', status: 'online' },
        { id: 2, name: 'Câmera da Porta', type: 'ip', url: 'rtsp://example.com', status: 'online' },
        { id: 3, name: 'Câmera da Garagem', type: 'ip', url: 'http://example.com', status: 'online' }
    ]
};

let currentUser = null;
let isVoiceActive = false;
let currentGrid = 2;

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
            <p>Adicionar Câmera IP</p>
        </div>
    `;
    addBtn.onclick = () => alert('Funcionalidade em desenvolvimento');
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
    // Implementar notificações toast
    console.log(`[${type}] ${message}`);
}
