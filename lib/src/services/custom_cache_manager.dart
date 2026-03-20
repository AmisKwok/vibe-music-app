import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:amis_flutter_utils/utils.dart';

class CustomCacheManager {
  static const String key = 'libCachedImageData';

  // 自定义缓存管理器实例
  static CacheManager? _instance;

  static Future<void> initialize() async {
    try {
      // 确保缓存目录存在
      final dir = await getApplicationCacheDirectory();
      final cacheDir = Directory(p.join(dir.path, key));
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
        AppLogger().d('图片缓存目录创建成功');
      }

      // 初始化自定义缓存管理器
      _instance = CacheManager(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
          fileService: HttpFileService(),
        ),
      );

      AppLogger().d('图片缓存管理器初始化成功');
    } catch (e) {
      AppLogger().e('图片缓存管理器初始化失败: $e');
    }
  }

  /// 获取缓存管理器实例
  static CacheManager get instance {
    _instance ??= CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 200,
      ),
    );
    return _instance!;
  }

  static Future<void> _resetCacheDatabase() async {
    try {
      final dir = await getApplicationCacheDirectory();
      final dbPath = p.join(dir.path, '$key.db');

      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.delete();
        AppLogger().d('已删除损坏的缓存数据库');
      }

      final cacheDir = Directory(p.join(dir.path, key));
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        AppLogger().d('已清理缓存目录');
      }
    } catch (e) {
      AppLogger().e('重置缓存数据库失败: $e');
    }
  }

  static Future<void> clearAllCache() async {
    try {
      await DefaultCacheManager().emptyCache();
      await _resetCacheDatabase();
      AppLogger().d('已清理所有图片缓存');
    } catch (e) {
      AppLogger().e('清理图片缓存失败: $e');
    }
  }
}
