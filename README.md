# 🎥 Smart Monitor AI - Guia de Instalação e Execução

Sistema de Monitoramento Inteligente Multiplataforma com IA

## 📋 Pré-requisitos

### Ferramentas Necessárias
- **Flutter SDK** (versão 3.0.0 ou superior)
- **Android Studio** ou **VS Code** com extensões Flutter
- **Google Chrome** (para execução web)
- **Dispositivo Android/iOS** ou **Emulador** (para mobile)

### Contas e APIs
- **Google Gemini API Key**: Obtenha em [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey)
- **Firebase** (opcional): Para logs e persistência

---

## 🚀 Instalação

### 1. Instalar Flutter

#### Windows
```powershell
# Baixe o Flutter SDK
# https://docs.flutter.dev/get-started/install/windows

# Adicione ao PATH
$env:Path += ";C:\src\flutter\bin"

# Verifique a instalação
flutter doctor
```

#### Linux/Mac
```bash
# Clone o repositório Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verifique a instalação
flutter doctor
```

### 2. Configurar o Projeto

```powershell
# Navegue até o diretório do projeto
cd C:\Users\lenovo\Desktop\WEB\smart_monitor

# Instale as dependências
flutter pub get

# Verifique se há problemas
flutter doctor -v
```

### 3. Configurar API Key do Gemini

Edite o arquivo `lib/screens/home_screen.dart` e substitua `'SUA_API_KEY_AQUI'` pela sua chave:

```dart
// Linha ~40
aiProvider.initializeGemini('SUA_CHAVE_API_GEMINI_AQUI');
```

### 4. Configurar Permissões

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Adicione estas permissões -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <uses-feature android:name="android.hardware.camera" />
    <uses-feature android:name="android.hardware.camera.autofocus" />
</manifest>
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<dict>
    <!-- Adicione estas chaves -->
    <key>NSCameraUsageDescription</key>
    <string>Precisamos acessar a câmera para monitoramento</string>
    
    <key>NSMicrophoneUsageDescription</key>
    <string>Precisamos acessar o microfone para comandos de voz</string>
    
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>Precisamos do reconhecimento de voz para comandos</string>
</dict>
```

#### Web (`web/index.html`)
```html
<!-- Já configurado automaticamente pelo Flutter -->
```

---

## 🌐 Executar na Web

### Método 1: Chrome (Recomendado)
```powershell
# Execute no Chrome
flutter run -d chrome --web-renderer html

# Ou para desenvolvimento
flutter run -d chrome
```

### Método 2: Edge
```powershell
flutter run -d edge
```

### Método 3: Build para Produção
```powershell
# Gere o build otimizado
flutter build web --release

# Os arquivos estarão em: build/web/
# Você pode hospedar em qualquer servidor web
```

**Acesse**: `http://localhost:PORTA` (a porta será exibida no terminal)

---

## 📱 Executar no Mobile

### Android

#### Emulador
```powershell
# Liste os emuladores disponíveis
flutter emulators

# Inicie um emulador
flutter emulators --launch <emulator_id>

# Execute o app
flutter run
```

#### Dispositivo Físico
```powershell
# 1. Ative o modo desenvolvedor no Android
# 2. Ative a depuração USB
# 3. Conecte o dispositivo via USB

# Liste dispositivos conectados
flutter devices

# Execute no dispositivo
flutter run -d <device_id>
```

### iOS (Apenas no macOS)

```bash
# Abra o projeto iOS
open ios/Runner.xcworkspace

# No Xcode, selecione o dispositivo/simulador
# Pressione Run ou execute:
flutter run -d <device_id>
```

### Build para Produção

#### Android APK
```powershell
# Gere o APK
flutter build apk --release

# APK estará em: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (Google Play)
```powershell
flutter build appbundle --release
```

#### iOS (macOS)
```bash
flutter build ios --release
```

---

## 🎮 Como Usar

### 1. Inicialização
- O app detectará automaticamente todas as câmeras disponíveis
- Câmeras físicas aparecerão no grid
- Um slot "Adicionar Câmera IP" estará disponível

### 2. Adicionar Câmera IP
1. Clique no card "Adicionar Câmera IP"
2. Preencha:
   - **Nome**: Ex: "Câmera da Porta"
   - **Protocolo**: RTSP, HTTP ou HTTPS
   - **URL**: Ex: `rtsp://192.168.1.100:554/stream`
3. Clique em "Adicionar"

### 3. Comandos de Voz
Clique no botão flutuante de microfone e diga:

- **"Analisar todas"** - Analisa todas as câmeras
- **"Analisar câmera da porta"** - Analisa câmera específica
- **"Grade 2"** / **"Grade 3"** / **"Grade 4"** - Muda layout do grid
- **"Câmera 1"** / **"Câmera 2"** - Seleciona câmera

### 4. Análise com IA
- Clique em **"Analisar Todas"** no painel inferior
- A IA analisará cada câmera e fornecerá:
  - Descrição da cena
  - Pessoas detectadas
  - Objetos importantes
  - Alertas de segurança
  - Recomendações

### 5. Painel de IA
- Clique em **"Painel IA"** para ver/ocultar as respostas
- As análises são exibidas em texto
- A resposta também é falada em voz alta

---

## 🔧 Solução de Problemas

### Erro: "Camera permission denied"
```powershell
# Certifique-se de que as permissões estão no AndroidManifest.xml
# Desinstale e reinstale o app
flutter clean
flutter pub get
flutter run
```

### Erro: "Gemini API error"
- Verifique se a API Key está correta
- Verifique se a API está habilitada no Google Cloud Console
- Verifique sua conexão com a internet

### Erro: "Speech recognition not available"
```powershell
# Certifique-se de que as permissões de microfone estão configuradas
# No Android, vá em Configurações > Apps > Smart Monitor > Permissões
```

### Web: Câmera não detectada
- Use HTTPS ou localhost
- Permita acesso à câmera no navegador
- Verifique se nenhum outro app está usando a câmera

### Performance lenta
```powershell
# Execute em modo release
flutter run --release

# Ou reduza a resolução das câmeras em camera_provider.dart
# Linha ~50: ResolutionPreset.medium (ao invés de .high)
```

---

## 📁 Estrutura do Projeto

```
smart_monitor/
├── lib/
│   ├── main.dart                    # Ponto de entrada
│   ├── models/
│   │   └── camera_source.dart       # Modelo de dados
│   ├── providers/
│   │   ├── camera_provider.dart     # Gerenciamento de câmeras
│   │   ├── ai_provider.dart         # Integração Gemini
│   │   └── voice_provider.dart      # Controle de voz
│   ├── screens/
│   │   └── home_screen.dart         # Tela principal
│   └── widgets/
│       ├── camera_grid.dart         # Grid de câmeras
│       ├── camera_view_card.dart    # Card individual
│       ├── add_ip_camera_dialog.dart # Diálogo IP
│       ├── control_panel.dart       # Painel de controle
│       ├── ai_response_panel.dart   # Painel de IA
│       └── voice_control_button.dart # Botão de voz
├── android/                         # Configurações Android
├── ios/                             # Configurações iOS
├── web/                             # Configurações Web
└── pubspec.yaml                     # Dependências
```

---

## 🎨 Recursos Implementados

✅ **Detecção Automática de Câmeras**
- Lista todas as câmeras físicas disponíveis
- Identifica nome real do dispositivo (Web)
- Alterna entre frontal/traseira (Mobile)

✅ **Suporte a Câmeras IP**
- Adicionar câmeras via RTSP/HTTP
- Gerenciar múltiplas câmeras IP
- Remover câmeras IP

✅ **Grid Dinâmico**
- Layout 1x1, 2x2, 3x3, 4x4
- Visualização independente de cada câmera
- Nome/marca do dispositivo no topo

✅ **Integração Google Gemini**
- Modelo Gemini 1.5 Flash
- Análise contextual de imagens
- Processamento de múltiplas câmeras

✅ **Comandos de Voz**
- Reconhecimento de voz em português
- Comandos para análise e controle
- Respostas em áudio (TTS)

✅ **Interface Premium**
- Design moderno com gradientes
- Animações suaves
- Tema dark profissional
- Indicadores de status em tempo real

---

## 🔐 Segurança

⚠️ **IMPORTANTE**: 
- Nunca compartilhe sua API Key do Gemini
- Use variáveis de ambiente em produção
- Configure regras de segurança no Firebase
- Use HTTPS para câmeras IP em produção

---

## 📞 Suporte

Para problemas ou dúvidas:
1. Verifique a seção "Solução de Problemas"
2. Execute `flutter doctor -v` e verifique os erros
3. Consulte a documentação do Flutter: [https://docs.flutter.dev](https://docs.flutter.dev)

---

## 📄 Licença

Este projeto é fornecido como está, para fins educacionais e de desenvolvimento.

---

**Desenvolvido com Flutter 💙**
