import 'package:amis_flutter_utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_music_app/src/theme/app_theme.dart';

/// 主题类型枚举
enum ThemeType {
  light,
  dark,
  glassMorphism,
  musike,
}

/// 主题控制器
/// 负责管理应用的主题状态
class ThemeController extends GetxController {
  /// 主题类型
  final Rx<ThemeType> themeType = ThemeType.musike.obs;

  /// 初始化
  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  /// 加载主题
  void _loadTheme() {
    final themeIndex = SpUtil.get<int>('theme_type');
    if (themeIndex != null && themeIndex < ThemeType.values.length) {
      themeType.value = ThemeType.values[themeIndex];
    } else {
      themeType.value = ThemeType.musike;
    }
  }

  /// 切换主题
  Future<void> changeTheme(ThemeType type) async {
    themeType.value = type;
    await SpUtil.put('theme_type', type.index);
    update();
    // 重建整个应用以应用新主题
    Get.forceAppUpdate();
  }

  /// 获取当前主题模式
  ThemeMode getThemeMode() {
    switch (themeType.value) {
      case ThemeType.light:
        return ThemeMode.light;
      case ThemeType.dark:
        return ThemeMode.dark;
      case ThemeType.glassMorphism:
        return ThemeMode.dark;
      case ThemeType.musike:
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  /// 获取当前主题数据
  ThemeData getThemeData() {
    switch (themeType.value) {
      case ThemeType.light:
        return AppTheme.lightTheme;
      case ThemeType.dark:
        return AppTheme.darkTheme;
      case ThemeType.glassMorphism:
        return AppTheme.glassMorphismTheme;
      case ThemeType.musike:
        return AppTheme.musikeTheme;
      default:
        return AppTheme.musikeTheme;
    }
  }

  /// 检查是否为毛玻璃主题
  bool isGlassMorphismTheme() {
    return themeType.value == ThemeType.glassMorphism;
  }

  /// 检查是否为 Musike 主题
  bool isMusikeTheme() {
    return themeType.value == ThemeType.musike;
  }
}
