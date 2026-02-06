# 💾 Documentação do Banco de Dados - Smart Monitor AI

## 📊 Visão Geral

O Smart Monitor AI utiliza dois tipos de armazenamento:

1. **Firebase Firestore** - Dados na nuvem (câmeras IP, análises, logs)
2. **SharedPreferences** - Configurações locais (API Key, preferências)

---

## 🔥 Firebase Firestore

### Estrutura de Coleções

```
smart_monitor/
├── cameras/                    # Câmeras IP configuradas
│   ├── {cameraId}/
│   │   ├── id: string
│   │   ├── name: string
│   │   ├── type: string
│   │   ├── description: string
│   │   ├── streamUrl: string
│   │   ├── isActive: boolean
│   │   └── createdAt: timestamp
│
├── analyses/                   # Histórico de análises da IA
│   ├── {analysisId}/
│   │   ├── id: string
│   │   ├── cameraId: string
│   │   ├── cameraName: string
│   │   ├── analysis: string
│   │   ├── timestamp: timestamp
│   │   ├── detectedObjects: array<string>
│   │   ├── alerts: array<string>
│   │   ├── peopleCount: number
│   │   └── imageUrl: string (opcional)
│
└── settings/                   # Configurações globais
    └── app/
        ├── version: string
        ├── lastUpdate: timestamp
        └── features: map
```

---

## 📝 Modelos de Dados

### CameraSource

```dart
{
  "id": "ip_1707241234567",
  "name": "Câmera da Porta",
  "type": "CameraSourceType.ip",
  "description": "RTSP",
  "streamUrl": "rtsp://192.168.1.100:554/stream",
  "isActive": true,
  "createdAt": "2026-02-06T16:00:00.000Z"
}
```

### AnalysisRecord

```dart
{
  "id": "analysis_1707241234567",
  "cameraId": "ip_1707241234567",
  "cameraName": "Câmera da Porta",
  "analysis": "Cena: Entrada residencial. Pessoas: 1 pessoa detectada próxima à porta...",
  "timestamp": "2026-02-06T16:30:00.000Z",
  "detectedObjects": ["pessoa", "porta", "capacho"],
  "alerts": ["Pessoa não identificada detectada"],
  "peopleCount": 1,
  "imageUrl": null
}
```

---

## 🔐 SharedPreferences (Local)

### Chaves Armazenadas

| Chave | Tipo | Descrição |
|-------|------|-----------|
| `gemini_api_key` | String | API Key do Google Gemini |
| `grid_columns` | int | Número de colunas do grid (1-4) |
| `last_sync` | String | Última sincronização com Firebase |
| `user_preferences` | String (JSON) | Preferências do usuário |

---

## 🔧 Operações do Banco de Dados

### DatabaseService

#### Câmeras IP

```dart
// Salvar câmera
await DatabaseService().saveCameraIP(camera);

// Carregar câmeras
List<CameraSource> cameras = await DatabaseService().loadCamerasIP();

// Deletar câmera
await DatabaseService().deleteCameraIP(cameraId);
```

#### Análises

```dart
// Salvar análise
await DatabaseService().saveAnalysis(analysis);

// Carregar histórico
List<AnalysisRecord> analyses = await DatabaseService().loadAnalyses(
  limit: 50,
  startDate: DateTime.now().subtract(Duration(days: 7)),
);

// Deletar análise
await DatabaseService().deleteAnalysis(analysisId);

// Limpar análises antigas (mais de 30 dias)
await DatabaseService().clearOldAnalyses(daysToKeep: 30);
```

#### Configurações

```dart
// Salvar API Key
await DatabaseService().saveApiKey('AIzaSy...');

// Carregar API Key
String? apiKey = await DatabaseService().loadApiKey();

// Salvar preferência de grid
await DatabaseService().saveGridColumns(3);

// Carregar preferência de grid
int columns = await DatabaseService().loadGridColumns();
```

#### Estatísticas

```dart
// Obter estatísticas de uso
Map<String, dynamic> stats = await DatabaseService().getStatistics();
// Retorna:
// {
//   'totalAnalyses': 150,
//   'totalCameras': 4,
//   'todayAnalyses': 12,
//   'lastUpdate': '2026-02-06T16:30:00.000Z'
// }
```

---

## 🔒 Regras de Segurança do Firestore

### Configuração Recomendada

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Câmeras - Leitura/Escrita autenticada
    match /cameras/{cameraId} {
      allow read, write: if request.auth != null;
    }
    
    // Análises - Leitura/Escrita autenticada
    match /analyses/{analysisId} {
      allow read, write: if request.auth != null;
      allow delete: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
    
    // Configurações - Apenas leitura autenticada
    match /settings/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
        && request.auth.token.admin == true;
    }
  }
}
```

---

## 📊 Índices Recomendados

### Firestore Indexes

```javascript
// analyses collection
{
  "collectionGroup": "analyses",
  "queryScope": "COLLECTION",
  "fields": [
    { "fieldPath": "timestamp", "order": "DESCENDING" },
    { "fieldPath": "cameraId", "order": "ASCENDING" }
  ]
}

{
  "collectionGroup": "analyses",
  "queryScope": "COLLECTION",
  "fields": [
    { "fieldPath": "timestamp", "order": "DESCENDING" },
    { "fieldPath": "peopleCount", "order": "DESCENDING" }
  ]
}
```

---

## 🚀 Configuração do Firebase

### 1. Criar Projeto Firebase

1. Acesse: https://console.firebase.google.com
2. Clique em "Adicionar projeto"
3. Nomeie: "smart-monitor-ai"
4. Habilite Google Analytics (opcional)

### 2. Adicionar App

#### Web
```bash
# No console Firebase, adicione um app Web
# Copie o firebase-config.js para web/
```

#### Android
```bash
# Baixe google-services.json
# Coloque em: android/app/
```

#### iOS
```bash
# Baixe GoogleService-Info.plist
# Coloque em: ios/Runner/
```

### 3. Habilitar Firestore

1. No console Firebase, vá em "Firestore Database"
2. Clique em "Criar banco de dados"
3. Escolha modo de produção
4. Selecione localização (southamerica-east1 para Brasil)

### 4. Configurar Regras de Segurança

Cole as regras acima na aba "Regras"

---

## 📈 Monitoramento e Otimização

### Métricas Importantes

- **Leituras/Escritas por dia**: Monitore no console Firebase
- **Tamanho do banco**: Limite de 1GB no plano gratuito
- **Consultas simultâneas**: Máximo recomendado de 100

### Otimizações

1. **Paginação**: Limite consultas a 50 registros
2. **Cache Local**: Use `persistenceEnabled: true`
3. **Limpeza Automática**: Execute `clearOldAnalyses()` semanalmente
4. **Índices**: Crie índices para consultas frequentes

---

## 🔄 Migração de Dados

### Exportar Dados

```dart
// Exportar todas as análises
final analyses = await DatabaseService().loadAnalyses(limit: 1000);
final json = analyses.map((a) => a.toJson()).toList();
// Salvar em arquivo JSON
```

### Importar Dados

```dart
// Importar de JSON
for (var json in jsonData) {
  final analysis = AnalysisRecord.fromJson(json);
  await DatabaseService().saveAnalysis(analysis);
}
```

---

## 🐛 Troubleshooting

### Erro: "Permission Denied"
- Verifique as regras de segurança
- Certifique-se de estar autenticado

### Erro: "Quota Exceeded"
- Verifique uso no console Firebase
- Implemente paginação
- Limpe dados antigos

### Erro: "Network Error"
- Verifique conexão com internet
- Verifique configuração do Firebase

---

## 📚 Referências

- [Firebase Firestore Docs](https://firebase.google.com/docs/firestore)
- [Flutter Firebase](https://firebase.flutter.dev)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)

---

**Última Atualização**: 06/02/2026  
**Versão**: 1.0.0
