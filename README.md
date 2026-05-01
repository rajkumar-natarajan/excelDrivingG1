# ExcelDriving G1 — Ontario G1 Test Prep

A comprehensive Flutter app to help new drivers in Ontario, Canada prepare for the G1 knowledge test.

[![Flutter](https://img.shields.io/badge/Flutter-3.38+-blue?logo=flutter)](https://flutter.dev)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20iPad-lightgrey)](https://flutter.dev)
[![Languages](https://img.shields.io/badge/Languages-English%20%7C%20Français-green)](#language-support)

---

## Features

- **352 Official Questions** — comprehensive coverage of the Ontario MTO Driver's Handbook 2026
- **6 Question Categories** — Graduated Licensing, Traffic Signs, Rules of the Road, Safe Driving, Sharing the Road, Special Situations
- **3 Test Modes** — Quick Check (10 Q), Practice Test (20 Q), Mock G1 Test (40 Q)
- **Smart Learning** — spaced-repetition system that tracks weak areas, bookmarks, and review queues
- **Bilingual — English & French** — full UI and all 352 questions translated into Canadian French
- **Gamification** — XP, levels, daily streaks, and 20+ achievements
- **Study Guide** — quick-reference summaries of key road rules
- **Progress Tracking** — per-category accuracy, accuracy trends, session history
- **Adaptive Difficulty** — Easy / Medium / Hard practise modes
- **Dark Mode Support** — follows system theme or manual override

---

## Screenshots

> *(Add screenshots here)*

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.10 (tested on 3.38.5)
- Dart SDK ≥ 3.10.4
- Xcode ≥ 15 for iOS / iPadOS builds
- Android Studio or VS Code

### Build & Run

```bash
# Clone the repo
git clone https://github.com/rajkumar-natarajan/excelDrivingG1.git
cd ExcelDrivingG1

# Install dependencies
flutter pub get

# Run on connected device / simulator
flutter run

# Run on iPad simulator specifically
flutter run -d <SIMULATOR_UUID>

# Build release APK
flutter build apk --release

# Build iOS archive
flutter build ipa --release
```

### Run Tests

```bash
flutter test
```

The test suite contains 290+ unit tests covering:
- All 352 questions loaded and validated
- Question shuffling preserves correct answer index
- French translations completeness check
- Gamification XP and level calculations
- Smart learning spaced-repetition logic
- TestConfiguration model serialization

---

## Project Structure

```
lib/
├── controllers/
│   ├── gamification_controller.dart   # XP, levels, streaks, achievements
│   ├── settings_controller.dart       # Theme, difficulty, language preferences
│   └── smart_learning_controller.dart # Spaced repetition, bookmarks, weak areas
├── data/
│   ├── french_question_translations.dart  # 92 original questions in Canadian French
│   ├── french_translations_extra.dart     # 100 extra questions in Canadian French
│   ├── question_bank_extra.dart           # 100 extra questions (English)
│   └── question_data_manager.dart         # Question loading, filtering, localization
├── l10n/
│   └── app_strings.dart               # All UI strings (English + French)
├── models/
│   └── question.dart                  # Question, Language, TestType enums & models
├── screens/
│   ├── achievements_screen.dart
│   ├── dashboard_screen.dart
│   ├── practice_screen.dart
│   ├── progress_screen.dart
│   ├── results_screen.dart
│   ├── review_screen.dart
│   ├── settings_screen.dart
│   ├── study_guide_screen.dart
│   └── test_session_screen.dart
├── widgets/
│   └── ontario_theme.dart             # Shared theme colours and card widgets
└── main.dart
test/
├── gamification_test.dart
├── models_test.dart
├── question_data_test.dart
├── settings_test.dart
├── smart_learning_test.dart
└── widget_test.dart
docs/                                  # GitHub Pages website
```

---

## Language Support

The app ships with **full bilingual support** (English / Français). Language is selectable in Settings and persists across sessions.

| Component | English | French |
|-----------|---------|--------|
| All 352 questions | ✅ | ✅ |
| All UI strings | ✅ | ✅ |
| Navigation labels | ✅ | ✅ |
| Category names | ✅ | ✅ |
| Difficulty labels | ✅ | ✅ |

Translation architecture uses a lightweight `AppStrings` class — no additional packages required.

---

## Architecture

- **State management**: `ChangeNotifier` singletons (`SettingsController`, `GamificationController`, `SmartLearningController`)
- **Persistence**: `SharedPreferences` for all user data
- **Localization**: `AppStrings(Language)` pattern — no `flutter_localizations` dependency
- **Question data**: In-memory constant list, filtered and localized on-the-fly
- **Option shuffling**: Occurs after localization to preserve the `correctAnswer` index

---

## Content Source

All questions are adapted from the **Ontario MTO Driver's Handbook 2026**.
- Official test: 40 questions, 80% passing score (32/40)
- Short test: 20 questions, 80% passing score (16/20)

---

## Contributing

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Commit your changes: `git commit -m "feat: add ..."`
4. Push and open a Pull Request

---

## License

© 2024 ExcelDriving. All rights reserved.

Content sourced from the Ontario MTO Driver's Handbook is used for educational purposes only.

