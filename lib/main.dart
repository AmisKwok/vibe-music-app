import 'package:amis_flutter_utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:vibe_music_app/src/config/app_config.dart';
import 'package:vibe_music_app/src/utils/app_initializer.dart';

Future<void> main() async {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 先初始化日志工具
  AppLogger().initialize();

  // 初始化应用
  await AppInitializer.initialize();

  // 运行应用
  runApp(AppConfig.buildApp());
}
