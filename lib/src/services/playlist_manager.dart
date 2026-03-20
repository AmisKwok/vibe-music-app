import 'dart:convert';
import 'package:amis_flutter_utils/utils.dart';
import 'package:vibe_music_app/src/models/song_model.dart';
import 'package:vibe_music_app/src/models/enums.dart';

/// 播放列表管理器
/// 负责处理播放列表的所有操作，包括添加、移除、保存和加载
class PlaylistManager {
  /// 播放列表
  List<Song> _playlist = [];

  /// 当前播放索引
  int _currentIndex = 0;

  /// 随机播放模式
  bool _isShuffle = false;

  /// 重复模式
  RepeatMode _repeatMode = RepeatMode.none;

  /// 单例实例
  static final PlaylistManager _instance = PlaylistManager._internal();

  /// 获取单例实例
  factory PlaylistManager() => _instance;

  /// 私有构造函数
  PlaylistManager._internal();

  /// 获取器
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    if (value >= 0 && value < _playlist.length) {
      _currentIndex = value;
    }
  }

  Song? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;
  bool get isShuffle => _isShuffle;
  RepeatMode get repeatMode => _repeatMode;

  /// 添加歌曲到播放列表
  /// [song] 要添加的歌曲
  Future<void> addToPlaylist(Song song) async {
    _playlist.add(song);
    await savePlaylist();
    AppLogger().d('✅ 添加歌曲到播放列表: ${song.songName}');
  }

  /// 从播放列表移除歌曲
  /// [index] 要移除的歌曲索引
  Future<void> removeFromPlaylist(int index) async {
    if (index >= 0 && index < _playlist.length) {
      final removedSong = _playlist[index];
      _playlist.removeAt(index);
      if (index < _currentIndex) {
        _currentIndex--;
      } else if (index == _currentIndex && _currentIndex >= _playlist.length) {
        _currentIndex = _playlist.length - 1;
      }
      // 保存播放列表
      await savePlaylist();
      AppLogger().d('✅ 从播放列表移除歌曲: ${removedSong.songName}');
    }
  }

  /// 清空播放列表
  Future<void> clearPlaylist() async {
    _playlist.clear();
    _currentIndex = 0;
    await savePlaylist();
    AppLogger().d('✅ 清空播放列表');
  }

  /// 设置新的播放列表
  /// [newPlaylist] 新的播放列表
  /// [currentSong] 当前播放的歌曲
  Future<void> setPlaylist(List<Song> newPlaylist, {Song? currentSong}) async {
    _playlist = newPlaylist;
    if (currentSong != null) {
      _currentIndex = _findSongIndex(currentSong, _playlist);
    } else {
      _currentIndex = 0;
    }
    await savePlaylist();
    AppLogger().d('✅ 设置新的播放列表，共 ${_playlist.length} 首歌曲');
  }

  /// 从播放列表中查找歌曲索引
  int _findSongIndex(Song song, List<Song> playlist) {
    // 首先尝试通过 songUrl 查找歌曲
    var index = playlist.indexWhere((s) => s.songUrl == song.songUrl);

    // 如果找不到，尝试通过 songName 和 artistName 查找
    if (index < 0) {
      index = playlist.indexWhere((s) =>
          s.songName == song.songName && s.artistName == song.artistName);
    }

    // 如果还是找不到，使用第一个歌曲
    if (index < 0) {
      index = 0;
    }

    return index;
  }

  /// 加载播放列表
  Future<void> loadPlaylist() async {
    try {
      AppLogger().d('🔄 开始加载播放列表');
      AppLogger().d('当前播放列表长度: ${_playlist.length}');

      // 从 SharedPreferences 加载
      AppLogger().d('💾 尝试从 SharedPreferences 加载播放列表');
      final playlistJson = SpUtil.get<String>('playlist');
      AppLogger().d('从 SharedPreferences 获取到的播放列表数据: $playlistJson');
      if (playlistJson != null) {
        try {
          final List<dynamic> jsonList = jsonDecode(playlistJson);
          AppLogger().d('从 SharedPreferences 解析到 ${jsonList.length} 首歌曲');
          _playlist.clear();
          for (final item in jsonList) {
            final song = Song.fromJson(item);
            // 只添加有效的歌曲（songUrl 不为空）
            if (song.songUrl != null && song.songUrl!.isNotEmpty) {
              _playlist.add(song);
              AppLogger().d('添加歌曲到播放列表: ${song.songName}');
            } else {
              AppLogger().w('跳过无效歌曲（songUrl 为空）: ${song.songName}');
            }
          }
          AppLogger()
              .d('✅ 从 SharedPreferences 加载播放列表成功，共 ${_playlist.length} 首有效歌曲');
          return;
        } catch (jsonError) {
          AppLogger().e('⚠️  解析 SharedPreferences 播放列表数据失败: $jsonError');
        }
      }

      // 如果所有存储都没有播放列表数据，记录日志
      if (_playlist.isEmpty) {
        AppLogger().d('⚠️  所有存储都没有播放列表数据，播放列表为空');
      } else {
        AppLogger().d('✅ 播放列表加载完成，共 ${_playlist.length} 首歌曲');
      }
    } catch (e) {
      AppLogger().e('❌ 加载播放列表失败: $e');
    }
  }

  /// 保存播放列表
  Future<void> savePlaylist() async {
    AppLogger().d('🔄 开始保存播放列表');
    AppLogger().d('当前播放列表长度: ${_playlist.length}');

    for (int i = 0; i < _playlist.length; i++) {
      final song = _playlist[i];
      AppLogger().d('要保存的歌曲 $i: ${song.songName} - ${song.artistName}');
    }

    // 保存到 SharedPreferences
    try {
      final playlistJson =
          jsonEncode(_playlist.map((song) => song.toJson()).toList());
      AppLogger().d('💾 尝试保存播放列表到 SharedPreferences');
      AppLogger().d('要保存到 SharedPreferences 的数据长度: ${playlistJson.length}');
      AppLogger().d('要保存到 SharedPreferences 的数据: $playlistJson');

      final success = await SpUtil.put('playlist', playlistJson);
      AppLogger().d('保存到 SharedPreferences 结果: $success');
      AppLogger().d('✅ 保存播放列表到 SharedPreferences 成功，共 ${_playlist.length} 首歌曲');
    } catch (e) {
      AppLogger().e('❌ 保存播放列表到 SharedPreferences 失败: $e');
    }

    AppLogger().d('✅ 播放列表保存完成');
  }

  /// 保存播放历史
  Future<void> savePlayHistory(Song song) async {
    // 保存到 SharedPreferences
    try {
      final lastPlayedSongJson = jsonEncode(song.toJson());
      await SpUtil.put('lastPlayedSong', lastPlayedSongJson);
      AppLogger().d('✅ 保存播放历史到 SharedPreferences 成功: ${song.songName}');
    } catch (e) {
      AppLogger().e('❌ 保存播放历史到 SharedPreferences 失败: $e');
    }
  }

  /// 加载最后播放的歌曲
  Future<Song?> loadLastPlayedSong() async {
    try {
      // 从 SharedPreferences 加载
      final lastPlayedSongJson = SpUtil.get<String>('lastPlayedSong');
      if (lastPlayedSongJson != null) {
        try {
          final Map<String, dynamic> json = jsonDecode(lastPlayedSongJson);
          AppLogger().d('✅ 从 SharedPreferences 加载最后播放歌曲成功');
          return Song.fromJson(json);
        } catch (jsonError) {
          AppLogger().e('⚠️  解析 SharedPreferences 最后播放歌曲数据失败: $jsonError');
        }
      }
      return null;
    } catch (e) {
      AppLogger().e('❌ 加载最后播放歌曲失败: $e');
      return null;
    }
  }

  /// 下一首播放
  void insertNextToPlay(Song song) {
    try {
      if (_currentIndex < _playlist.length - 1) {
        // 在当前歌曲后插入
        _playlist.insert(_currentIndex + 1, song);
      } else {
        // 在列表末尾添加
        _playlist.add(song);
      }
      // 保存播放列表
      savePlaylist();
      AppLogger().d('✅ 插入下一首播放: ${song.songName}');
    } catch (e) {
      AppLogger().e('❌ 插入下一首播放失败: $e');
    }
  }

  /// 播放下一首歌曲
  Future<void> next() async {
    if (_playlist.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
      await savePlaylist();
      AppLogger().d('✅ 播放下一首歌曲: ${_playlist[_currentIndex].songName}');
    }
  }

  /// 播放上一首歌曲
  Future<void> previous() async {
    if (_playlist.isNotEmpty) {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await savePlaylist();
      AppLogger().d('✅ 播放上一首歌曲: ${_playlist[_currentIndex].songName}');
    }
  }

  /// 设置当前播放索引
  /// [index] 要设置的索引
  Future<void> setCurrentIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await savePlaylist();
      AppLogger().d('✅ 设置当前播放索引: $index, 歌曲: ${_playlist[index].songName}');
    }
  }

  /// 清空播放列表并添加新列表
  /// [songs] 要添加的歌曲列表
  Future<void> replacePlaylist(List<Song> songs) async {
    _playlist = songs;
    _currentIndex = 0;
    await savePlaylist();
    AppLogger().d('✅ 替换播放列表，共 ${songs.length} 首歌曲');
  }

  /// 更新播放列表
  /// [newPlaylist] 新的播放列表
  Future<void> updatePlaylist(List<Song> newPlaylist) async {
    _playlist = newPlaylist;
    await savePlaylist();
    AppLogger().d('✅ 更新播放列表，共 ${newPlaylist.length} 首歌曲');
  }

  /// 设置当前播放歌曲
  /// [song] 要设置的歌曲
  Future<void> setCurrentSong(Song song) async {
    final index = findSongIndex(song, _playlist);
    if (index >= 0) {
      _currentIndex = index;
      await savePlaylist();
      AppLogger().d('✅ 设置当前播放歌曲: ${song.songName}');
    }
  }

  /// 获取下一首歌曲
  Song? getNextSong() {
    if (_playlist.isEmpty) return null;

    if (_isShuffle) {
      // 随机播放
      _currentIndex =
          (_playlist.length * DateTime.now().millisecondsSinceEpoch).abs() %
              _playlist.length;
    } else {
      // 顺序播放
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    }

    return _playlist[_currentIndex];
  }

  /// 获取上一首歌曲
  Song? getPreviousSong() {
    if (_playlist.isEmpty) return null;

    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    return _playlist[_currentIndex];
  }

  /// 从播放列表中查找歌曲索引
  /// [song] 要查找的歌曲
  /// [playlist] 播放列表
  int findSongIndex(Song song, List<Song> playlist) {
    // 首先尝试通过 songUrl 查找歌曲
    var index = playlist.indexWhere((s) => s.songUrl == song.songUrl);

    // 如果找不到，尝试通过 songName 和 artistName 查找
    if (index < 0) {
      index = playlist.indexWhere((s) =>
          s.songName == song.songName && s.artistName == song.artistName);
    }

    // 如果还是找不到，使用第一个歌曲
    if (index < 0) {
      index = 0;
    }

    return index;
  }

  /// 切换随机播放模式
  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    AppLogger().d('✅ 切换随机播放模式: $_isShuffle');
  }

  /// 切换重复模式
  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.none:
        // 切换到全部循环
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        // 切换到单曲循环
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        // 切换到不循环
        _repeatMode = RepeatMode.none;
        break;
    }
    AppLogger().d('✅ 切换重复模式: $_repeatMode');
  }
}
