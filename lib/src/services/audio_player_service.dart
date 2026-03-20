import 'dart:async';
import 'package:amis_flutter_utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:vibe_music_app/src/models/song_model.dart';
import 'package:vibe_music_app/src/models/enums.dart';

// 桌面端使用 audioplayers
import 'package:audioplayers/audioplayers.dart' as audioplayers;

/// 音频播放器服务
/// 负责处理音频播放相关的所有功能
class AudioPlayerService {
  /// 音频播放器实例（非桌面端使用）
  AudioPlayer? _audioPlayer;

  /// 桌面端音频播放器实例
  audioplayers.AudioPlayer? _desktopAudioPlayer;

  /// 当前播放器状态
  AppPlayerState _playerState = AppPlayerState.stopped;

  /// 当前音频时长
  Duration _duration = Duration.zero;

  /// 当前播放位置
  Duration _position = Duration.zero;

  /// 音量大小（默认50%）
  double _volume = 0.5; // 默认音量设置为50%

  /// 音频会话
  AudioSession? _audioSession; // 音频会话，用于获取和监听系统音量

  /// 重复模式
  RepeatMode _repeatMode = RepeatMode.none;

  /// 随机播放模式
  bool _isShuffle = false;

  /// 播放列表
  List<Song> _playlist = [];

  /// 当前播放索引
  int _currentIndex = 0;

  /// 用于频繁变化数据的流控制器
  final _positionStreamController = StreamController<Duration>.broadcast();
  final _durationStreamController = StreamController<Duration>.broadcast();
  final _playerStateStreamController =
      StreamController<AppPlayerState>.broadcast();
  final _volumeStreamController = StreamController<double>.broadcast();
  final _currentIndexStreamController = StreamController<int>.broadcast();

  // 防抖定时器
  Timer? _stateDebounceTimer;
  AppPlayerState? _pendingState;

  /// 单例实例
  static final AudioPlayerService _instance = AudioPlayerService._internal();

  /// 获取单例实例
  factory AudioPlayerService() => _instance;

  /// 私有构造函数
  AudioPlayerService._internal();

  /// 流获取器
  Stream<Duration> get positionStream => _positionStreamController.stream;
  Stream<Duration> get durationStream => _durationStreamController.stream;
  Stream<AppPlayerState> get playerStateStream =>
      _playerStateStreamController.stream;
  Stream<double> get volumeStream => _volumeStreamController.stream;
  Stream<int> get currentIndexStream => _currentIndexStreamController.stream;

  /// 获取器
  AppPlayerState get playerState => _playerState;
  Duration get duration => _duration;
  Duration get position => _position;
  double get volume => _volume;
  RepeatMode get repeatMode => _repeatMode;
  bool get isShuffle => _isShuffle;

  /// 检查是否为桌面端平台（不包括web）
  bool get _isDesktop {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux);
  }

  /// 初始化音频播放器
  Future<void> initialize() async {
    try {
      // 检查是否为桌面端平台（不包括web）
      final isDesktop = _isDesktop;
      AppLogger().d(
          '音频播放器初始化平台检测: isDesktop=$isDesktop, kIsWeb=$kIsWeb, defaultTargetPlatform=$defaultTargetPlatform');

      if (!isDesktop) {
        // 非桌面端平台（移动端和web），初始化 just_audio 播放器
        await _initAudioPlayer();
      } else {
        // 桌面端平台，初始化 audioplayers 播放器
        await _initDesktopAudioPlayer();
      }

      // 加载保存的音量设置
      try {
        final savedVolume = SpUtil.get<double>('volume');
        if (savedVolume != null) {
          _volume = savedVolume;
          // 设置播放器音量
          if (!isDesktop && _audioPlayer != null) {
            _audioPlayer!.setVolume(_volume);
          } else if (isDesktop && _desktopAudioPlayer != null) {
            await _desktopAudioPlayer!.setVolume(_volume);
          }
          _volumeStreamController.add(_volume);
        }
      } catch (e) {
        AppLogger().e('加载音量设置失败: $e');
      }

      AppLogger().d('✅ 音频播放器初始化完成');
    } catch (e) {
      AppLogger().e('❌ 音频播放器初始化失败: $e');
    }
  }

  /// 初始化桌面端音频播放器
  Future<void> _initDesktopAudioPlayer() async {
    try {
      // 初始化 audioplayers 播放器
      _desktopAudioPlayer = audioplayers.AudioPlayer();
      AppLogger().d('✅ 桌面端音频播放器初始化成功');

      // 监听播放状态
      _desktopAudioPlayer?.onPlayerStateChanged.listen((state) {
        AppPlayerState newState;
        switch (state) {
          case audioplayers.PlayerState.stopped:
            newState = AppPlayerState.stopped;
            break;
          case audioplayers.PlayerState.playing:
            newState = AppPlayerState.playing;
            break;
          case audioplayers.PlayerState.paused:
            newState = AppPlayerState.paused;
            break;
          default:
            newState = AppPlayerState.loading;
            break;
        }

        if (_playerState != newState) {
          _playerState = newState;
          _playerStateStreamController.add(newState);
        }
      });

      // 监听播放位置
      _desktopAudioPlayer?.onPositionChanged.listen((position) {
        _position = position;
        _positionStreamController.add(position);
      });

      // 监听音频时长
      _desktopAudioPlayer?.onDurationChanged.listen((duration) {
        _duration = duration;
        _durationStreamController.add(duration);
      });
    } catch (e) {
      AppLogger().e('❌ 桌面端音频播放器初始化失败: $e');
    }
  }

  /// 初始化音频播放器
  Future<void> _initAudioPlayer() async {
    // 创建 just_audio 播放器实例
    _audioPlayer = AudioPlayer();

    // 初始化音频会话
    _audioSession = await AudioSession.instance;
    await _audioSession!.configure(const AudioSessionConfiguration.music());

    // 注意：audio_session 0.2.x 版本的方法名可能不同，这里使用兼容的方式
    // 当用户调整系统音量时，音频会话会自动更新播放器音量
    // 设置初始音量
    _audioPlayer!.setVolume(_volume);

    // 监听音频时长变化
    _audioPlayer!.durationStream.listen((d) {
      AppLogger().d('durationStream 收到数据: $d');
      // 只更新有效的时长（不为 null 且大于 0）
      if (d != null && d > Duration.zero) {
        _duration = d;
        AppLogger().d('更新时长为: ${d.inMinutes}:${d.inSeconds % 60}');
        _durationStreamController.add(d);
      }
    });

    // 监听播放位置变化 - 使用流而不是 notifyListeners
    _audioPlayer!.positionStream.listen((p) {
      _position = p;
      _positionStreamController.add(p);
    });

    // 监听播放器状态变化
    _audioPlayer!.playerStateStream.listen((state) {
      AppLogger().d(
          '播放器状态变化: processingState=${state.processingState}, playing=${state.playing}');
      AppPlayerState newState;
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
          newState = AppPlayerState.loading;
          break;
        case ProcessingState.buffering:
          newState = AppPlayerState.loading;
          break;
        case ProcessingState.ready:
          newState =
              state.playing ? AppPlayerState.playing : AppPlayerState.paused;
          break;
        case ProcessingState.completed:
          AppLogger().d('歌曲播放完成，hasNext=${_audioPlayer!.hasNext}');
          if (_playlist.isEmpty || !_audioPlayer!.hasNext) {
            AppLogger().d('播放列表已结束');
            _playerState = AppPlayerState.completed;
            _playerStateStreamController.add(_playerState);
          }
          return;
      }

      // 如果状态相同，忽略
      if (_playerState == newState && _pendingState == null) return;

      // 保存待处理状态
      _pendingState = newState;

      // 取消之前的定时器
      _stateDebounceTimer?.cancel();

      // 使用防抖，等待50ms后确认状态
      _stateDebounceTimer = Timer(const Duration(milliseconds: 50), () {
        if (_pendingState != null && _playerState != _pendingState) {
          _playerState = _pendingState!;
          _playerStateStreamController.add(_playerState);
        }
        _pendingState = null;
      });
    });

    // 监听当前播放索引变化（自动播放下一首时触发）
    _audioPlayer!.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex) {
        _currentIndex = index;
        AppLogger().d('当前播放索引变化: $index');
        if (_playlist.isNotEmpty && index < _playlist.length) {
          AppLogger().d('正在播放: ${_playlist[index].songName}');
        }
        // 通知索引变化，让 MusicController 更新 UI
        _currentIndexStreamController.add(index);
      }
    });

    AppLogger().d('✅ just_audio_background 已在 main.dart 中初始化');
  }

  /// 播放指定歌曲
  /// [song] 要播放的歌曲
  Future<void> playSong(Song song) async {
    // 检查songUrl是否存在
    if (song.songUrl == null || song.songUrl!.isEmpty) {
      _playerState = AppPlayerState.stopped;
      AppLogger().e('错误: 歌曲URL为空或不存在，歌曲名称: ${song.songName}');
      AppLogger().e('歌曲URL: ${song.songUrl}');
      return;
    }

    _playerState = AppPlayerState.loading;
    _playerStateStreamController.add(_playerState);

    // 检查是否为桌面端平台（不包括web）
    final isDesktop = _isDesktop;
    AppLogger().d(
        'playSong 平台检测: isDesktop=$isDesktop, kIsWeb=$kIsWeb, defaultTargetPlatform=$defaultTargetPlatform');

    try {
      if (!isDesktop) {
        // 非桌面端平台，使用 just_audio 播放器
        if (_audioPlayer == null) {
          throw Exception('音频播放器未初始化');
        }

        // 重置播放器
        await _audioPlayer!.stop();

        // 设置单个音频源（带元数据）
        AppLogger().d('使用 just_audio 准备从URL播放音频');
        final duration = await _audioPlayer!.setAudioSource(
          AudioSource.uri(
            Uri.parse(song.songUrl!),
            tag: MediaItem(
              id: song.id?.toString() ?? song.songUrl!,
              album: song.albumName,
              title: song.songName ?? '未知歌曲',
              artist: song.artistName ?? '未知艺术家',
              artUri: song.coverUrl != null ? Uri.parse(song.coverUrl!) : null,
            ),
          ),
        );

        // 播放歌曲
        await _audioPlayer!.play();
        _playerState = AppPlayerState.playing;
        _playerStateStreamController.add(_playerState);
        AppLogger().d('使用 just_audio 成功开始播放歌曲: ${song.songName}');

        // 更新时长
        if (duration != null && duration > Duration.zero) {
          _duration = duration;
          _durationStreamController.add(duration);
          AppLogger()
              .d('从音频源获取时长: ${duration.inMinutes}:${duration.inSeconds % 60}');
        } else {
          // 从歌曲模型解析时长
          _parseAndSetDuration(song.duration);
        }
      } else {
        // 桌面端平台，使用 audioplayers 播放器
        await _playSongWithAudioPlayers(song);
      }
    } catch (e, stackTrace) {
      AppLogger().e('播放歌曲 ${song.songName} 失败: $e');
      AppLogger().e('堆栈跟踪: $stackTrace');
      _playerState = AppPlayerState.stopped;
      _playerStateStreamController.add(_playerState);

      // 即使播放失败，也要设置时长，确保UI显示正常
      _parseAndSetDuration(song.duration);
    }
  }

  /// 使用 audioplayers 播放歌曲
  Future<void> _playSongWithAudioPlayers(Song song) async {
    if (_desktopAudioPlayer == null) {
      throw Exception('桌面端音频播放器未初始化');
    }

    // 重置播放器
    await _desktopAudioPlayer!.stop();
    // 设置音频源
    AppLogger().d('使用 audioplayers 准备从URL播放音频');
    await _desktopAudioPlayer!.setSourceUrl(song.songUrl!);
    // 播放歌曲
    await _desktopAudioPlayer!.resume();
    _playerState = AppPlayerState.playing;
    _playerStateStreamController.add(_playerState);
    AppLogger().d('使用 audioplayers 成功开始播放歌曲: ${song.songName}');
  }

  /// 播放当前歌曲
  Future<void> play() async {
    // 检查是否为桌面端平台（不包括web）
    final isDesktop = _isDesktop;

    try {
      if (!isDesktop) {
        // 非桌面端平台，使用 just_audio 播放器
        if (_audioPlayer == null) {
          throw Exception('音频播放器未初始化');
        }
        await _audioPlayer!.play();
        // just_audio 的 playerStateStream 会自动发送状态更新
        AppLogger().d('使用 just_audio 播放当前歌曲');
      } else {
        // 桌面端平台，使用 audioplayers 播放器
        if (_desktopAudioPlayer == null) {
          throw Exception('桌面端音频播放器未初始化');
        }
        await _desktopAudioPlayer!.resume();
        // 桌面端需要手动发送状态更新
        _playerState = AppPlayerState.playing;
        _playerStateStreamController.add(_playerState);
        AppLogger().d('使用 audioplayers 播放当前歌曲');
      }
    } catch (e) {
      AppLogger().e('播放歌曲失败: $e');
      _playerState = AppPlayerState.stopped;
      _playerStateStreamController.add(_playerState);
    }
  }

  /// 暂停当前歌曲
  Future<void> pause() async {
    // 检查是否为桌面端平台（不包括web）
    final isDesktop = _isDesktop;

    try {
      if (!isDesktop) {
        // 非桌面端平台，使用 just_audio 播放器
        if (_audioPlayer != null) {
          await _audioPlayer!.pause();
          // just_audio 的 playerStateStream 会自动发送状态更新
        }
      } else {
        // 桌面端平台，使用 audioplayers 播放器
        if (_desktopAudioPlayer != null) {
          await _desktopAudioPlayer!.pause();
          // 桌面端需要手动发送状态更新
          _playerState = AppPlayerState.paused;
          _playerStateStreamController.add(_playerState);
        }
      }
    } catch (e) {
      AppLogger().e('暂停播放失败: $e');
    }
  }

  /// 停止播放并清除通知栏
  Future<void> stop() async {
    AppLogger().d('停止播放并清除通知栏');
    // 检查是否为桌面端平台（不包括web）
    final isDesktop = _isDesktop;

    try {
      if (!isDesktop) {
        // 非桌面端平台，使用 just_audio 播放器
        if (_audioPlayer != null) {
          await _audioPlayer!.stop();
        }
      } else {
        // 桌面端平台，使用 audioplayers 播放器
        if (_desktopAudioPlayer != null) {
          await _desktopAudioPlayer!.stop();
        }
      }
      _playerState = AppPlayerState.stopped;
      _position = Duration.zero;
      _playerStateStreamController.add(_playerState);
    } catch (e) {
      AppLogger().e('停止播放失败: $e');
    }
  }

  /// 跳转到指定位置
  /// [position] 要跳转到的位置
  Future<void> seekTo(Duration position) async {
    // 检查是否为桌面端平台（不包括web）
    final isDesktop = _isDesktop;

    try {
      if (!isDesktop) {
        // 非桌面端平台，使用 just_audio 播放器
        if (_audioPlayer != null) {
          await _audioPlayer!.seek(position);
        }
      } else {
        // 桌面端平台，使用 audioplayers 播放器
        if (_desktopAudioPlayer != null) {
          await _desktopAudioPlayer!.seek(position);
        }
      }
    } catch (e) {
      AppLogger().e('跳转播放位置失败: $e');
    }
  }

  /// 切换随机播放模式
  void toggleShuffle() {
    _isShuffle = !_isShuffle;
  }

  /// 切换重复模式
  void toggleRepeat() {
    // 检查是否为桌面端平台（不包括web）
    final isDesktop = _isDesktop;

    switch (_repeatMode) {
      case RepeatMode.none:
        // 切换到全部循环
        _repeatMode = RepeatMode.all;
        if (!isDesktop && _audioPlayer != null) {
          _audioPlayer!.setLoopMode(LoopMode.all);
        }
        break;
      case RepeatMode.all:
        // 切换到单曲循环
        _repeatMode = RepeatMode.one;
        if (!isDesktop && _audioPlayer != null) {
          _audioPlayer!.setLoopMode(LoopMode.one);
        }
        break;
      case RepeatMode.one:
        // 切换到不循环
        _repeatMode = RepeatMode.none;
        if (!isDesktop && _audioPlayer != null) {
          _audioPlayer!.setLoopMode(LoopMode.off);
        }
        break;
    }
  }

  /// 设置音量
  /// [volume] 音量大小（0.0-1.0）
  Future<void> setVolume(double volume) async {
    // 检查是否为桌面端平台（不包括web）
    final isDesktop = _isDesktop;

    try {
      _volume = volume;
      if (!isDesktop) {
        // 非桌面端平台，使用 just_audio 播放器
        if (_audioPlayer != null) {
          _audioPlayer!.setVolume(volume);
        }
      } else {
        // 桌面端平台，使用 audioplayers 播放器
        if (_desktopAudioPlayer != null) {
          await _desktopAudioPlayer!.setVolume(volume);
        }
      }
      _volumeStreamController.add(volume);
      // 保存音量设置到缓存
      await SpUtil.put('volume', volume);
    } catch (e) {
      AppLogger().e('设置音量失败: $e');
    }
  }

  /// 准备音频播放器但不自动播放
  Future<void> preparePlayer(Song song) async {
    if (song.songUrl == null || song.songUrl!.isEmpty) return;

    try {
      final isDesktop = _isDesktop;

      if (!isDesktop) {
        // 非桌面端平台，使用 just_audio 播放器
        if (_audioPlayer != null) {
          // 重置播放器
          await _audioPlayer!.stop();
          // 设置音频源
          AppLogger().d('准备音频播放器，设置音频源: ${song.songUrl}');
          await _audioPlayer!.setUrl(song.songUrl!);
          // 不自动播放，保持暂停状态
          await _audioPlayer!.pause();
          _playerState = AppPlayerState.paused;
          _playerStateStreamController.add(_playerState);
        }
      } else {
        // 桌面端平台，使用 audioplayers 播放器
        if (_desktopAudioPlayer != null) {
          // 重置播放器
          await _desktopAudioPlayer!.stop();
          // 设置音频源
          AppLogger().d('准备桌面端音频播放器，设置音频源: ${song.songUrl}');
          await _desktopAudioPlayer!.setSourceUrl(song.songUrl!);
          // 不自动播放，保持暂停状态
          // audioplayers 在设置源后默认是暂停状态
          _playerState = AppPlayerState.paused;
          _playerStateStreamController.add(_playerState);
        }
      }
      AppLogger().d('✅ 音频播放器准备完成，状态: 暂停');
    } catch (e) {
      AppLogger().e('❌ 准备音频播放器失败: $e');
      _playerState = AppPlayerState.stopped;
      _playerStateStreamController.add(_playerState);
    }
  }

  /// 设置播放列表并播放指定歌曲
  /// [playlist] 播放列表
  /// [startIndex] 起始播放索引，默认为0
  Future<void> setPlaylist(List<Song> playlist, {int startIndex = 0}) async {
    if (playlist.isEmpty) return;

    _playlist = playlist;
    _currentIndex = startIndex.clamp(0, playlist.length - 1);

    // 检查是否为桌面端平台
    final isDesktop = _isDesktop;

    if (!isDesktop) {
      await _playPlaylistWithJustAudio(startIndex);
    } else {
      await playSong(playlist[startIndex]);
    }
  }

  /// 使用 just_audio 播放播放列表
  Future<void> _playPlaylistWithJustAudio(int startIndex) async {
    if (_audioPlayer == null || _playlist.isEmpty) {
      throw Exception('音频播放器未初始化或播放列表为空');
    }

    // 创建音频源列表
    final audioSources = _playlist.map((song) {
      return AudioSource.uri(
        Uri.parse(song.songUrl!),
        tag: MediaItem(
          id: song.id?.toString() ?? song.songUrl!,
          album: song.albumName,
          title: song.songName ?? '未知歌曲',
          artist: song.artistName ?? '未知艺术家',
          artUri: song.coverUrl != null ? Uri.parse(song.coverUrl!) : null,
        ),
      );
    }).toList();

    // 创建 ConcatenatingAudioSource 来支持上一首/下一首
    final concatenatingSource = ConcatenatingAudioSource(
      children: audioSources,
      useLazyPreparation: true,
    );

    AppLogger().d('播放列表大小: ${_playlist.length}, 起始索引: $startIndex');

    // 重置播放器
    await _audioPlayer!.stop();

    // 设置循环模式为全部循环，这样播放完一首后会自动播放下一首
    await _audioPlayer!.setLoopMode(LoopMode.all);
    AppLogger().d('已设置循环模式为: all');

    // 设置音频源并从指定索引开始播放
    AppLogger().d('设置播放列表，从索引 $startIndex 开始播放');
    await _audioPlayer!.setAudioSource(
      concatenatingSource,
      initialIndex: startIndex,
      initialPosition: Duration.zero,
    );

    AppLogger().d(
        '音频源设置完成，当前索引: ${_audioPlayer!.currentIndex}, hasNext: ${_audioPlayer!.hasNext}');

    // 播放歌曲
    await _audioPlayer!.play();
    _playerState = AppPlayerState.playing;
    _playerStateStreamController.add(_playerState);
    AppLogger().d('播放列表设置成功，当前歌曲: ${_playlist[startIndex].songName}');
  }

  /// 从字符串解析时长并设置
  void _parseAndSetDuration(String? durationStr) {
    if (durationStr == null || durationStr.isEmpty) {
      // 如果 duration 为空，设置一个默认值（3分钟）
      _duration = Duration(minutes: 3);
      _durationStreamController.add(_duration);
      AppLogger().d('歌曲 duration 为空，设置默认时长: 3:00');
      return;
    }

    final cleanDuration = durationStr.trim().replaceAll(' ', '');

    // 处理时:分:秒格式（如：1:02:03）
    final hhMmSsMatch =
        RegExp(r'^(\d+):(\d+):(\d+(\.\d+)?)$').firstMatch(cleanDuration);
    if (hhMmSsMatch != null) {
      final hours = int.tryParse(hhMmSsMatch.group(1) ?? '0') ?? 0;
      final minutes = int.tryParse(hhMmSsMatch.group(2) ?? '0') ?? 0;
      final seconds =
          double.tryParse(hhMmSsMatch.group(3) ?? '0')?.toInt() ?? 0;
      _duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
      _durationStreamController.add(_duration);
      AppLogger().d(
          '从歌曲模型解析时长: ${_duration.inHours}:${_duration.inMinutes % 60}:${_duration.inSeconds % 60}');
      return;
    }

    // 处理分:秒格式（如：2:03, 12:34）
    final mmSsMatch =
        RegExp(r'^(\d+):(\d+(\.\d+)?)$').firstMatch(cleanDuration);
    if (mmSsMatch != null) {
      final minutes = int.tryParse(mmSsMatch.group(1) ?? '0') ?? 0;
      final seconds = double.tryParse(mmSsMatch.group(2) ?? '0')?.toInt() ?? 0;
      _duration = Duration(minutes: minutes, seconds: seconds);
      _durationStreamController.add(_duration);
      AppLogger()
          .d('从歌曲模型解析时长: ${_duration.inMinutes}:${_duration.inSeconds % 60}');
      return;
    }

    // 处理秒数格式（如：123, 123.45）
    if (RegExp(r'^\d+(\.\d+)?$').hasMatch(cleanDuration)) {
      final seconds = double.tryParse(cleanDuration)?.toInt() ?? 0;
      if (seconds > 0) {
        _duration = Duration(seconds: seconds);
        _durationStreamController.add(_duration);
        AppLogger()
            .d('从歌曲模型解析时长: ${_duration.inMinutes}:${_duration.inSeconds % 60}');
      } else {
        // 秒数为0，设置默认值
        _duration = Duration(minutes: 3);
        _durationStreamController.add(_duration);
        AppLogger().d('歌曲 duration 无效，设置默认时长: 3:00');
      }
      return;
    }

    // 格式不正确，设置默认值
    _duration = Duration(minutes: 3);
    _durationStreamController.add(_duration);
    AppLogger().d('歌曲 duration 格式不正确，设置默认时长: 3:00');
  }

  /// 播放上一首
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    // 检查是否为桌面端平台
    final isDesktop = _isDesktop;

    if (!isDesktop && _audioPlayer != null) {
      // 移动端：使用 just_audio 的 seekToPrevious
      if (_audioPlayer!.hasPrevious) {
        await _audioPlayer!.seekToPrevious();
        _currentIndex = _audioPlayer!.currentIndex ?? _currentIndex;
        AppLogger().d('播放上一首: ${_playlist[_currentIndex].songName}');
      }
    } else {
      // 桌面端或回退逻辑
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await playSong(_playlist[_currentIndex]);
    }
  }

  /// 设置播放列表但不播放
  /// [playlist] 播放列表
  /// [startIndex] 起始索引，默认为0
  Future<void> setPlaylistWithoutPlaying(List<Song> playlist,
      {int startIndex = 0}) async {
    if (playlist.isEmpty) return;

    _playlist = playlist;
    _currentIndex = startIndex.clamp(0, playlist.length - 1);

    // 检查是否为桌面端平台
    final isDesktop = _isDesktop;

    if (!isDesktop) {
      await _preparePlaylistWithJustAudio(startIndex);
    } else {
      // 桌面端准备播放器
      final song = playlist[startIndex];
      await preparePlayer(song);
    }
  }

  /// 使用 just_audio 准备播放列表但不播放
  Future<void> _preparePlaylistWithJustAudio(int startIndex) async {
    if (_audioPlayer == null || _playlist.isEmpty) {
      throw Exception('音频播放器未初始化或播放列表为空');
    }

    // 创建音频源列表
    final audioSources = _playlist.map((song) {
      return AudioSource.uri(
        Uri.parse(song.songUrl!),
        tag: MediaItem(
          id: song.id?.toString() ?? song.songUrl!,
          album: song.albumName,
          title: song.songName ?? '未知歌曲',
          artist: song.artistName ?? '未知艺术家',
          artUri: song.coverUrl != null ? Uri.parse(song.coverUrl!) : null,
        ),
      );
    }).toList();

    // 创建 ConcatenatingAudioSource 来支持上一首/下一首
    final concatenatingSource = ConcatenatingAudioSource(
      children: audioSources,
      useLazyPreparation: false, // 禁用懒加载，确保音频源完全加载
    );

    AppLogger().d('准备播放列表大小: ${_playlist.length}, 起始索引: $startIndex');

    // 重置播放器
    await _audioPlayer!.stop();

    // 设置循环模式为全部循环
    await _audioPlayer!.setLoopMode(LoopMode.all);

    // 设置音频源但不播放
    final duration = await _audioPlayer!.setAudioSource(
      concatenatingSource,
      initialIndex: startIndex,
      initialPosition: Duration.zero,
    );

    // 设置暂停状态
    await _audioPlayer!.pause();
    _playerState = AppPlayerState.paused;
    _playerStateStreamController.add(_playerState);

    // 如果 setAudioSource 返回了时长，使用它；否则从歌曲模型解析
    if (duration != null && duration > Duration.zero) {
      _duration = duration;
      _durationStreamController.add(duration);
      AppLogger()
          .d('从音频源获取时长: ${duration.inMinutes}:${duration.inSeconds % 60}');
    } else {
      // 解析当前歌曲时长
      final currentSong = _playlist[startIndex];
      _parseAndSetDuration(currentSong.duration);
    }

    AppLogger().d('播放列表准备完成（未播放），当前歌曲: ${_playlist[startIndex].songName}');
  }

  /// 播放下一首
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    // 检查是否为桌面端平台
    final isDesktop = _isDesktop;

    if (!isDesktop && _audioPlayer != null) {
      // 移动端：使用 just_audio 的 seekToNext
      if (_audioPlayer!.hasNext) {
        await _audioPlayer!.seekToNext();
        _currentIndex = _audioPlayer!.currentIndex ?? _currentIndex;
        AppLogger().d('播放下一首: ${_playlist[_currentIndex].songName}');
      }
    } else {
      // 桌面端或回退逻辑
      _currentIndex = (_currentIndex + 1) % _playlist.length;
      await playSong(_playlist[_currentIndex]);
    }
  }

  /// 释放资源
  void dispose() {
    // 取消防抖定时器
    _stateDebounceTimer?.cancel();
    // 释放音频播放器资源
    if (_audioPlayer != null) {
      _audioPlayer!.dispose();
    }
    // 释放桌面端音频播放器资源
    if (_desktopAudioPlayer != null) {
      _desktopAudioPlayer!.dispose();
    }
    _positionStreamController.close();
    _durationStreamController.close();
    _playerStateStreamController.close();
    _volumeStreamController.close();
    _currentIndexStreamController.close();
  }
}
