# turkic.core 🌍

> Научно обоснованное приложение для изучения тюркских языков через когнаты

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

## 🎯 О проекте

**turkic.core** — это iOS-приложение для изучения 6 тюркских языков (казахский, турецкий, узбекский, киргизский, татарский, азербайджанский) с использованием научно обоснованных методик и уникального подхода на основе когнатов.

### Ключевые особенности

- 🔌 **100% оффлайн** — работает без интернета
- 🧠 **Научный подход** — Spaced Repetition (SM-2), Active Recall, Interleaving
- 🎯 **Когнаты** — учите 1 концепт, видите его во всех 6 языках
- 📊 **2500 слов** — от A1 до B2 по CEFR
- 💰 **Бесплатно** — без подписок и платежей

## 🚀 Быстрый старт

### Требования

- macOS 14.0+ (Sonoma)
- Xcode 15.0+
- iOS 17.0+ (для запуска)

### Установка

1. **Клонируйте репозиторий**
```bash
git clone https://github.com/yourusername/turkic-core.git
cd turkic-core
```

2. **Создайте Xcode проект**

Поскольку `.xcodeproj` файлы не включены в репозиторий, создайте проект:

```
Xcode → File → New → Project → App
- Product Name: TurkicCore
- Team: None (для локальной разработки)
- Organization Identifier: com.turkiccore
- Interface: SwiftUI
- Language: Swift
- Storage: SwiftData
```

3. **Добавьте исходные файлы**

- Перетащите папку `TurkicCore/` в навигатор Xcode
- Убедитесь, что "Copy items if needed" отмечен
- Target Membership: TurkicCore

4. **Добавьте words.json в Resources**

- Правый клик на TurkicCore → Add Files
- Выберите `Resources/words.json`
- Target Membership: ✓ TurkicCore

5. **Запустите** (⌘R)

## 📁 Структура проекта

```
TurkicCore/
├── TurkicCoreApp.swift          # Entry point
├── Models/
│   ├── Word.swift               # Word model + JSON decoding
│   ├── UserProgress.swift       # SM-2 algorithm
│   └── UserSettings.swift       # User preferences
├── Views/
│   ├── MainTabView.swift        # Tab navigation
│   ├── Components/              # Reusable components
│   ├── Today/                   # Home screen
│   ├── Learn/                   # Learning session
│   ├── Explore/                 # Dictionary
│   ├── Progress/                # Statistics
│   └── Settings/                # Settings & About
├── Services/
│   ├── SpacedRepetitionManager.swift
│   ├── TTSManager.swift
│   └── SimilarityEngine.swift
├── Utilities/
│   ├── Color+Hex.swift
│   └── HapticManager.swift
└── Resources/
    └── words.json               # 50 test words (expand to 2500)
```

## 🔬 Методология

### Научные основы

1. **Frequency-first** (Nation, 2001) — слова по частотности
2. **Spaced Repetition** (Ebbinghaus) — алгоритм SM-2
3. **Cognate Transfer** (de Groot) — когнаты учатся на 40-60% быстрее
4. **Comprehensible Input** (Krashen) — 95% понятно + 5% ново
5. **Interleaving** (Bjork) — чередование языков

### Уровни CEFR

| Уровень | Слов | Описание |
|---------|------|----------|
| A1 | 500 | Выживание |
| A2 | 600 | Повседневность |
| B1 | 700 | Свободное общение |
| B2 | 700 | Нюансы, академическая лексика |

## 🌐 Поддерживаемые языки

| Код | Язык | Флаг | Письмо | TTS |
|-----|------|------|--------|-----|
| kk | Казахский | 🇰🇿 | Кириллица | kk-KZ |
| tr | Турецкий | 🇹🇷 | Латиница | tr-TR |
| uz | Узбекский | 🇺🇿 | Латиница | uz-UZ |
| ky | Киргизский | 🇰🇬 | Кириллица | ky-KG |
| tt | Татарский | 🏴 | Кириллица | tt-RU |
| az | Азербайджанский | 🇦🇿 | Латиница | az-AZ |

## 🎨 Дизайн

### Цветовая палитра "Silk Road Minimalism"

```swift
// Primary
let primary = Color(hex: "#E67E22")      // терракота
let primaryDark = Color(hex: "#D35400")  // жжёная сиена

// Semantic
let success = Color(hex: "#16A085")      // правильно
let error = Color(hex: "#E74C3C")        // неправильно
let warning = Color(hex: "#F39C12")      // подсказка

// Background
let backgroundLight = Color(hex: "#FBF8F3")
```

## 🧪 Тестирование

```bash
xcodebuild test \
  -project TurkicCore.xcodeproj \
  -scheme TurkicCore \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 📝 Лицензия

MIT License. Смотрите [LICENSE](LICENSE) для деталей.

## 🤝 Контрибьюция

1. Fork репозитория
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

---

**Сделано с ❤️ для изучающих тюркские языки**
