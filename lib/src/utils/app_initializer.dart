import 'dart:async';
import 'package:amis_flutter_utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibe_music_app/src/services/custom_cache_manager.dart';
import 'package:vibe_music_app/src/utils/database/index.dart';
import 'package:vibe_music_app/src/utils/di/dependency_injection.dart';

/// 应用初始化器
/// 负责处理应用启动前的所有初始化操作
class AppInitializer {
  /// 初始化应用
  /// [返回值]: 初始化是否成功
  static Future<bool> initialize() async {
    final stopwatch = Stopwatch()..start();

    try {
      // 确保Flutter绑定已初始化
      WidgetsFlutterBinding.ensureInitialized();
      AppLogger().d('✅ Flutter绑定初始化完成');

      // 初始化环境变量
      await _initializeEnvironment();

      // 初始化工具类
      await _initializeUtilities();

      // 初始化依赖注入
      await _initializeDependencyInjection();

      // 请求通知权限（Android 13+）
      await _requestNotificationPermission();

      // 启动时间统计
      stopwatch.stop();
      AppLogger().d('🚀 应用初始化完成，耗时: ${stopwatch.elapsedMilliseconds}ms');

      return true;
    } catch (e) {
      AppLogger().e('❌ 应用初始化失败: $e');
      return false;
    }
  }

  /// 初始化 just_audio_background（应用启动后异步调用）
  static Future<void> initializeJustAudioBackground() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return;
    }

    try {
      AppLogger().d('🔄 开始初始化 just_audio_background...');
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.amis.vibe_music_app.channel.audio',
        androidNotificationChannelName: 'Vibe Music',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'drawable/notification_icon',
      );
      AppLogger().d('✅ just_audio_background 初始化成功');
    } catch (e) {
      AppLogger().e('❌ just_audio_background 初始化失败: $e');
    }
  }

  /// 初始化环境变量
  static Future<void> _initializeEnvironment() async {
    await dotenv.load(fileName: ".env");
    AppLogger().d('✅ 环境变量加载完成');
  }

  /// 初始化工具类
  static Future<void> _initializeUtilities() async {
    // 初始化SpUtil存储工具
    await SpUtil.init();

    try {
      // 初始化数据库
      await DatabaseManager().initDatabase();
    } catch (e) {
      AppLogger().e('数据库初始化失败: $e');
    }

    try {
      // 初始化图片缓存管理器
      await CustomCacheManager.initialize();

      // 预初始化默认缓存管理器的数据库（避免第一次使用时卡顿）
      await _warmUpImageCache();
    } catch (e) {
      AppLogger().e('图片缓存管理器初始化失败: $e');
    }

    // 工具类初始化完成
    AppLogger().d('✅ 工具类初始化完成');
  }

  /// 初始化依赖注入
  static Future<void> _initializeDependencyInjection() async {
    DependencyInjection.init();
  }

  /// 预热图片缓存系统
  /// 通过访问缓存数据库来触发初始化，避免第一次使用时卡顿
  static Future<void> _warmUpImageCache() async {
    try {
      // 触发默认缓存管理器的初始化
      final cacheManager = DefaultCacheManager();

      // 尝试获取缓存信息来触发数据库初始化
      await cacheManager.getFileFromCache('warmup');
      AppLogger().d('图片缓存系统预热完成');
    } catch (e) {
      // 预热失败不影响应用启动
      AppLogger().d('图片缓存系统预热跳过: $e');
    }
  }

  /// 请求通知权限（Android 13+）
  static Future<void> _requestNotificationPermission() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android) return;

    try {
      final status = await Permission.notification.status;
      AppLogger().d('通知权限状态: $status');
      if (status.isDenied) {
        final result = await Permission.notification.request();
        AppLogger().d('通知权限请求结果: $result');
      }
    } catch (e) {
      AppLogger().e('请求通知权限失败: $e');
    }
  }
}
