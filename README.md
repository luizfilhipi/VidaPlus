
# VidaPlus - Aplicativo de Rastreamento de Hábitos

![Plataforma](https://img.shields.io/badge/Plataforma-Android-green.svg)  
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)  
![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)

## 📱 Sobre o Projeto

VidaPlus é um aplicativo desenvolvido exclusivamente para Android que ajuda usuários a construir e manter hábitos saudáveis através de um sistema de rastreamento simples e eficaz. Utilizando Flutter e Firebase, o aplicativo oferece uma experiência fluida e sincronização em tempo real dos dados.

### ⚠️ Compatibilidade

Este projeto é **exclusivamente** compatível com:
- ✅ Android
- ❌ iOS (não suportado)
- ❌ Web (não suportado)
- ❌ Desktop (não suportado)

## 🏗️ Arquitetura

O projeto utiliza Clean Architecture com princípios SOLID, organizado nas seguintes camadas:

```
lib/
├── core/                # Serviços centrais e utilitários
│   ├── errors/         # Tratamento de erros
│   └── services/       # Serviços compartilhados
├── data/               # Implementação de dados
│   ├── datasources/    # Fontes de dados
│   ├── models/         # Modelos de dados
│   └── repositories_impl/  # Implementação dos repositórios
├── domain/             # Regras de negócio
│   ├── entities/       # Entidades do domínio
│   ├── repositories/   # Contratos dos repositórios
│   └── usecases/       # Casos de uso
├── presentation/       # Interface do usuário
│   ├── bindings/       # Injeção de dependências
│   ├── controllers/    # Controladores
│   ├── pages/          # Páginas
│   └── widgets/        # Widgets reutilizáveis
└── main.dart           # Ponto de entrada
```

### Princípios SOLID Aplicados

1. **S** - Single Responsibility Principle  
   Cada classe tem uma única responsabilidade.  
   Exemplo: UseCases específicos para cada operação.

2. **O** - Open/Closed Principle  
   Classes abertas para extensão, fechadas para modificação.  
   Uso de interfaces em `repositories/`.

3. **L** - Liskov Substitution Principle  
   Implementações podem ser substituídas sem afetar o comportamento.  
   Repositories seguem contratos definidos.

4. **I** - Interface Segregation Principle  
   Interfaces específicas para cada necessidade.  
   Repositories divididos por domínio.

5. **D** - Dependency Inversion Principle  
   Dependência de abstrações, não implementações.  
   Uso de injeção de dependência com GetX.

## 🚀 Configuração do Ambiente

### Pré-requisitos

- Flutter SDK 3.0+
- Android Studio
- JDK 11+
- Firebase CLI
- Git

### Configuração do Firebase

1. Instale o Firebase CLI:
```bash
npm install -g firebase-tools
```

2. **Faça login no Firebase**:
```bash
firebase login
```
⚠️ **Este passo é obrigatório** para configurar e utilizar os serviços do Firebase, incluindo o Cloud Firestore.

3. Configure o projeto:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

4. Adicione seu arquivo `google-services.json` em:
```
android/app/google-services.json
```

5. **Ative o Cloud Firestore** no console do Firebase e configure as seguintes regras de segurança:

### 🔒 Regras recomendadas do Cloud Firestore

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    match /users/{userId} {
      allow read, write: if isOwner(userId);
      match /habits/{habitId} {
        allow read, write: if isOwner(userId);
        match /daily_completions/{completionId} {
          allow read, write: if isOwner(userId);
        }
      }
    }
  }
}
```

✅ **Estas regras garantem que cada usuário só possa acessar seus próprios dados.**

## 🔧 Como Executar

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITORIO]
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o projeto:
```bash
flutter run
```

### Comandos Úteis

- Limpar o projeto: `flutter clean`
- Verificar dependências: `flutter pub outdated`
- Gerar build release: `flutter build apk --release`

## 📝 Boas Práticas de Código

### Documentação de Código

Utilizamos três níveis de documentação:

1. **Documentação de Classe**
```dart
/// Gerencia o estado e a lógica dos hábitos.
///
/// Responsável por:
/// * Carregar hábitos do usuário
/// * Atualizar estado dos hábitos
/// * Sincronizar com Firebase
class HabitController extends GetxController {
```

2. **Documentação de Método**
```dart
/// Carrega os hábitos do usuário atual.
///
/// Throws [AuthException] se usuário não estiver autenticado.
Future<void> loadHabits() async {
```

3. **Comentários Internos**
```dart
// Atualiza o estado local antes de sincronizar
habit.completed = true;
```

## 🧪 Testes

O projeto inclui:
- Testes unitários (`/test/domain/...`)
- Testes de widgets (`/test/presentation/...`)
- Mocks para testes (`/test/helpers/...`)

## 📖 Mais Informações

- [Flutter](https://flutter.dev/docs)
- [Firebase](https://firebase.google.com/docs)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
