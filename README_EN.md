# Vibe Music App

<p align="center">
  <img src="assets/images/icons/icon.png" alt="Vibe Music App Icon" width="120" height="120">
</p>

<p align="center">
  <strong>A modern cross-platform music player application built with Flutter</strong>
</p>

<p align="center">
  <a href="README_EN.md">English</a> | 
  <a href="README.md">简体中文</a> | 
  <a href="README_ZH_TW.md">繁體中文</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat-square&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat-square&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-green?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/Version-0.1.7-blue?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-orange?style=flat-square" alt="License">
</p>

---

## 📖 Table of Contents

- [Project Introduction](#project-introduction)
- [Features](#features)
- [Project Highlights](#project-highlights)
- [Technology Stack](#technology-stack)
- [Project Architecture](#project-architecture)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Build and Deployment](#build-and-deployment)
- [Changelog](#changelog)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)

---

## Project Introduction

**Vibe Music App** is a fully-featured modern music player application designed to connect and play music from Vibe Music Server. Built with Flutter framework, it supports Android, iOS, Web, and Desktop platforms (Windows, macOS, Linux).

### Core Highlights

- 🎨 **Modern UI Design** - Material Design 3 with dark/light theme switching
- 🎵 **Complete Playback Features** - Multiple playback modes, volume control, progress adjustment
- 📱 **Cross-Platform Support** - One codebase, multiple platforms
- 💾 **Local Data Persistence** - Floor database for playback history, favorites, etc.
- 🌐 **Internationalization** - Supports Chinese (Simplified/Traditional), English
- 🔐 **User Authentication** - Complete login/registration with admin privileges
- 🎭 **Responsive Layout** - Perfect adaptation to phones, tablets, desktops

---

## Features

### 🎵 Audio Playback

- ✅ Play, pause, previous, next
- ✅ Progress bar seeking
- ✅ Volume control (gesture/slider)
- ✅ Background playback support
- ✅ Playback state persistence

### 🔄 Playback Control

- ✅ Single track loop
- ✅ Playlist loop
- ✅ Shuffle play
- ✅ Sequential play

### ❤️ Favorites Management

- ✅ Add/remove favorites
- ✅ View favorites list
- ✅ Quick favorite button

### 🔍 Search

- ✅ Song search
- ✅ Real-time search results
- ✅ Search history

### 📋 Playlist

- ✅ Current playlist display
- ✅ Playlist management (add/delete/clear)
- ✅ Click to play specific song
- ✅ Favorite songs in playlist

### 🎨 UI Design

- ✅ Material Design 3 style
- ✅ Dark/light theme switching
- ✅ Smooth animations
- ✅ Glassmorphism background effects
- ✅ Responsive layout adaptation

### 👤 User System

- ✅ User registration/login
- ✅ User profile management
- ✅ Admin features
- ✅ Permission control

### 💾 Data Storage

- ✅ Local database (Floor + SQLite)
- ✅ Playback history
- ✅ Playback state persistence
- ✅ User preferences

### 🌐 Network

- ✅ RESTful API integration
- ✅ Network status detection
- ✅ Image caching
- ✅ Error handling and retry

### 🌍 Internationalization

- ✅ Chinese (Simplified)
- ✅ Chinese (Traditional)
- ✅ English
- ✅ Dynamic language switching

---

## Project Highlights

### 1. Modern Architecture Design

Adopts **MVVM architecture pattern** with GetX state management for clear code separation:

```
View (UI) ← Observes ← ViewModel (Controller) ← Calls ← Model (Data)
```

### 2. Reactive Programming

Uses GetX reactive programming for automatic data-UI binding:

```dart
// Reactive state
var isPlaying = false.obs;

// Auto-updating UI
Obx(() => Icon(isPlaying.value ? Icons.pause : Icons.play_arrow))
```

### 3. Modular Design

Each feature module is independently organized with:
- `view.dart` - UI implementation
- `controller.dart` - Business logic
- `components/` - Sub-components

### 4. Cross-Platform Adaptation

- Mobile: Bottom navigation + floating playback bar
- Desktop: Sidebar navigation + right playlist panel
- Web: Responsive layout auto-adaptation

### 5. Performance Optimization

- Image caching (cached_network_image)
- Lazy list loading
- Local state updates
- Database index optimization

---

## Technology Stack

### Core Framework

| Technology | Version | Description |
|------------|---------|-------------|
| Flutter | 3.0+ | UI Framework |
| Dart | 3.0+ | Programming Language |

### Main Dependencies

| Category | Dependency | Description |
|----------|------------|-------------|
| **State Management** | GetX | Reactive state management, routing, dependency injection |
| **Network** | Dio | HTTP client with interceptors, timeout support |
| **Audio Playback** | just_audio + audioplayers | Audio playback engine |
| **Local Storage** | Floor + SQLite | Database ORM |
| **Image Loading** | cached_network_image | Network image caching |
| **Environment** | flutter_dotenv | Environment configuration management |
| **Internationalization** | intl + flutter_localizations | Multi-language support |
| **Code Generation** | freezed | Immutable data models |
| **Logging** | logger | Logging |
| **Permissions** | permission_handler | Permission management |
| **Device Info** | device_info_plus | Device information |
| **Network Detection** | connectivity_plus | Network status monitoring |
| **Animation** | shimmer | Skeleton loading animation |
| **Carousel** | carousel_slider | Carousel component |
| **Splash Screen** | flutter_native_splash | Native splash screen |
| **Icons** | flutter_svg | SVG icon support |
| **Encryption** | pointycastle + encrypt | Data encryption |

---

## Project Architecture

### Overall Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Pages   │  │Components│  │ Widgets  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ Observes state changes
┌─────────────────────────────────────────────────────────┐
│                   State Management                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ViewModels│  │Controllers│  │ Providers│              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ Calls services
┌─────────────────────────────────────────────────────────┐
│                   Service Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │   API    │  │  Audio   │  │ Database │              │
│  │ Service  │  │ Service  │  │ Service  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ Data operations
┌─────────────────────────────────────────────────────────┐
│                    Data Layer                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Models  │  │ Entities │  │   DAOs   │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
```

### MVVM Architecture

This project adopts **MVVM (Model-View-ViewModel)** architecture pattern:

- **Model**: Data structures and business logic
  - `models/` - Data models (Song, User, etc.)
  - `data/` - Database entities and DAOs

- **View**: UI presentation and user interaction
  - `pages/` - Pages
  - `components/` - Components
  - `widgets/view.dart` - View implementation

- **ViewModel**: State management and business logic
  - `widgets/controller.dart` - Controllers
  - `controllers/` - Global controllers

---

## Quick Start

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio or VS Code (recommended)
- Emulator or real device

### Installation Steps

1. **Clone the repository**

```bash
# GitHub
git clone https://github.com/AmisKwok/vibe-music-app.git

# Or Gitee (recommended for users in China)
git clone https://gitee.com/AmisKwok/vibe-music-app.git

cd vibe_music_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure environment variables**

```bash
# Copy environment template
cp .env.template .env

# Edit .env file and configure server address
```

`.env` file content:

```env
# API base URL
BASE_URL=http://your-server-address:8080

# API timeout (milliseconds)
API_TIMEOUT=30000

# Base IP address (for replacing image URLs in responses)
BASE_IP=http://your-server-address
```

4. **Run the application**

```bash
# Run on emulator or connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# View available devices
flutter devices
```

---

## Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `BASE_URL` | API server address | `http://192.168.1.100:8080` |
| `API_TIMEOUT` | API timeout (milliseconds) | `30000` |
| `BASE_IP` | Base IP address (for image URLs) | `http://192.168.1.100` |

### Platform Configuration

#### Android

- **Minimum SDK Version**: 21 (Android 5.0)
- **Target SDK Version**: Based on Flutter configuration
- **Permissions**:
  - Network access
  - Storage read/write
  - Foreground service (background playback)

#### iOS

- **Minimum iOS Version**: 11.0
- **Permissions**:
  - Network access
  - Background audio playback

#### Web

- Supports Chrome, Firefox, Safari, Edge
- Requires HTTPS environment (production)

#### Desktop

- **Windows**: Windows 10+
- **macOS**: macOS 10.14+
- **Linux**: Modern Linux distributions

---

## Build and Deployment

### Android

```bash
# Build release APK
flutter build apk --release

# Build split APKs (smaller size)
flutter build apk --split-per-abi

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Build release iOS app
flutter build ios --release

# Build iOS app package (requires macOS)
flutter build ipa --release
```

### Web

```bash
# Build web version
flutter build web --release

# Built files located in build/web/ directory
```

### Desktop

```bash
# Build Windows version
flutter build windows --release

# Build macOS version
flutter build macos --release

# Build Linux version
flutter build linux --release
```

---

## Changelog

### v0.1.7 (2026-03-04)

**New Features**
- ✨ Added CC BY-NC-SA 4.0 open source license
- ✨ Optimized README documentation structure
- ✨ Added project badges and detailed descriptions

**Bug Fixes**
- 🐛 Fixed playback duration showing 0 on second app launch
- 🐛 Fixed UI not updating after deleting songs from playlist
- 🐛 Fixed app stuck on splash screen on startup
- 🐛 Fixed floating playback component not hiding on player page

**Improvements**
- ♻️ Refactored project architecture documentation (MVC → MVVM)
- ♻️ Optimized code comments and documentation
- ⚡ Performance optimization and memory management improvements

### v0.1.0 (2026-01-23)

**Initial Release**
- 🎉 Basic music playback functionality
- 🎨 Modern UI design
- 💾 Local database support
- 🌐 Network requests and API integration
- 👤 User authentication system

For complete changelog, see [CHANGELOG.md](CHANGELOG.md)

---

## Roadmap

### Short-term (v0.2.0)

- [ ] Lyrics display
- [ ] Song download feature
- [ ] Playlist creation and management
- [ ] Playback history
- [ ] Song sharing

### Mid-term (v0.3.0)

- [ ] Desktop lyrics display
- [ ] Equalizer
- [ ] Audio effects settings
- [ ] Theme customization
- [ ] Playback statistics

### Long-term (v1.0.0)

- [ ] Local music scanning
- [ ] Music visualization
- [ ] Smart recommendations
- [ ] Social features
- [ ] Cloud sync

For detailed task list, see [TODO_LIST.md](TODO_LIST.md)

---

## Contributing

We welcome all forms of contributions!

### How to Contribute

1. **Fork the repository**
```bash
git clone https://github.com/AmisKwok/vibe-music-app.git
```

2. **Create a feature branch**
```bash
git checkout -b feature/your-feature-name
```

3. **Commit your changes**
```bash
git add .
git commit -m "✨ Add: new feature description"
```

4. **Push to the branch**
```bash
git push origin feature/your-feature-name
```

5. **Create a Pull Request**

### Commit Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `✨ Add:` New feature
- `🐛 Fix:` Bug fix
- `♻️ Refactor:` Code refactoring
- `📝 Docs:` Documentation update
- `🎨 Style:` Code formatting
- `⚡ Perf:` Performance optimization
- `✅ Test:` Testing related

### Code Review

All PRs require code review:
1. Code style check
2. Functional testing
3. Performance evaluation
4. Documentation completeness

---

## License

This project is licensed under **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (CC BY-NC-SA 4.0)**.

### License Features

| Permissions | Conditions | Limitations |
|-------------|------------|-------------|
| ✅ Share | 📝 Attribution | ❌ No commercial use |
| ✅ Adapt | 🔄 ShareAlike | ❌ No additional restrictions |

### In Simple Terms

**You CAN:**
- ✅ Copy and distribute this work
- ✅ Remix, transform, and build upon this work
- ✅ Use for learning, research, and personal use

**You MUST:**
- 📝 Keep copyright notice
- 📝 Provide link to license
- 📝 Indicate if changes were made
- 🔄 Distribute derivatives under same license

**You CANNOT:**
- ❌ Use for commercial purposes
- ❌ Sell this software or modified versions
- ❌ Obtain commercial benefit from this software

For full license text, see [LICENSE](LICENSE) file.

---

## Contact

### Project Links

- **GitHub**: https://github.com/AmisKwok/vibe-music-app
- **Gitee**: https://gitee.com/AmisKwok/vibe-music-app

### Issue Feedback

- **GitHub Issues**: https://github.com/AmisKwok/vibe-music-app/issues
- **Gitee Issues**: https://gitee.com/AmisKwok/vibe-music-app/issues

### Author

- **AmisKwok**

---

## Acknowledgments

Thanks to everyone who contributed to this project!

---

<p align="center">
  <strong>Enjoy music, enjoy life! 🎧</strong>
</p>

<p align="center">
  If this project helps you, please give it a ⭐️ Star!
</p>
