# 🎥 Smart Monitor AI

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)
![Gemini](https://img.shields.io/badge/Gemini-1.5_Flash-4285F4?style=for-the-badge&logo=google)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Sistema de Monitoramento Inteligente Multiplataforma com IA**

[Documentação](#-documentação) • [Instalação](#-instalação-rápida) • [Recursos](#-recursos) • [Exemplos](#-exemplos)

</div>

---

## 🌟 Visão Geral

**Smart Monitor AI** é um sistema completo de monitoramento inteligente que combina:

- 🎥 **Múltiplas Câmeras**: Físicas e IP (RTSP/HTTP)
- 🤖 **IA Avançada**: Google Gemini 1.5 Flash
- 🎤 **Controle por Voz**: Comandos em português
- 📱 **Multiplataforma**: Web, Android e iOS
- 🎨 **Interface Premium**: Design moderno e responsivo

---

## ✨ Recursos

### 🎥 Gerenciamento de Câmeras
- ✅ Detecção automática de câmeras físicas
- ✅ Suporte a câmeras IP (RTSP/HTTP/HTTPS)
- ✅ Grid dinâmico (1x1 até 4x4)
- ✅ Preview em tempo real
- ✅ Identificação de dispositivos

### 🤖 Inteligência Artificial
- ✅ Análise visual com Google Gemini
- ✅ Detecção de pessoas e objetos
- ✅ Alertas de segurança
- ✅ Análise contextual
- ✅ Processamento simultâneo

### 🎤 Controle por Voz
- ✅ Reconhecimento de voz (PT-BR)
- ✅ Comandos naturais
- ✅ Respostas em áudio (TTS)
- ✅ Feedback visual

### 🎨 Interface
- ✅ Design premium com gradientes
- ✅ Animações suaves
- ✅ Tema dark moderno
- ✅ Responsivo e adaptável

---

## 🚀 Instalação Rápida

### Pré-requisitos
- Flutter 3.0+
- Google Gemini API Key ([Obter aqui](https://makersuite.google.com/app/apikey))

### Setup Automático (Recomendado)

```powershell
cd C:\Users\lenovo\Desktop\WEB\smart_monitor
.\setup.ps1
```

### Setup Manual

```powershell
# 1. Instalar dependências
flutter pub get

# 2. Configurar API Key
# Edite lib/screens/home_screen.dart
# Substitua 'SUA_API_KEY_AQUI' pela sua chave

# 3. Executar
flutter run -d chrome  # Web
flutter run            # Mobile
```

---

## 📱 Plataformas Suportadas

| Plataforma | Status | Comando |
|------------|--------|---------|
| 🌐 Web | ✅ | `flutter run -d chrome` |
| 🤖 Android | ✅ | `flutter run` |
| 🍎 iOS | ✅ | `flutter run` (macOS) |

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

🎤 "Câmera 1"
   → Seleciona primeira câmera
```

### Adicionar Câmera IP

1. Clique em "Adicionar Câmera IP"
2. Preencha os dados:
   - **Nome**: Câmera da Garagem
   - **Protocolo**: RTSP
   - **URL**: `rtsp://192.168.1.100:554/stream`
3. Clique em "Adicionar"

---

## 📚 Documentação

| Documento | Descrição |
|-----------|-----------|
| [📖 ÍNDICE.md](INDICE.md) | Índice geral navegável |
| [📘 README.md](README.md) | Guia completo de instalação |
| [🏗️ ARCHITECTURE.md](ARCHITECTURE.md) | Arquitetura técnica |
| [📊 RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md) | Visão executiva |
| [⚡ COMANDOS.md](COMANDOS.md) | Referência de comandos |
| [📂 ESTRUTURA.md](ESTRUTURA.md) | Estrutura do projeto |
| [💡 EXEMPLOS.md](EXEMPLOS.md) | Casos de uso práticos |

---

## 🛠️ Tecnologias

<div align="center">

| Categoria | Tecnologia |
|-----------|-----------|
| Framework | Flutter 3.0+ |
| Linguagem | Dart 3.0+ |
| IA | Google Gemini 1.5 Flash |
| Estado | Provider Pattern |
| Câmera | Camera Plugin |
| Voz | Speech-to-Text + TTS |
| Streaming | VLC Player |

</div>

---

## 📊 Estatísticas

```
📁 Arquivos de Código: 12
📝 Linhas de Código: ~1.610
📚 Documentação: ~1.250 linhas
📦 Dependências: 15+
🌍 Plataformas: 3 (Web, Android, iOS)
```

---

## 🎯 Casos de Uso

- 🏠 **Residencial**: Monitoramento de casa
- 🏢 **Comercial**: Lojas e escritórios
- 🏭 **Industrial**: Fábricas e armazéns
- 🚗 **Estacionamento**: Controle de vagas
- 👶 **Babá Eletrônica**: Monitoramento infantil
- 🐾 **Pets**: Acompanhamento de animais

---

## 🚀 Início Rápido

### 1️⃣ Clone ou Navegue
```powershell
cd C:\Users\lenovo\Desktop\WEB\smart_monitor
```

### 2️⃣ Execute o Setup
```powershell
.\setup.ps1
```

### 3️⃣ Configure a API Key
- Obtenha em: https://makersuite.google.com/app/apikey
- O script solicitará automaticamente

### 4️⃣ Execute o App
```powershell
flutter run -d chrome  # Web
```

---

## 📖 Guia Rápido

### Executar na Web
```powershell
flutter run -d chrome
```

### Executar no Mobile
```powershell
flutter run
```

### Build para Produção
```powershell
flutter build web --release      # Web
flutter build apk --release      # Android
flutter build ios --release      # iOS
```

---

## 🐛 Solução de Problemas

### Erro de Permissões
```powershell
flutter clean
flutter pub get
flutter run
```

### Erro de API Key
- Verifique se a chave está correta
- Edite `lib/screens/home_screen.dart`

### Câmera não detectada
- Permita acesso no navegador/dispositivo
- Verifique se outra app não está usando

### Mais soluções
Consulte [README.md](README.md) - Seção "Solução de Problemas"

---

## 📞 Suporte

1. 📖 Leia a [Documentação](#-documentação)
2. ⚡ Consulte [COMANDOS.md](COMANDOS.md)
3. 🔍 Execute `flutter doctor -v`

---

## 🗺️ Roadmap

### ✅ Versão 1.0 (Atual)
- [x] Detecção de câmeras
- [x] Câmeras IP
- [x] Grid dinâmico
- [x] IA Gemini
- [x] Comandos de voz
- [x] Interface premium

### 🔮 Versão 1.1 (Futuro)
- [ ] Gravação de vídeo
- [ ] Detecção de movimento
- [ ] Alertas push
- [ ] Histórico de análises

### 🚀 Versão 2.0 (Futuro)
- [ ] Reconhecimento facial
- [ ] Zonas de interesse
- [ ] Dashboard analytics
- [ ] Multi-usuário

---

## 📄 Licença

Este projeto é fornecido como está, para fins educacionais e de desenvolvimento.

---

## 🙏 Agradecimentos

- Flutter Team
- Google Gemini AI
- Comunidade Open Source

---

<div align="center">

**Desenvolvido com Flutter 💙**

[⬆ Voltar ao topo](#-smart-monitor-ai)

</div>
