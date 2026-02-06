# Script de Configuração Rápida - Smart Monitor AI
# Execute este script para configurar o projeto automaticamente

Write-Host "🎥 Smart Monitor AI - Configuração Automática" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se o Flutter está instalado
Write-Host "📋 Verificando instalação do Flutter..." -ForegroundColor Yellow
$flutterInstalled = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutterInstalled) {
    Write-Host "❌ Flutter não encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale o Flutter: https://docs.flutter.dev/get-started/install" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Flutter encontrado!" -ForegroundColor Green
Write-Host ""

# Executar flutter doctor
Write-Host "🔍 Verificando configuração do Flutter..." -ForegroundColor Yellow
flutter doctor -v
Write-Host ""

# Navegar para o diretório do projeto
$projectPath = "C:\Users\lenovo\Desktop\WEB\smart_monitor"
Write-Host "📁 Navegando para: $projectPath" -ForegroundColor Yellow
Set-Location $projectPath

# Limpar builds anteriores
Write-Host "🧹 Limpando builds anteriores..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Instalar dependências
Write-Host "📦 Instalando dependências..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

# Verificar se há problemas
Write-Host "🔧 Verificando problemas..." -ForegroundColor Yellow
flutter analyze
Write-Host ""

# Solicitar API Key do Gemini
Write-Host "🔑 Configuração da API Key do Google Gemini" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para obter sua API Key, acesse:" -ForegroundColor Yellow
Write-Host "https://makersuite.google.com/app/apikey" -ForegroundColor Blue
Write-Host ""
$apiKey = Read-Host "Digite sua API Key do Google Gemini (ou pressione Enter para pular)"

if ($apiKey) {
    Write-Host "✅ API Key configurada!" -ForegroundColor Green
    Write-Host "⚠️  IMPORTANTE: Edite o arquivo lib/screens/home_screen.dart" -ForegroundColor Yellow
    Write-Host "   e substitua 'SUA_API_KEY_AQUI' por: $apiKey" -ForegroundColor Yellow
    
    # Tentar substituir automaticamente
    $homeScreenPath = "$projectPath\lib\screens\home_screen.dart"
    if (Test-Path $homeScreenPath) {
        (Get-Content $homeScreenPath) -replace 'SUA_API_KEY_AQUI', $apiKey | Set-Content $homeScreenPath
        Write-Host "✅ API Key inserida automaticamente!" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  Você precisará configurar a API Key manualmente depois" -ForegroundColor Yellow
}
Write-Host ""

# Perguntar qual plataforma executar
Write-Host "🚀 Escolha a plataforma para executar:" -ForegroundColor Cyan
Write-Host "1. Web (Chrome)" -ForegroundColor White
Write-Host "2. Android (Emulador/Dispositivo)" -ForegroundColor White
Write-Host "3. Apenas configurar (não executar)" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Digite o número da opção"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🌐 Executando no Chrome..." -ForegroundColor Green
        Write-Host "O app será aberto automaticamente no navegador" -ForegroundColor Yellow
        Write-Host ""
        flutter run -d chrome
    }
    "2" {
        Write-Host ""
        Write-Host "📱 Listando dispositivos disponíveis..." -ForegroundColor Yellow
        flutter devices
        Write-Host ""
        Write-Host "🚀 Executando no Android..." -ForegroundColor Green
        flutter run
    }
    "3" {
        Write-Host ""
        Write-Host "✅ Configuração concluída!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Para executar o app:" -ForegroundColor Cyan
        Write-Host "  Web:     flutter run -d chrome" -ForegroundColor White
        Write-Host "  Android: flutter run" -ForegroundColor White
        Write-Host ""
    }
    default {
        Write-Host "❌ Opção inválida" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📚 Documentação completa: README.md" -ForegroundColor Cyan
Write-Host "🏗️  Arquitetura técnica: ARCHITECTURE.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "✨ Configuração concluída com sucesso!" -ForegroundColor Green
