import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 应用主题配置类
/// 定义了应用的明/暗两种主题样式
class AppTheme {
  /// Musike 主题配色常量
  static const Color musikeBackground = Color.fromARGB(255, 238, 232, 222);
  static const Color musikeCardBackground = Color(0xFFFCF9F3);
  static const Color musikeTextPrimary = Color(0xFF1F2937);
  static const Color musikeTextSecondary = Color(0xFF6B7280);
  static const Color musikeAccent = Color(0xFF6366F1);
  static const Color musikeAccentLight = Color(0xFF818CF8);

  /// 亮色主题（粉紫色调）
  static final ThemeData lightTheme = ThemeData(
    /// 亮色主题颜色方案
    colorScheme: ColorScheme.light(
      primary: const Color(0xFFFA709A), // 主色调（粉紫色）
      secondary: const Color(0xFFB19CD9), // 次要色调（淡紫色）
      surface: Colors.white, // 表面色
      error: Colors.red.shade600, // 错误色
      onPrimary: Colors.white, // 主色调上的文字颜色
      onSecondary: Colors.white, // 次要色调上的文字颜色
      onSurface: const Color(0xFF8B008B), // 表面色上的文字颜色（深粉紫色）
      onError: Colors.white, // 错误色上的文字颜色
      brightness: Brightness.light, // 亮度
    ),
    useMaterial3: true, // 使用Material3设计
    scaffoldBackgroundColor: const Color(0xFFF8F0F8), // 脚手架背景色（浅粉紫色）
    /// 卡片主题
    cardTheme: CardThemeData(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // 圆角
      elevation: 3, // 阴影高度
      color: Colors.white, // 卡片颜色
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // 卡片边距
    ),

    /// 文字主题
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        // 大标题
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: const Color(0xFF8B008B),
      ),
      headlineMedium: TextStyle(
        // 中标题
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: const Color(0xFF8B008B),
      ),
      titleMedium: TextStyle(
        // 小标题
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: const Color(0xFF8B008B),
      ),
      bodyMedium: TextStyle(
        // 中等正文
        fontSize: 16,
        color: const Color(0xFFC71585),
      ),
      bodySmall: TextStyle(
        // 小正文
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    ),

    /// 导航栏主题
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: const Color(0xFFFA709A).withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Color(0xFF8B008B),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(
          color: Color(0xFF8B008B),
        ),
      ),
    ),
  );

  /// 暗色主题（粉紫色调自适应）
  static final ThemeData darkTheme = ThemeData(
    /// 暗色主题颜色方案
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF9370DB), // 主色调（深粉紫色）
      secondary: const Color(0xFFBA55D3), // 次要色调（粉紫色）
      surface: const Color(0xFF2D1B35), // 表面色（深紫粉色调）
      error: Colors.red.shade400, // 错误色
      onPrimary: Colors.white, // 主色调上的文字颜色
      onSecondary: Colors.white, // 次要色调上的文字颜色
      onSurface: Colors.grey.shade100, // 表面色上的文字颜色
      onError: Colors.white, // 错误色上的文字颜色
      brightness: Brightness.dark, // 亮度
    ),
    useMaterial3: true, // 使用Material3设计
    scaffoldBackgroundColor: const Color(0xFF1A102C), // 脚手架背景色（深紫色）
    /// 卡片主题
    cardTheme: CardThemeData(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // 圆角
      elevation: 3, // 阴影高度
      color: const Color(0xFF2D1B35), // 卡片颜色（深紫粉色调）
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // 卡片边距
    ),

    /// 文字主题
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        // 大标题
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        // 中标题
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        // 小标题
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        // 中等正文
        fontSize: 16,
        color: const Color(0xFFE6E6FA),
      ),
      bodySmall: TextStyle(
        // 小正文
        fontSize: 14,
        color: const Color(0xFFDDA0DD),
      ),
    ),

    /// 导航栏主题
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: const Color(0xFF9370DB).withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(
          color: Colors.white,
        ),
      ),
    ),
  );

  /// 全局模糊毛玻璃主题（带渐变底色）
  static final ThemeData glassMorphismTheme = ThemeData(
    /// 毛玻璃主题颜色方案
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF6366F1), // 靛蓝色
      secondary: const Color(0xFFEC4899), // 粉红色
      surface: Colors.black.withOpacity(0.2),
      error: Colors.red.shade400,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.white.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(
          color: Colors.white,
        ),
      ),
    ),
  );

  /// Musike 主题（参考 Figma 设计）
  static final ThemeData musikeTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: musikeAccent,
      secondary: musikeAccentLight,
      surface: musikeCardBackground,
      error: Colors.red.shade600,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: musikeTextPrimary,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: musikeBackground,
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: musikeCardBackground,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: musikeTextPrimary,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: musikeTextPrimary,
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: musikeTextPrimary,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: musikeTextSecondary,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: musikeTextSecondary,
        fontFamily: 'Poppins',
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: musikeAccent.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(
          color: musikeTextPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      iconTheme: WidgetStateProperty.all(
        IconThemeData(
          color: musikeTextPrimary,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: musikeTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      iconTheme: IconThemeData(color: musikeTextPrimary),
    ),
  );
}
