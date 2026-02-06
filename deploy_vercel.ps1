# Script de Deploy Automático para Vercel - Smart Monitor AI

Write-Host "🚀 Deploy Automático - Smart Monitor AI" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "C:\Users\lenovo\Desktop\WEB\smart_monitor"
Set-Location $projectPath

# Verificar Flutter
Write-Host "📋 Verificando Flutter..." -ForegroundColor Yellow
$flutterInstalled = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutterInstalled) {
    Write-Host "❌ Flutter não encontrado!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Flutter encontrado!" -ForegroundColor Green
Write-Host ""

# Limpar builds anteriores
Write-Host "🧹 Limpando builds anteriores..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Instalar dependências
Write-Host "📦 Instalando dependências..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

# Build para Web
Write-Host "🔨 Construindo para Web..." -ForegroundColor Yellow
flutter build web --release --web-renderer canvaskit

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro no build!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Build concluído!" -ForegroundColor Green
Write-Host ""

# Verificar Vercel CLI
Write-Host "📋 Verificando Vercel CLI..." -ForegroundColor Yellow
$vercelInstalled = Get-Command vercel -ErrorAction SilentlyContinue

if (-not $vercelInstalled) {
    Write-Host "⚠️  Vercel CLI não encontrado!" -ForegroundColor Yellow
    Write-Host "Instalando Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

Write-Host "✅ Vercel CLI pronto!" -ForegroundColor Green
Write-Host ""

# Escolher método de deploy
Write-Host "🚀 Escolha o método de deploy:" -ForegroundColor Cyan
Write-Host "1. Deploy via Vercel CLI (Manual)" -ForegroundColor White
Write-Host "2. Instruções para deploy via GitHub (Automático)" -ForegroundColor White
Write-Host "3. Apenas build (não fazer deploy)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Digite o número da opção"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "📤 Fazendo deploy via Vercel CLI..." -ForegroundColor Green
        Write-Host ""
        
        Set-Location build/web
        vercel --prod
        
        Write-Host ""
        Write-Host "✅ Deploy concluído!" -ForegroundColor Green
        Write-Host "Seu app está disponível no link exibido acima ☝️" -ForegroundColor Cyan
    }
    
    "2" {
        Write-Host ""
        Write-Host "📚 INSTRUÇÕES PARA DEPLOY VIA GITHUB:" -ForegroundColor Cyan
        Write-Host "=====================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1️⃣  Envie o código para o GitHub:" -ForegroundColor Yellow
        Write-Host "   .\init_github.ps1" -ForegroundColor White
        Write-Host ""
        Write-Host "2️⃣  Acesse: https://vercel.com" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "3️⃣  Faça login com GitHub" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "4️⃣  Clique em 'Add New Project'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "5️⃣  Importe o repositório 'smart-monitor-ai'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "6️⃣  Configure:" -ForegroundColor Yellow
        Write-Host "   - Framework: Other" -ForegroundColor White
        Write-Host "   - Build Command: flutter build web --release" -ForegroundColor White
        Write-Host "   - Output Directory: build/web" -ForegroundColor White
        Write-Host "   - Install Command: flutter pub get" -ForegroundColor White
        Write-Host ""
        Write-Host "7️⃣  Clique em 'Deploy'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "✅ Pronto! Seu app estará em: https://smart-monitor-ai.vercel.app" -ForegroundColor Green
    }
    
    "3" {
        Write-Host ""
        Write-Host "✅ Build concluído!" -ForegroundColor Green
        Write-Host "Arquivos estão em: build/web/" -ForegroundColor Cyan
    }
    
    default {
        Write-Host "❌ Opção inválida" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📚 Documentação completa: DEPLOY_VERCEL.md" -ForegroundColor Cyan
Write-Host ""

# Mostrar credenciais
Write-Host "🔐 CREDENCIAIS DE ACESSO:" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""
Write-Host "👤 Admin:" -ForegroundColor Yellow
Write-Host "   Email: admin@smartmonitor.com" -ForegroundColor White
Write-Host "   Senha: Admin@123456" -ForegroundColor White
Write-Host ""
Write-Host "👤 Demo:" -ForegroundColor Yellow
Write-Host "   Email: demo@smartmonitor.com" -ForegroundColor White
Write-Host "   Senha: Demo@123456" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  IMPORTANTE: Altere as senhas após o primeiro login!" -ForegroundColor Red
Write-Host ""

# Lembrete Firebase
Write-Host "🔥 LEMBRETE: Configure o Firebase!" -ForegroundColor Yellow
Write-Host "===================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Crie projeto em: https://console.firebase.google.com" -ForegroundColor White
Write-Host "2. Habilite Authentication (Email/Password)" -ForegroundColor White
Write-Host "3. Habilite Firestore Database" -ForegroundColor White
Write-Host "4. Crie os usuários no Authentication" -ForegroundColor White
Write-Host "5. Atualize as credenciais em lib/main.dart" -ForegroundColor White
Write-Host ""

Write-Host "✨ Deploy preparado com sucesso! 🚀" -ForegroundColor Green
