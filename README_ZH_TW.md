# Vibe Music App

<p align="center">
  <img src="assets/images/icons/icon.png" alt="Vibe Music App Icon" width="120" height="120">
</p>

<p align="center">
  <strong>一款基於 Flutter 開發的現代化跨平台音樂播放器應用</strong>
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

## 📖 目錄

- [專案簡介](#專案簡介)
- [功能特點](#功能特點)
- [專案特色](#專案特色)
- [技術堆疊](#技術堆疊)
- [專案架構](#專案架構)
- [快速開始](#快速開始)
- [配置說明](#配置說明)
- [構建和部署](#構建和部署)
- [更新日誌](#更新日誌)
- [開發路線圖](#開發路線圖)
- [貢獻指南](#貢獻指南)
- [許可證](#許可證)
- [聯繫方式](#聯繫方式)
- [致謝](#致謝)

---

## 專案簡介

**Vibe Music App** 是一款功能完善的現代化音樂播放器應用，專為連接和播放 Vibe Music Server 中的音樂而設計。採用 Flutter 框架開發，支援 Android、iOS、Web 和桌面平台（Windows、macOS、Linux）。

### 核心亮點

- 🎨 **現代化 UI 設計** - 採用 Material Design 3，支援深色/淺色主題切換
- 🎵 **完整的播放功能** - 支援多種播放模式、音量控制、進度調節
- 📱 **跨平台支援** - 一套程式碼，多端運行
- 💾 **本地資料持久化** - 使用 Floor 資料庫儲存播放歷史、收藏等
- 🌐 **國際化支援** - 支援中文（簡體/繁體）、英文多語言
- 🔐 **使用者認證系統** - 完整的登入註冊功能，支援管理員權限
- 🎭 **響應式佈局** - 完美適配手機、平板、桌面等不同螢幕尺寸

---

## 功能特點

### 🎵 音頻播放

- ✅ 播放、暫停、上一曲、下一曲
- ✅ 進度條拖動定位
- ✅ 音量調節（手勢滑動/滑塊）
- ✅ 後台播放支援
- ✅ 播放狀態持久化

### 🔄 播放控制

- ✅ 單曲循環
- ✅ 列表循環
- ✅ 隨機播放
- ✅ 順序播放

### ❤️ 收藏管理

- ✅ 收藏/取消收藏歌曲
- ✅ 收藏列表查看
- ✅ 快速收藏按鈕

### 🔍 搜尋功能

- ✅ 歌曲搜尋
- ✅ 即時搜尋結果
- ✅ 搜尋歷史記錄

### 📋 播放列表

- ✅ 當前播放列表顯示
- ✅ 播放列表管理（添加/刪除/清空）
- ✅ 點擊播放指定歌曲
- ✅ 播放列表內收藏操作

### 🎨 介面設計

- ✅ Material Design 3 風格
- ✅ 深色/淺色主題切換
- ✅ 流暢的動畫效果
- ✅ 毛玻璃背景效果
- ✅ 響應式佈局適配

### 👤 使用者系統

- ✅ 使用者註冊/登入
- ✅ 使用者資訊管理
- ✅ 管理員功能
- ✅ 權限控制

### 💾 資料儲存

- ✅ 本地資料庫（Floor + SQLite）
- ✅ 播放歷史記錄
- ✅ 播放狀態持久化
- ✅ 使用者偏好設定

### 🌐 網路功能

- ✅ RESTful API 對接
- ✅ 網路狀態檢測
- ✅ 圖片快取載入
- ✅ 錯誤處理和重試

### 🌍 國際化

- ✅ 中文（簡體）
- ✅ 中文（繁體）
- ✅ 英文
- ✅ 動態語言切換

---

## 專案特色

### 1. 現代化架構設計

採用 **MVVM 架構模式**，結合 GetX 狀態管理，實現清晰的程式碼分層：

```
View (UI) ← 觀察 ← ViewModel (Controller) ← 調用 ← Model (資料)
```

### 2. 響應式程式設計

使用 GetX 的響應式程式設計特性，實現資料與 UI 的自動綁定：

```dart
// 響應式狀態
var isPlaying = false.obs;

// UI 自動更新
Obx(() => Icon(isPlaying.value ? Icons.pause : Icons.play_arrow))
```

### 3. 模組化設計

每個功能模組獨立組織，包含：
- `view.dart` - UI 實現
- `controller.dart` - 業務邏輯
- `components/` - 子組件

### 4. 跨平台適配

- 行動端：底部導航 + 浮層播放條
- 桌面端：側邊欄導航 + 右側播放列表面板
- Web：響應式佈局自動適配

### 5. 效能優化

- 圖片快取（cached_network_image）
- 列表懶加載
- 狀態局部更新
- 資料庫索引優化

---

## 技術堆疊

### 核心框架

| 技術 | 版本 | 說明 |
|------|------|------|
| Flutter | 3.0+ | UI 框架 |
| Dart | 3.0+ | 程式語言 |

### 主要依賴

| 類別 | 依賴 | 說明 |
|------|------|------|
| **狀態管理** | GetX | 響應式狀態管理、路由管理、依賴注入 |
| **網路請求** | Dio | HTTP 客戶端，支援攔截器、超時等 |
| **音頻播放** | just_audio + audioplayers | 音頻播放引擎 |
| **本地儲存** | Floor + SQLite | 資料庫 ORM |
| **圖片載入** | cached_network_image | 網路圖片快取 |
| **環境變數** | flutter_dotenv | 環境配置管理 |
| **國際化** | intl + flutter_localizations | 多語言支援 |
| **程式碼生成** | freezed | 不可變資料模型 |
| **日誌** | logger | 日誌記錄 |
| **權限** | permission_handler | 權限管理 |
| **設備資訊** | device_info_plus | 設備資訊獲取 |
| **網路檢測** | connectivity_plus | 網路狀態監聽 |
| **動畫** | shimmer | 骨架屏載入動畫 |
| **輪播** | carousel_slider | 輪播圖組件 |
| **啟動頁** | flutter_native_splash | 原生啟動頁 |
| **圖示** | flutter_svg | SVG 圖示支援 |
| **加密** | pointycastle + encrypt | 資料加密 |

---

## 專案架構

### 整體架構

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Pages   │  │Components│  │ Widgets  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ 觀察狀態變化
┌─────────────────────────────────────────────────────────┐
│                   State Management                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ViewModels│  │Controllers│  │ Providers│              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ 調用服務
┌─────────────────────────────────────────────────────────┐
│                   Service Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │   API    │  │  Audio   │  │ Database │              │
│  │ Service  │  │ Service  │  │ Service  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ 資料操作
┌─────────────────────────────────────────────────────────┐
│                    Data Layer                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Models  │  │ Entities │  │   DAOs   │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
```

### MVVM 架構

本專案採用 **MVVM (Model-View-ViewModel)** 架構模式：

- **Model（模型）**：資料結構和業務邏輯
  - `models/` - 資料模型（Song, User 等）
  - `data/` - 資料庫實體和 DAO

- **View（視圖）**：UI 展示和使用者互動
  - `pages/` - 頁面
  - `components/` - 組件
  - `widgets/view.dart` - 視圖實現

- **ViewModel（視圖模型）**：狀態管理和業務邏輯
  - `widgets/controller.dart` - 控制器
  - `controllers/` - 全局控制器

---

## 快速開始

### 前提條件

- Flutter SDK 3.0 或更高版本
- Dart SDK 3.0 或更高版本
- Android Studio 或 VS Code（推薦）
- 模擬器或真實設備

### 安裝步驟

1. **克隆倉庫**

```bash
# GitHub
git clone https://github.com/AmisKwok/vibe-music-app.git

# 或 Gitee（國內用戶推薦）
git clone https://gitee.com/AmisKwok/vibe-music-app.git

cd vibe_music_app
```

2. **安裝依賴**

```bash
flutter pub get
```

3. **配置環境變數**

```bash
# 複製環境變數模板
cp .env.template .env

# 編輯 .env 檔案，配置伺服器地址
```

`.env` 檔案內容：

```env
# API 基礎 URL
BASE_URL=http://your-server-address:8080

# API 超時時間（毫秒）
API_TIMEOUT=30000

# 基礎 IP 地址（用於替換響應中的圖片 URL）
BASE_IP=http://your-server-address
```

4. **運行應用**

```bash
# 在模擬器或連接的設備上運行
flutter run

# 運行特定設備
flutter run -d <device-id>

# 查看可用設備
flutter devices
```

---

## 配置說明

### 環境變數配置

| 變數名 | 說明 | 範例值 |
|--------|------|--------|
| `BASE_URL` | API 伺服器地址 | `http://192.168.1.100:8080` |
| `API_TIMEOUT` | API 超時時間（毫秒） | `30000` |
| `BASE_IP` | 基礎 IP 地址（用於圖片 URL） | `http://192.168.1.100` |

### 平台配置

#### Android

- **最小 SDK 版本**：21 (Android 5.0)
- **目標 SDK 版本**：根據 Flutter 配置
- **權限**：
  - 網路存取
  - 儲存讀寫
  - 前台服務（後台播放）

#### iOS

- **最低 iOS 版本**：11.0
- **權限**：
  - 網路存取
  - 後台音頻播放

#### Web

- 支援 Chrome、Firefox、Safari、Edge
- 需要 HTTPS 環境（生產環境）

#### Desktop

- **Windows**：Windows 10+
- **macOS**：macOS 10.14+
- **Linux**：現代 Linux 發行版

---

## 構建和部署

### Android

```bash
# 構建 release 版本的 APK
flutter build apk --release

# 構建拆分 APK（更小的體積）
flutter build apk --split-per-abi

# 構建 App Bundle（用於 Google Play）
flutter build appbundle --release
```

### iOS

```bash
# 構建 release 版本的 iOS 應用
flutter build ios --release

# 構建 iOS 應用包（需要 macOS）
flutter build ipa --release
```

### Web

```bash
# 構建 Web 版本
flutter build web --release

# 構建後檔案位於 build/web/ 目錄
```

### Desktop

```bash
# 構建 Windows 版本
flutter build windows --release

# 構建 macOS 版本
flutter build macos --release

# 構建 Linux 版本
flutter build linux --release
```

---

## 更新日誌

### v0.1.7 (2026-03-04)

**新增功能**
- ✨ 添加 CC BY-NC-SA 4.0 開源協議
- ✨ 優化 README 文檔結構
- ✨ 添加專案徽章和詳細說明

**問題修復**
- 🐛 修復第二次啟動應用時播放時長顯示為0的問題
- 🐛 修復播放列表刪除歌曲後 UI 不更新的問題
- 🐛 修復應用啟動時卡在啟動頁的問題
- 🐛 修復浮層播放組件在播放頁未隱藏的問題

**優化改進**
- ♻️ 重構專案架構說明（MVC → MVVM）
- ♻️ 優化程式碼註釋和文檔
- ⚡ 效能優化和記憶體管理改進

### v0.1.0 (2026-01-23)

**首次發布**
- 🎉 基礎音樂播放功能
- 🎨 現代化 UI 設計
- 💾 本地資料庫支援
- 🌐 網路請求和 API 對接
- 👤 使用者認證系統

完整更新日誌請查看 [CHANGELOG.md](CHANGELOG.md)

---

## 開發路線圖

### 近期計劃 (v0.2.0)

- [ ] 歌詞顯示功能
- [ ] 歌曲下載功能
- [ ] 歌單創建與管理
- [ ] 播放歷史記錄
- [ ] 歌曲分享功能

### 中期計劃 (v0.3.0)

- [ ] 桌面歌詞顯示
- [ ] 均衡器功能
- [ ] 音效設定
- [ ] 主題自定義
- [ ] 播放統計

### 長期計劃 (v1.0.0)

- [ ] 本地音樂掃描
- [ ] 音樂視覺化效果
- [ ] 智能推薦
- [ ] 社交功能
- [ ] 雲端同步

詳細任務列表請查看 [TODO_LIST.md](TODO_LIST.md)

---

## 貢獻指南

我們歡迎所有形式的貢獻！

### 如何貢獻

1. **Fork 倉庫**
```bash
git clone https://github.com/AmisKwok/vibe-music-app.git
```

2. **創建功能分支**
```bash
git checkout -b feature/your-feature-name
```

3. **提交更改**
```bash
git add .
git commit -m "✨ Add: 添加新功能描述"
```

4. **推送到分支**
```bash
git push origin feature/your-feature-name
```

5. **創建 Pull Request**

### 提交規範

使用 [Conventional Commits](https://www.conventionalcommits.org/) 規範：

- `✨ Add:` 新功能
- `🐛 Fix:` 修復問題
- `♻️ Refactor:` 程式碼重構
- `📝 Docs:` 文檔更新
- `🎨 Style:` 程式碼格式調整
- `⚡ Perf:` 效能優化
- `✅ Test:` 測試相關

### 程式碼審查

所有 PR 都需要經過程式碼審查：
1. 程式碼風格檢查
2. 功能測試
3. 效能評估
4. 文檔完整性

---

## 許可證

本專案採用 **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (CC BY-NC-SA 4.0)** 許可協議。

### 許可證特點

| 權限 | 條件 | 限制 |
|------|------|------|
| ✅ 共享 | 📝 署名 | ❌ 禁止商業使用 |
| ✅ 修改 | 🔄 相同方式共享 | ❌ 無附加限制 |

### 簡單來說

**你可以：**
- ✅ 複製、分發本作品
- ✅ 修改、轉換或基於本作品進行創作
- ✅ 用於學習、研究和個人使用

**你必須：**
- 📝 保留版權聲明
- 📝 提供許可協議連結
- 📝 說明是否進行了修改
- 🔄 使用相同協議分發衍生作品

**你不能：**
- ❌ 用於商業目的
- ❌ 銷售本軟體或其修改版本
- ❌ 通過本軟體獲取商業利益

完整協議文本請查看 [LICENSE](LICENSE) 檔案。

---

## 聯繫方式

### 專案地址

- **GitHub**: https://github.com/AmisKwok/vibe-music-app
- **Gitee**: https://gitee.com/AmisKwok/vibe-music-app

### 問題反饋

- **GitHub Issues**: https://github.com/AmisKwok/vibe-music-app/issues
- **Gitee Issues**: https://gitee.com/AmisKwok/vibe-music-app/issues

### 作者

- **AmisKwok**

---

## 致謝

感謝所有為這個專案做出貢獻的人！

---

<p align="center">
  <strong>享受音樂，享受生活！🎧</strong>
</p>

<p align="center">
  如果這個專案對你有幫助，請給一個 ⭐️ Star 支持一下！
</p>
