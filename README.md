# GymPlan

A Flutter app for generating personalized workout plans using AI (Gemini or Ollama).

## Features

- Configure AI provider (Gemini or Ollama)
- Ollama IP and port configuration
- Body weight and height input with number pickers
- Extra information input for personalized plans
- Multi-language support (English and Persian)
- Weekly workout plan generation

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Generate localization files:
```bash
flutter gen-l10n
```

3. Configure your API settings in the app settings:
   - For Gemini: Enter your API key
   - For Ollama: Enter IP address and port (default: localhost:11434)

## Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## License

This project is private.
