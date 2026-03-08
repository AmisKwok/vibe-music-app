import 'dart:ui';

/// Color 扩展方法
/// 提供便捷的颜色操作方法
extension ColorExtension on Color {
  /// 调整颜色的透明度
  /// [alpha]: 透明度值，范围 0.0-1.0
  Color withValues({double alpha = 1.0}) {
    return withAlpha((alpha * 255).toInt().clamp(0, 255));
  }
}
