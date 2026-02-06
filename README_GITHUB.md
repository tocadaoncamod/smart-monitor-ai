# Smart Monitor AI

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)
![Gemini](https://img.shields.io/badge/Gemini-1.5_Flash-4285F4?style=for-the-badge&logo=google)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**🎥 Sistema de Monitoramento Inteligente Multiplataforma com IA**

[Documentação](#-documentação) • [Instalação](#-instalação) • [Recursos](#-recursos) • [Demo](#-demo)

</div>

---

## 🌟 Sobre o Projeto

**Smart Monitor AI** é um sistema completo de monitoramento inteligente que combina visão computacional, inteligência artificial e controle por voz para criar uma experiência de segurança moderna e eficiente.

### ✨ Principais Recursos

- 🎥 **Múltiplas Câmeras**: Suporte para câmeras físicas e IP (RTSP/HTTP)
- 🤖 **IA Avançada**: Análise visual com Google Gemini 1.5 Flash
- 🎤 **Controle por Voz**: Comandos em português brasileiro
- 📱 **Multiplataforma**: Web, Android e iOS com código único
- 💾 **Banco de Dados**: Firebase Firestore para persistência
- 🎨 **Interface Premium**: Design moderno e responsivo

---

## 🚀 Início Rápido

### Pré-requisitos

- Flutter 3.0 ou superior
- Conta Google (para Gemini API)
- Conta Firebase (opcional, para persistência)

### Instalação

```bash
# Clone o repositório
git clone https://github.com/SEU_USUARIO/smart-monitor-ai.git
cd smart-monitor-ai

# Instale as dependências
flutter pub get

# Configure a API Key do Gemini
# Edite lib/screens/home_screen.dart e substitua 'SUA_API_KEY_AQUI'

# Execute o app
flutter run -d chrome  # Web
flutter run            # Mobile
```

### Setup Automático (Windows)

```powershell
.\setup.ps1
```

---

## 📱 Plataformas Suportadas

| Plataforma | Status | Build Command |
|------------|--------|---------------|
| 🌐 Web | ✅ Pronto | `flutter build web` |
| 🤖 Android | ✅ Pronto | `flutter build apk` |
| 🍎 iOS | ✅ Pronto | `flutter build ios` |

---

## 🎯 Recursos Implementados

### 🎥 Gerenciamento de Câmeras
- ✅ Detecção automática de câmeras físicas
- ✅ Suporte a câmeras IP (RTSP/HTTP/HTTPS)
- ✅ Grid dinâmico (1x1 até 4x4)
- ✅ Preview em tempo real
- ✅ Persistência de configurações

### 🤖 Inteligência Artificial
- ✅ Análise visual com Google Gemini
- ✅ Detecção de pessoas e objetos
- ✅ Alertas de segurança automáticos
- ✅ Análise contextual personalizada
- ✅ Processamento simultâneo de múltiplas câmeras

### 🎤 Controle por Voz
- ✅ Reconhecimento de voz (PT-BR)
- ✅ Comandos naturais
- ✅ Respostas em áudio (TTS)
- ✅ Feedback visual em tempo real

### 💾 Banco de Dados
- ✅ Firebase Firestore para dados na nuvem
- ✅ SharedPreferences para configurações locais
- ✅ Histórico de análises
- ✅ Estatísticas de uso

---

## 📚 Documentação

- [📖 Guia de Instalação](README.md)
- [🏗️ Arquitetura](ARCHITECTURE.md)
- [📊 Resumo Executivo](RESUMO_EXECUTIVO.md)
- [⚡ Comandos Rápidos](COMANDOS.md)
- [💡 Exemplos de Uso](EXEMPLOS.md)
- [📂 Estrutura do Projeto](ESTRUTURA.md)

---

## 🛠️ Tecnologias

### Core
- **Flutter** 3.0+ - Framework multiplataforma
- **Dart** 3.0+ - Linguagem de programação
- **Provider** - Gerenciamento de estado

### IA & Visão
- **Google Gemini** 1.5 Flash - Análise de imagens
- **Camera Plugin** - Acesso às câmeras
- **VLC Player** - Streaming RTSP/HTTP

### Voz
- **Speech-to-Text** - Reconhecimento de voz
- **Flutter TTS** - Síntese de voz

### Backend
- **Firebase Core** - Infraestrutura
- **Cloud Firestore** - Banco de dados
- **Shared Preferences** - Armazenamento local

---

## 💡 Exemplos de Uso

### Comandos de Voz

```
🎤 "Analisar todas"
   → Analisa todas as câmeras simultaneamente

🎤 "Analisar câmera da porta"
   → Analisa câmera específica

🎤 "Grade 3"
   → Muda para layout 3x3
```

### Adicionar Câmera IP

```dart
// Exemplo de URL RTSP
rtsp://admin:senha@192.168.1.100:554/stream

// Exemplo de URL HTTP
http://192.168.1.101:8080/video
```

---

## 📊 Estrutura do Projeto

```
smart_monitor/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── camera_source.dart
│   │   └── analysis_record.dart
│   ├── providers/
│   │   ├── camera_provider.dart
│   │   ├── ai_provider.dart
│   │   └── voice_provider.dart
│   ├── screens/
│   │   └── home_screen.dart
│   ├── widgets/
│   │   ├── camera_grid.dart
│   │   ├── camera_view_card.dart
│   │   ├── control_panel.dart
│   │   └── ...
│   └── services/
│       └── database_service.dart
├── web/
├── android/
├── ios/
└── docs/
```

---

## 🔧 Configuração

### 1. API Key do Google Gemini

1. Acesse: https://makersuite.google.com/app/apikey
2. Crie uma API Key
3. Edite `lib/screens/home_screen.dart`:

```dart
aiProvider.initializeGemini('SUA_API_KEY_AQUI');
```

### 2. Firebase (Opcional)

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com)
2. Adicione o app (Web/Android/iOS)
3. Baixe os arquivos de configuração:
   - Web: `firebase-config.js`
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`

---

## 🐛 Solução de Problemas

### Erro de Permissões
```bash
flutter clean
flutter pub get
flutter run
```

### Câmera não detectada
- Verifique permissões no navegador/dispositivo
- Certifique-se de que nenhum outro app está usando a câmera

### Erro de API Key
- Verifique se a chave está correta
- Confirme que a API está habilitada no Google Cloud Console

Mais soluções em [README.md](README.md)

---

## 🗺️ Roadmap

### ✅ Versão 1.0 (Atual)
- [x] Detecção de câmeras físicas e IP
- [x] Grid dinâmico
- [x] IA Gemini integrada
- [x] Comandos de voz
- [x] Banco de dados Firebase
- [x] Interface premium

### 🔮 Versão 1.1 (Próxima)
- [ ] Gravação de vídeo
- [ ] Detecção de movimento
- [ ] Alertas push
- [ ] Histórico visual de análises

### 🚀 Versão 2.0 (Futuro)
- [ ] Reconhecimento facial
- [ ] Zonas de interesse personalizadas
- [ ] Dashboard analytics
- [ ] Sistema multi-usuário

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👥 Autores

- **Desenvolvedor Principal** - [Seu Nome](https://github.com/SEU_USUARIO)

---

## 🙏 Agradecimentos

- Flutter Team
- Google Gemini AI
- Firebase
- Comunidade Open Source

---

## 📞 Suporte

- 📧 Email: seu.email@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/SEU_USUARIO/smart-monitor-ai/issues)
- 📖 Docs: [Documentação Completa](docs/)

---

<div align="center">

**Desenvolvido com Flutter 💙**

[⬆ Voltar ao topo](#smart-monitor-ai)

</div>
