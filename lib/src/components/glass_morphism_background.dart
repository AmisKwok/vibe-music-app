import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_music_app/src/controllers/theme_controller.dart';
import 'package:vibe_music_app/src/theme/app_theme.dart';

/// 毛玻璃背景组件
/// 用于在毛玻璃主题时显示渐变背景
class GlassMorphismBackground extends StatelessWidget {
  final Widget child;

  const GlassMorphismBackground({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isGlassMorphism = themeController.isGlassMorphismTheme();
    final isMusikeTheme = themeController.isMusikeTheme();

    if (isGlassMorphism) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: child,
      );
    }

    if (isMusikeTheme) {
      return Container(
        color: AppTheme.musikeBackground,
        child: child,
      );
    }

    return child;
  }
}

/// 带有透明背景的Scaffold，用于毛玻璃主题
class GlassMorphismScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;

  const GlassMorphismScaffold({Key? key, this.appBar, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isGlassMorphism = themeController.isGlassMorphismTheme();

    return GlassMorphismBackground(
      child: Scaffold(
        backgroundColor: isGlassMorphism ? Colors.transparent : null,
        appBar: appBar != null
            ? (appBar is PreferredSizeWidget
                ? appBar as PreferredSizeWidget
                : null)
            : null,
        body: body,
      ),
    );
  }
}
