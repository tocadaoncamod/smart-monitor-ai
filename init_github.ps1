# Script para Inicializar Repositório GitHub - Smart Monitor AI

Write-Host "🚀 Inicializando Repositório GitHub" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "C:\Users\lenovo\Desktop\WEB\smart_monitor"
Set-Location $projectPath

# Verificar se Git está instalado
Write-Host "📋 Verificando instalação do Git..." -ForegroundColor Yellow
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitInstalled) {
    Write-Host "❌ Git não encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale o Git: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Git encontrado!" -ForegroundColor Green
Write-Host ""

# Inicializar repositório
Write-Host "📁 Inicializando repositório Git..." -ForegroundColor Yellow
git init

# Configurar usuário (se necessário)
$userName = git config user.name
if (-not $userName) {
    Write-Host ""
    Write-Host "⚙️ Configuração do Git" -ForegroundColor Cyan
    $name = Read-Host "Digite seu nome"
    $email = Read-Host "Digite seu email"
    
    git config user.name "$name"
    git config user.email "$email"
    
    Write-Host "✅ Configuração salva!" -ForegroundColor Green
}

Write-Host ""

# Adicionar todos os arquivos
Write-Host "📦 Adicionando arquivos ao Git..." -ForegroundColor Yellow
git add .

# Criar commit inicial
Write-Host "💾 Criando commit inicial..." -ForegroundColor Yellow
git commit -m "feat: Initial commit - Smart Monitor AI v1.0

- Sistema de monitoramento multiplataforma
- Integração com Google Gemini AI
- Suporte a câmeras físicas e IP
- Controle por voz em português
- Interface premium com Flutter
- Banco de dados Firebase
- Documentação completa"

Write-Host "✅ Commit criado!" -ForegroundColor Green
Write-Host ""

# Instruções para criar repositório no GitHub
Write-Host "📝 PRÓXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Acesse: https://github.com/new" -ForegroundColor White
Write-Host "2. Crie um novo repositório chamado: smart-monitor-ai" -ForegroundColor White
Write-Host "3. NÃO inicialize com README, .gitignore ou licença" -ForegroundColor Yellow
Write-Host "4. Copie a URL do repositório (ex: https://github.com/SEU_USUARIO/smart-monitor-ai.git)" -ForegroundColor White
Write-Host ""

$repoUrl = Read-Host "Cole a URL do seu repositório GitHub aqui"

if ($repoUrl) {
    Write-Host ""
    Write-Host "🔗 Conectando ao repositório remoto..." -ForegroundColor Yellow
    
    git remote add origin $repoUrl
    git branch -M main
    
    Write-Host ""
    Write-Host "📤 Enviando código para o GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    Write-Host ""
    Write-Host "✅ Código enviado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 Repositório criado em: $repoUrl" -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "⚠️ URL não fornecida. Execute manualmente:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "git remote add origin URL_DO_SEU_REPOSITORIO" -ForegroundColor White
    Write-Host "git branch -M main" -ForegroundColor White
    Write-Host "git push -u origin main" -ForegroundColor White
}

Write-Host ""
Write-Host "📚 Comandos Git Úteis:" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ver status:           git status" -ForegroundColor White
Write-Host "Adicionar arquivos:   git add ." -ForegroundColor White
Write-Host "Fazer commit:         git commit -m 'mensagem'" -ForegroundColor White
Write-Host "Enviar para GitHub:   git push" -ForegroundColor White
Write-Host "Atualizar local:      git pull" -ForegroundColor White
Write-Host "Ver histórico:        git log" -ForegroundColor White
Write-Host ""
Write-Host "✨ Repositório pronto! Boa codificação! 🚀" -ForegroundColor Green
