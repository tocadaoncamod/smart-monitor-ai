# ⚡ COMANDOS RÁPIDOS - Smart Monitor AI

## 🚀 Início Rápido

### Setup Automático (Recomendado)
```powershell
cd C:\Users\lenovo\Desktop\WEB\smart_monitor
.\setup.ps1
```

---

## 📦 Instalação Manual

### 1. Verificar Flutter
```powershell
flutter doctor -v
```

### 2. Limpar e Instalar
```powershell
flutter clean
flutter pub get
```

### 3. Verificar Problemas
```powershell
flutter analyze
```

---

## 🌐 Executar na Web

### Chrome (Desenvolvimento)
```powershell
flutter run -d chrome
```

### Chrome (Modo Release)
```powershell
flutter run -d chrome --release
```

### Build para Produção
```powershell
flutter build web --release
```

### Servir Build Local
```powershell
cd build/web
python -m http.server 8000
# Acesse: http://localhost:8000
```

---

## 📱 Executar no Mobile

### Listar Dispositivos
```powershell
flutter devices
```

### Listar Emuladores
```powershell
flutter emulators
```

### Iniciar Emulador
```powershell
flutter emulators --launch <emulator_id>
```

### Executar no Dispositivo
```powershell
flutter run
```

### Executar em Dispositivo Específico
```powershell
flutter run -d <device_id>
```

### Modo Release
```powershell
flutter run --release
```

---

## 🔨 Build para Produção

### Android APK
```powershell
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)
```powershell
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS apenas)
```bash
flutter build ios --release
```

### Web
```powershell
flutter build web --release
# Output: build/web/
```

---

## 🧪 Testes

### Testes Unitários
```powershell
flutter test
```

### Testes com Coverage
```powershell
flutter test --coverage
```

### Análise de Código
```powershell
flutter analyze
```

---

## 🔧 Manutenção

### Atualizar Dependências
```powershell
flutter pub upgrade
```

### Verificar Dependências Desatualizadas
```powershell
flutter pub outdated
```

### Limpar Cache
```powershell
flutter clean
flutter pub cache repair
```

### Reinstalar Tudo
```powershell
flutter clean
rm -r pubspec.lock
flutter pub get
```

---

## 🐛 Debug

### Logs em Tempo Real
```powershell
flutter logs
```

### Hot Reload (durante execução)
```
Pressione 'r' no terminal
```

### Hot Restart (durante execução)
```
Pressione 'R' no terminal
```

### Abrir DevTools
```powershell
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 📊 Performance

### Análise de Performance
```powershell
flutter run --profile
```

### Análise de Build Size
```powershell
flutter build apk --analyze-size
```

### Trace de Performance
```powershell
flutter run --trace-startup
```

---

## 🔐 Configuração de API Key

### Editar Manualmente
```powershell
notepad lib\screens\home_screen.dart
# Substitua 'SUA_API_KEY_AQUI' pela sua chave
```

### Via PowerShell
```powershell
$apiKey = "SUA_CHAVE_AQUI"
(Get-Content lib\screens\home_screen.dart) -replace 'SUA_API_KEY_AQUI', $apiKey | Set-Content lib\screens\home_screen.dart
```

---

## 📱 Permissões

### Verificar Permissões Android
```powershell
notepad android\app\src\main\AndroidManifest.xml
```

### Verificar Permissões iOS
```powershell
notepad ios\Runner\Info.plist
```

---

## 🌐 Web - Configurações

### Habilitar CORS (Desenvolvimento)
```powershell
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

### Usar Renderer HTML
```powershell
flutter run -d chrome --web-renderer html
```

### Usar Renderer CanvasKit
```powershell
flutter run -d chrome --web-renderer canvaskit
```

---

## 📦 Gerenciamento de Pacotes

### Adicionar Pacote
```powershell
flutter pub add <package_name>
```

### Remover Pacote
```powershell
flutter pub remove <package_name>
```

### Ver Dependências
```powershell
flutter pub deps
```

---

## 🔄 Git (Opcional)

### Inicializar Repositório
```powershell
git init
git add .
git commit -m "Initial commit: Smart Monitor AI"
```

### Criar .gitignore
```powershell
# Flutter já cria automaticamente
# Verifique: .gitignore
```

---

## 📚 Documentação

### Abrir README
```powershell
notepad README.md
```

### Abrir Arquitetura
```powershell
notepad ARCHITECTURE.md
```

### Abrir Resumo
```powershell
notepad RESUMO_EXECUTIVO.md
```

---

## 🎯 Atalhos Úteis

### Executar Web Rapidamente
```powershell
flutter run -d chrome
```

### Build APK Rapidamente
```powershell
flutter build apk --release
```

### Limpar e Executar
```powershell
flutter clean && flutter pub get && flutter run
```

### Verificar Tudo
```powershell
flutter doctor -v && flutter analyze
```

---

## 🆘 Solução Rápida de Problemas

### Erro de Permissões
```powershell
flutter clean
flutter pub get
flutter run
```

### Erro de Gradle (Android)
```powershell
cd android
.\gradlew clean
cd ..
flutter run
```

### Erro de Pods (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### Erro de Cache
```powershell
flutter pub cache repair
flutter clean
flutter pub get
```

---

## 📞 Ajuda

### Ajuda do Flutter
```powershell
flutter --help
```

### Ajuda de Comando Específico
```powershell
flutter run --help
flutter build --help
```

### Versão do Flutter
```powershell
flutter --version
```

---

## 🎉 Pronto para Começar!

Execute o setup automático:
```powershell
.\setup.ps1
```

Ou execute manualmente:
```powershell
flutter pub get
flutter run -d chrome
```

---

**Dica**: Salve este arquivo como referência rápida! 📌
