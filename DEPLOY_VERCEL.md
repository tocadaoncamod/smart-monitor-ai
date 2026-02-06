# 🚀 Deploy na Vercel - Smart Monitor AI

## 📋 Pré-requisitos

- Conta na Vercel (gratuita): https://vercel.com/signup
- Conta no GitHub
- Projeto Flutter configurado

---

## 🔐 Credenciais de Acesso Padrão

### 👤 **Usuário Admin**
```
Email: admin@smartmonitor.com
Senha: Admin@123456
```

### 👤 **Usuário Demo**
```
Email: demo@smartmonitor.com
Senha: Demo@123456
```

⚠️ **IMPORTANTE**: Altere essas senhas após o primeiro login!

---

## 🚀 Deploy Automático (Recomendado)

### 1️⃣ Preparar Repositório GitHub

```powershell
# Execute o script de inicialização do GitHub
.\init_github.ps1
```

### 2️⃣ Deploy na Vercel

1. Acesse: https://vercel.com
2. Faça login com GitHub
3. Clique em "Add New Project"
4. Importe o repositório `smart-monitor-ai`
5. Configure:
   - **Framework Preset**: Other
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
   - **Install Command**: `flutter pub get`

6. Clique em "Deploy"

### 3️⃣ Configurar Domínio Gratuito

Após o deploy, você receberá um domínio gratuito:
```
https://smart-monitor-ai.vercel.app
```

Ou configure um domínio personalizado:
1. Vá em "Settings" → "Domains"
2. Adicione seu domínio
3. Configure DNS conforme instruções

---

## 🔧 Deploy Manual

### 1️⃣ Instalar Vercel CLI

```powershell
npm install -g vercel
```

### 2️⃣ Build do Projeto

```powershell
flutter build web --release
```

### 3️⃣ Deploy

```powershell
cd build/web
vercel --prod
```

---

## 🔥 Configurar Firebase

### 1️⃣ Criar Projeto Firebase

1. Acesse: https://console.firebase.google.com
2. Crie projeto: "smart-monitor-ai"
3. Habilite Authentication (Email/Password)
4. Habilite Firestore Database

### 2️⃣ Configurar Web App

1. No Firebase Console, adicione um app Web
2. Copie as credenciais
3. Edite `lib/main.dart` e substitua:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "SUA_API_KEY_AQUI",
    authDomain: "SEU_PROJETO.firebaseapp.com",
    projectId: "SEU_PROJETO",
    storageBucket: "SEU_PROJETO.appspot.com",
    messagingSenderId: "SEU_ID",
    appId: "SEU_APP_ID",
  ),
);
```

### 3️⃣ Criar Usuários Iniciais

No Firebase Console → Authentication:

1. Clique em "Add user"
2. Crie os usuários:
   - `admin@smartmonitor.com` / `Admin@123456`
   - `demo@smartmonitor.com` / `Demo@123456`

---

## 🌐 Domínios Gratuitos

### Vercel (Automático)
```
https://smart-monitor-ai.vercel.app
https://smart-monitor-ai-seu-usuario.vercel.app
```

### Personalizar Subdomínio
```
https://monitor.vercel.app
https://camera-ai.vercel.app
```

### Domínio Personalizado Gratuito

Use serviços como:
- **Freenom**: https://freenom.com (domínios .tk, .ml, .ga)
- **Cloudflare Pages**: Domínio gratuito
- **GitHub Pages**: Para hospedagem estática

---

## ⚙️ Variáveis de Ambiente (Vercel)

Configure em: Settings → Environment Variables

```
FIREBASE_API_KEY=sua_api_key
FIREBASE_PROJECT_ID=seu_projeto
GEMINI_API_KEY=sua_gemini_key
```

Acesse no código:
```dart
const apiKey = String.fromEnvironment('GEMINI_API_KEY');
```

---

## 🔒 Segurança

### Regras do Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /cameras/{cameraId} {
      allow read, write: if request.auth != null;
    }
    
    match /analyses/{analysisId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Regras do Firebase Auth

1. Habilite apenas Email/Password
2. Configure domínios autorizados
3. Ative verificação de email (opcional)

---

## 📊 Monitoramento

### Vercel Analytics

1. Vá em "Analytics" no dashboard
2. Ative o monitoramento gratuito
3. Veja métricas de:
   - Visitantes
   - Performance
   - Erros

### Firebase Analytics

1. Habilite no Firebase Console
2. Adicione ao app:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;
await analytics.logEvent(name: 'camera_analyzed');
```

---

## 🐛 Solução de Problemas

### Build Falha

```powershell
# Limpe e reconstrua
flutter clean
flutter pub get
flutter build web --release
```

### Erro de Permissões

Verifique:
- Regras do Firestore
- Autenticação habilitada
- Domínios autorizados no Firebase

### App não Carrega

1. Verifique console do navegador (F12)
2. Confirme Firebase configurado
3. Teste localmente primeiro

---

## 📱 PWA (Progressive Web App)

O app já está configurado como PWA!

### Instalar no Celular

1. Acesse o site no Chrome mobile
2. Toque em "Adicionar à tela inicial"
3. Use como app nativo!

### Funcionalidades PWA

- ✅ Funciona offline (cache)
- ✅ Instalável
- ✅ Ícone na tela inicial
- ✅ Splash screen

---

## 🔄 Atualizações Automáticas

### Vercel + GitHub

Cada push para `main` dispara deploy automático:

```powershell
git add .
git commit -m "feat: Nova funcionalidade"
git push origin main
```

Vercel detecta e faz deploy automaticamente!

---

## 💰 Custos

### Vercel (Gratuito)
- ✅ 100GB bandwidth/mês
- ✅ Domínio .vercel.app
- ✅ SSL automático
- ✅ Deploy ilimitados

### Firebase (Gratuito - Spark Plan)
- ✅ 50K leituras/dia
- ✅ 20K escritas/dia
- ✅ 1GB armazenamento
- ✅ 10GB transferência/mês

---

## 🎯 Checklist de Deploy

- [ ] Código no GitHub
- [ ] Firebase configurado
- [ ] Usuários criados
- [ ] Build local testado
- [ ] Deploy na Vercel
- [ ] Domínio configurado
- [ ] SSL ativo
- [ ] Teste de login
- [ ] Teste de câmeras
- [ ] Analytics configurado

---

## 📞 Suporte

### Links Úteis

- Vercel Docs: https://vercel.com/docs
- Firebase Docs: https://firebase.google.com/docs
- Flutter Web: https://docs.flutter.dev/platform-integration/web

---

## 🎉 Pronto!

Seu app estará disponível em:
```
https://smart-monitor-ai.vercel.app
```

**Acesse com:**
- Email: `admin@smartmonitor.com`
- Senha: `Admin@123456`

---

**Última Atualização**: 06/02/2026  
**Versão**: 1.0.0
