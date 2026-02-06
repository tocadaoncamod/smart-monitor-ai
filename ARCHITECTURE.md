# 📐 Arquitetura Técnica - Smart Monitor AI

## Visão Geral

O Smart Monitor AI é um sistema de monitoramento inteligente multiplataforma construído com Flutter, que integra visão computacional via Google Gemini AI, controle por voz e suporte para múltiplas fontes de câmera.

---

## 🏗️ Arquitetura

### Camadas da Aplicação

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Screens & Widgets)                    │
├─────────────────────────────────────────┤
│         Business Logic Layer            │
│  (Providers - State Management)         │
├─────────────────────────────────────────┤
│         Data Layer                      │
│  (Models & Services)                    │
├─────────────────────────────────────────┤
│         External Services               │
│  (Gemini AI, Camera, Speech)            │
└─────────────────────────────────────────┘
```

---

## 📦 Componentes Principais

### 1. Providers (Gerenciamento de Estado)

#### CameraProvider
**Responsabilidade**: Gerenciar todas as fontes de câmera (físicas e IP)

**Funcionalidades**:
- Detecção automática de câmeras físicas
- Inicialização de controllers de câmera
- Adição/remoção de câmeras IP
- Captura de frames para análise
- Gerenciamento de permissões

**Fluxo**:
```
initializeCameras()
    ↓
Request Permissions
    ↓
availableCameras()
    ↓
Create CameraControllers
    ↓
Initialize Controllers
    ↓
Update UI
```

#### AIProvider
**Responsabilidade**: Integração com Google Gemini AI

**Funcionalidades**:
- Inicialização do modelo Gemini 1.5 Flash
- Análise de imagens individuais
- Análise de múltiplas câmeras simultaneamente
- Processamento de comandos de texto
- Gerenciamento de estado de processamento

**Fluxo de Análise**:
```
analyzeImage(imageBytes)
    ↓
Create Content (Text + Image)
    ↓
generateContent()
    ↓
Parse Response
    ↓
Update UI + Trigger TTS
```

#### VoiceProvider
**Responsabilidade**: Controle de voz (STT e TTS)

**Funcionalidades**:
- Speech-to-Text (reconhecimento de voz)
- Text-to-Speech (síntese de voz)
- Parsing de comandos de voz
- Gerenciamento de permissões de microfone

**Comandos Suportados**:
- Análise: "analisar todas", "analisar câmera da porta"
- Layout: "grade 2", "grade 3", "grade 4"
- Navegação: "câmera 1", "câmera 2", "câmera 3"

---

## 🔄 Fluxo de Dados

### Inicialização do App
```
main()
    ↓
Initialize Firebase (optional)
    ↓
Create Providers
    ↓
HomeScreen.initState()
    ↓
Initialize Cameras
    ↓
Initialize Voice
    ↓
Initialize AI (with API Key)
    ↓
Render UI
```

### Análise de Câmera
```
User Action (Voice/Button)
    ↓
CameraProvider.captureFrame()
    ↓
Convert to Uint8List
    ↓
AIProvider.analyzeImage()
    ↓
Gemini API Call
    ↓
Parse Response
    ↓
VoiceProvider.speak()
    ↓
Update AIResponsePanel
```

### Comando de Voz
```
User Taps Mic Button
    ↓
VoiceProvider.startListening()
    ↓
Speech Recognition
    ↓
onResult(recognizedWords)
    ↓
parseVoiceCommand()
    ↓
Execute Command
    ↓
Update UI / Trigger Analysis
```

---

## 🎨 Interface do Usuário

### Componentes Visuais

#### HomeScreen
- **Header**: Logo, título, status de voz
- **Main Area**: Grid de câmeras + Painel de IA (opcional)
- **Footer**: Painel de controle
- **FAB**: Botão de controle de voz

#### CameraGrid
- Layout responsivo (1x1 a 4x4)
- Cards individuais para cada câmera
- Slot para adicionar câmeras IP

#### CameraViewCard
- Preview de vídeo em tempo real
- Header com nome e tipo de câmera
- Indicador "AO VIVO"
- Footer com descrição e timestamp
- Botão de remoção (câmeras IP)

#### AIResponsePanel
- Estados: Loading, Empty, Response
- Exibição formatada de análises
- Timestamp de geração
- Indicador de erro

---

## 🔐 Segurança e Permissões

### Android
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS
```xml
NSCameraUsageDescription
NSMicrophoneUsageDescription
NSSpeechRecognitionUsageDescription
```

### Web
- Permissões solicitadas via browser APIs
- Requer HTTPS ou localhost
- MediaDevices API para câmeras

---

## 🚀 Performance

### Otimizações Implementadas

1. **Lazy Loading**: Câmeras são inicializadas sob demanda
2. **Provider Pattern**: Atualizações granulares de UI
3. **Async/Await**: Operações não bloqueantes
4. **Resolution Presets**: Configurável (low, medium, high)
5. **Dispose Lifecycle**: Limpeza adequada de recursos

### Recomendações

- **Web**: Use `--web-renderer html` para melhor compatibilidade
- **Mobile**: Execute em modo `--release` para produção
- **Câmeras IP**: Limite a 4 streams simultâneos
- **IA**: Use batch analysis para múltiplas câmeras

---

## 🔌 Integrações Externas

### Google Gemini AI
- **Modelo**: gemini-1.5-flash
- **Endpoint**: Via SDK `google_generative_ai`
- **Rate Limits**: Conforme plano da API
- **Custo**: Veja [pricing](https://ai.google.dev/pricing)

### Câmeras IP
- **Protocolos Suportados**: RTSP, HTTP, HTTPS
- **Player**: flutter_vlc_player (implementação futura)
- **Formatos**: H.264, MJPEG

### Firebase (Opcional)
- **Firestore**: Logs de análises
- **Authentication**: Controle de acesso
- **Storage**: Armazenamento de frames

---

## 📊 Modelos de Dados

### CameraSource
```dart
{
  id: String,
  name: String,
  type: CameraSourceType (physical | ip),
  description: String,
  cameraDescription: CameraDescription?,
  streamUrl: String?,
  isActive: bool
}
```

### Análise de IA (Response)
```dart
{
  cameraName: String,
  analysis: String,
  timestamp: DateTime,
  alerts: List<String>?,
  detectedObjects: List<String>?
}
```

---

## 🧪 Testes

### Testes Unitários
```bash
flutter test
```

### Testes de Integração
```bash
flutter drive --target=test_driver/app.dart
```

### Testes de Widget
```dart
testWidgets('Camera grid displays correctly', (tester) async {
  // Test implementation
});
```

---

## 🔮 Roadmap Futuro

### Fase 2
- [ ] Gravação de vídeo
- [ ] Detecção de movimento
- [ ] Alertas push
- [ ] Histórico de análises

### Fase 3
- [ ] Reconhecimento facial
- [ ] Zonas de interesse
- [ ] Integração com sistemas de alarme
- [ ] Dashboard analytics

### Fase 4
- [ ] Multi-usuário
- [ ] Cloud storage
- [ ] API REST
- [ ] Mobile app nativo (sem Flutter Web)

---

## 📚 Referências

- [Flutter Documentation](https://docs.flutter.dev)
- [Google Gemini API](https://ai.google.dev)
- [Camera Plugin](https://pub.dev/packages/camera)
- [Provider Pattern](https://pub.dev/packages/provider)
- [Speech Recognition](https://pub.dev/packages/speech_to_text)

---

**Versão**: 1.0.0  
**Última Atualização**: 2026-02-06
