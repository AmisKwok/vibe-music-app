# Vibe Music App

<p align="center">
  <img src="assets/images/icons/icon.png" alt="Vibe Music App Icon" width="120" height="120">
</p>

<p align="center">
  <strong>一款基于 Flutter 开发的现代化跨平台音乐播放器应用</strong>
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

## 📖 目录

- [项目简介](#项目简介)
- [功能特点](#功能特点)
- [项目特色](#项目特色)
- [技术栈](#技术栈)
- [项目架构](#项目架构)
- [快速开始](#快速开始)
- [配置说明](#配置说明)
- [构建和部署](#构建和部署)
- [更新日志](#更新日志)
- [开发路线图](#开发路线图)
- [贡献指南](#贡献指南)
- [许可证](#许可证)
- [联系方式](#联系方式)
- [致谢](#致谢)

---

## 项目简介

**Vibe Music App** 是一款功能完善的现代化音乐播放器应用，专为连接和播放 Vibe Music Server 中的音乐而设计。采用 Flutter 框架开发，支持 Android、iOS、Web 和桌面平台（Windows、macOS、Linux）。

### 核心亮点

- 🎨 **现代化 UI 设计** - 采用 Material Design 3，支持深色/浅色主题切换
- 🎵 **完整的播放功能** - 支持多种播放模式、音量控制、进度调节
- 📱 **跨平台支持** - 一套代码，多端运行
- 💾 **本地数据持久化** - 使用 Floor 数据库存储播放历史、收藏等
- 🌐 **国际化支持** - 支持中文（简体/繁体）、英文多语言
- 🔐 **用户认证系统** - 完整的登录注册功能，支持管理员权限
- 🎭 **响应式布局** - 完美适配手机、平板、桌面等不同屏幕尺寸

---

## 功能特点

### 🎵 音频播放

- ✅ 播放、暂停、上一曲、下一曲
- ✅ 进度条拖动定位
- ✅ 音量调节（手势滑动/滑块）
- ✅ 后台播放支持
- ✅ 播放状态持久化

### 🔄 播放控制

- ✅ 单曲循环
- ✅ 列表循环
- ✅ 随机播放
- ✅ 顺序播放

### ❤️ 收藏管理

- ✅ 收藏/取消收藏歌曲
- ✅ 收藏列表查看
- ✅ 快速收藏按钮

### 🔍 搜索功能

- ✅ 歌曲搜索
- ✅ 实时搜索结果
- ✅ 搜索历史记录

### 📋 播放列表

- ✅ 当前播放列表显示
- ✅ 播放列表管理（添加/删除/清空）
- ✅ 点击播放指定歌曲
- ✅ 播放列表内收藏操作

### 🎨 界面设计

- ✅ Material Design 3 风格
- ✅ 深色/浅色主题切换
- ✅ 流畅的动画效果
- ✅ 毛玻璃背景效果
- ✅ 响应式布局适配

### 👤 用户系统

- ✅ 用户注册/登录
- ✅ 用户信息管理
- ✅ 管理员功能
- ✅ 权限控制

### 💾 数据存储

- ✅ 本地数据库（Floor + SQLite）
- ✅ 播放历史记录
- ✅ 播放状态持久化
- ✅ 用户偏好设置

### 🌐 网络功能

- ✅ RESTful API 对接
- ✅ 网络状态检测
- ✅ 图片缓存加载
- ✅ 错误处理和重试

### 🌍 国际化

- ✅ 中文（简体）
- ✅ 中文（繁体）
- ✅ 英文
- ✅ 动态语言切换

---

## 项目特色

### 1. 现代化架构设计

采用 **MVVM 架构模式**，结合 GetX 状态管理，实现清晰的代码分层：

```
View (UI) ← 观察 ← ViewModel (Controller) ← 调用 ← Model (数据)
```

### 2. 响应式编程

使用 GetX 的响应式编程特性，实现数据与 UI 的自动绑定：

```dart
// 响应式状态
var isPlaying = false.obs;

// UI 自动更新
Obx(() => Icon(isPlaying.value ? Icons.pause : Icons.play_arrow))
```

### 3. 模块化设计

每个功能模块独立组织，包含：
- `view.dart` - UI 实现
- `controller.dart` - 业务逻辑
- `components/` - 子组件

### 4. 跨平台适配

- 移动端：底部导航 + 浮层播放条
- 桌面端：侧边栏导航 + 右侧播放列表面板
- Web：响应式布局自动适配

### 5. 性能优化

- 图片缓存（cached_network_image）
- 列表懒加载
- 状态局部更新
- 数据库索引优化

---

## 技术栈

### 核心框架

| 技术 | 版本 | 说明 |
|------|------|------|
| Flutter | 3.0+ | UI 框架 |
| Dart | 3.0+ | 编程语言 |

### 主要依赖

| 类别 | 依赖 | 说明 |
|------|------|------|
| **状态管理** | GetX | 响应式状态管理、路由管理、依赖注入 |
| **网络请求** | Dio | HTTP 客户端，支持拦截器、超时等 |
| **音频播放** | just_audio + audioplayers | 音频播放引擎 |
| **本地存储** | Floor + SQLite | 数据库 ORM |
| **图片加载** | cached_network_image | 网络图片缓存 |
| **环境变量** | flutter_dotenv | 环境配置管理 |
| **国际化** | intl + flutter_localizations | 多语言支持 |
| **代码生成** | freezed | 不可变数据模型 |
| **日志** | logger | 日志记录 |
| **权限** | permission_handler | 权限管理 |
| **设备信息** | device_info_plus | 设备信息获取 |
| **网络检测** | connectivity_plus | 网络状态监听 |
| **动画** | shimmer | 骨架屏加载动画 |
| **轮播** | carousel_slider | 轮播图组件 |
| **启动页** | flutter_native_splash | 原生启动页 |
| **图标** | flutter_svg | SVG 图标支持 |
| **加密** | pointycastle + encrypt | 数据加密 |

---

## 项目架构

### 整体架构

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Pages   │  │Components│  │ Widgets  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ 观察状态变化
┌─────────────────────────────────────────────────────────┐
│                   State Management                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ViewModels│  │Controllers│  │ Providers│              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ 调用服务
┌─────────────────────────────────────────────────────────┐
│                   Service Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │   API    │  │  Audio   │  │ Database │              │
│  │ Service  │  │ Service  │  │ Service  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                        ↓ 数据操作
┌─────────────────────────────────────────────────────────┐
│                    Data Layer                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Models  │  │ Entities │  │   DAOs   │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
```

### MVVM 架构

本项目采用 **MVVM (Model-View-ViewModel)** 架构模式：

- **Model（模型）**：数据结构和业务逻辑
  - `models/` - 数据模型（Song, User 等）
  - `data/` - 数据库实体和 DAO

- **View（视图）**：UI 展示和用户交互
  - `pages/` - 页面
  - `components/` - 组件
  - `widgets/view.dart` - 视图实现

- **ViewModel（视图模型）**：状态管理和业务逻辑
  - `widgets/controller.dart` - 控制器
  - `controllers/` - 全局控制器

---

## 快速开始

### 前提条件

- Flutter SDK 3.0 或更高版本
- Dart SDK 3.0 或更高版本
- Android Studio 或 VS Code（推荐）
- 模拟器或真实设备

### 安装步骤

1. **克隆仓库**

```bash
# GitHub
git clone https://github.com/AmisKwok/vibe-music-app.git

# 或 Gitee（国内用户推荐）
git clone https://gitee.com/AmisKwok/vibe-music-app.git

cd vibe_music_app
```

2. **安装依赖**

```bash
flutter pub get
```

3. **配置环境变量**

```bash
# 复制环境变量模板
cp .env.template .env

# 编辑 .env 文件，配置服务器地址
```

`.env` 文件内容：

```env
# API 基础 URL
BASE_URL=http://your-server-address:8080

# API 超时时间（毫秒）
API_TIMEOUT=30000

# 基础 IP 地址（用于替换响应中的图片 URL）
BASE_IP=http://your-server-address
```

4. **运行应用**

```bash
# 在模拟器或连接的设备上运行
flutter run

# 运行特定设备
flutter run -d <device-id>

# 查看可用设备
flutter devices
```

---

## 配置说明

### 环境变量配置

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `BASE_URL` | API 服务器地址 | `http://192.168.1.100:8080` |
| `API_TIMEOUT` | API 超时时间（毫秒） | `30000` |
| `BASE_IP` | 基础 IP 地址（用于图片 URL） | `http://192.168.1.100` |

### 平台配置

#### Android

- **最小 SDK 版本**：21 (Android 5.0)
- **目标 SDK 版本**：根据 Flutter 配置
- **权限**：
  - 网络访问
  - 存储读写
  - 前台服务（后台播放）

#### iOS

- **最低 iOS 版本**：11.0
- **权限**：
  - 网络访问
  - 后台音频播放

#### Web

- 支持 Chrome、Firefox、Safari、Edge
- 需要 HTTPS 环境（生产环境）

#### Desktop

- **Windows**：Windows 10+
- **macOS**：macOS 10.14+
- **Linux**：现代 Linux 发行版

---

## 构建和部署

### Android

```bash
# 构建 release 版本的 APK
flutter build apk --release

# 构建拆分 APK（更小的体积）
flutter build apk --split-per-abi

# 构建 App Bundle（用于 Google Play）
flutter build appbundle --release
```

### iOS

```bash
# 构建 release 版本的 iOS 应用
flutter build ios --release

# 构建 iOS 应用包（需要 macOS）
flutter build ipa --release
```

### Web

```bash
# 构建 Web 版本
flutter build web --release

# 构建后文件位于 build/web/ 目录
```

### Desktop

```bash
# 构建 Windows 版本
flutter build windows --release

# 构建 macOS 版本
flutter build macos --release

# 构建 Linux 版本
flutter build linux --release
```

---

## 更新日志

### v0.1.7 (2026-03-04)

**新增功能**
- ✨ 添加 CC BY-NC-SA 4.0 开源协议
- ✨ 优化 README 文档结构
- ✨ 添加项目徽章和详细说明

**问题修复**
- 🐛 修复第二次启动应用时播放时长显示为0的问题
- 🐛 修复播放列表删除歌曲后 UI 不更新的问题
- 🐛 修复应用启动时卡在启动页的问题
- 🐛 修复浮层播放组件在播放页未隐藏的问题

**优化改进**
- ♻️ 重构项目架构说明（MVC → MVVM）
- ♻️ 优化代码注释和文档
- ⚡ 性能优化和内存管理改进

### v0.1.0 (2026-01-23)

**首次发布**
- 🎉 基础音乐播放功能
- 🎨 现代化 UI 设计
- 💾 本地数据库支持
- 🌐 网络请求和 API 对接
- 👤 用户认证系统

完整更新日志请查看 [CHANGELOG.md](CHANGELOG.md)

---

## 开发路线图

### 近期计划 (v0.2.0)

- [ ] 歌词显示功能
- [ ] 歌曲下载功能
- [ ] 歌单创建与管理
- [ ] 播放历史记录
- [ ] 歌曲分享功能

### 中期计划 (v0.3.0)

- [ ] 桌面歌词显示
- [ ] 均衡器功能
- [ ] 音效设置
- [ ] 主题自定义
- [ ] 播放统计

### 长期计划 (v1.0.0)

- [ ] 本地音乐扫描
- [ ] 音乐可视化效果
- [ ] 智能推荐
- [ ] 社交功能
- [ ] 云端同步

详细任务列表请查看 [TODO_LIST.md](TODO_LIST.md)

---

## 贡献指南

我们欢迎所有形式的贡献！

### 如何贡献

1. **Fork 仓库**
```bash
git clone https://github.com/AmisKwok/vibe-music-app.git
```

2. **创建功能分支**
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

5. **创建 Pull Request**

### 提交规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

- `✨ Add:` 新功能
- `🐛 Fix:` 修复问题
- `♻️ Refactor:` 代码重构
- `📝 Docs:` 文档更新
- `🎨 Style:` 代码格式调整
- `⚡ Perf:` 性能优化
- `✅ Test:` 测试相关

### 代码审查

所有 PR 都需要经过代码审查：
1. 代码风格检查
2. 功能测试
3. 性能评估
4. 文档完整性

---

## 许可证

本项目采用 **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (CC BY-NC-SA 4.0)** 许可协议。

### 许可证特点

| 权限 | 条件 | 限制 |
|------|------|------|
| ✅ 共享 | 📝 署名 | ❌ 禁止商业使用 |
| ✅ 修改 | 🔄 相同方式共享 | ❌ 无附加限制 |

### 简单来说

**你可以：**
- ✅ 复制、分发本作品
- ✅ 修改、转换或基于本作品进行创作
- ✅ 用于学习、研究和个人使用

**你必须：**
- 📝 保留版权声明
- 📝 提供许可协议链接
- 📝 说明是否进行了修改
- 🔄 使用相同协议分发衍生作品

**你不能：**
- ❌ 用于商业目的
- ❌ 销售本软件或其修改版本
- ❌ 通过本软件获取商业利益

完整协议文本请查看 [LICENSE](LICENSE) 文件。

---

## 联系方式

### 项目地址

- **GitHub**: https://github.com/AmisKwok/vibe-music-app
- **Gitee**: https://gitee.com/AmisKwok/vibe-music-app

### 问题反馈

- **GitHub Issues**: https://github.com/AmisKwok/vibe-music-app/issues
- **Gitee Issues**: https://gitee.com/AmisKwok/vibe-music-app/issues

### 作者

- **AmisKwok**

---

## 致谢

感谢所有为这个项目做出贡献的人！

---

<p align="center">
  <strong>享受音乐，享受生活！🎧</strong>
</p>

<p align="center">
  如果这个项目对你有帮助，请给一个 ⭐️ Star 支持一下！
</p>
