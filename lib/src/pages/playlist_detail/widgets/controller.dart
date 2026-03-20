import 'package:amis_flutter_utils/utils.dart';
import 'package:get/get.dart';
import 'package:vibe_music_app/src/controllers/music_controller.dart';
import 'package:vibe_music_app/src/models/playlist_detail_model.dart';
import 'package:vibe_music_app/src/models/song_model.dart';
import 'package:vibe_music_app/src/pages/home/widgets/controller.dart';
import 'package:vibe_music_app/src/routes/app_routes.dart';
import 'package:vibe_music_app/src/services/api_service.dart';

class PlaylistDetailController extends GetxController {
  final int playlistId;

  PlaylistDetailController({required this.playlistId});

  final Rx<PlaylistDetailModel?> playlist = Rx<PlaylistDetailModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  List<Song> get songs => playlist.value?.songs ?? [];

  @override
  void onInit() {
    super.onInit();
    loadPlaylistDetail();
  }

  Future<void> loadPlaylistDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService().getPlaylistDetail(playlistId);

      if (response.statusCode == 200 && response.data['code'] == 200) {
        playlist.value = PlaylistDetailModel.fromJson(response.data['data']);
        AppLogger().d('歌单详情加载成功，歌曲数量: ${songs.length}');
      } else {
        errorMessage.value = response.data['message'] ?? '加载失败';
        AppLogger().e('歌单详情加载失败: ${response.data}');
      }
    } catch (e) {
      errorMessage.value = '网络错误，请稍后重试';
      AppLogger().e('加载歌单详情失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadPlaylistDetail();
  }

  Future<void> handleSongTap(int index) async {
    if (songs.isEmpty || index < 0 || index >= songs.length) return;

    final song = songs[index];
    AppLogger().d('点击歌曲: ${song.songName}');

    final musicController = Get.find<MusicController>();

    final newPlaylist = <Song>[];
    for (final s in songs) {
      if (!musicController.playlist.any((item) => item.songUrl == s.songUrl)) {
        newPlaylist.add(s);
      } else {
        final existingSong = musicController.playlist.firstWhere(
          (item) => item.songUrl == s.songUrl,
          orElse: () => s,
        );
        newPlaylist.add(existingSong);
      }
    }

    await musicController.playSong(song, playlist: newPlaylist);

    Get.back();

    try {
      final homeController = Get.find<HomeController>();
      homeController.changePage(1);
    } catch (e) {
      Get.toNamed(AppRoutes.player);
    }
  }

  Future<void> playAll() async {
    if (songs.isEmpty) return;

    AppLogger().d('播放全部歌曲');
    final musicController = Get.find<MusicController>();

    final newPlaylist = <Song>[];
    for (final s in songs) {
      if (!musicController.playlist.any((item) => item.songUrl == s.songUrl)) {
        newPlaylist.add(s);
      } else {
        final existingSong = musicController.playlist.firstWhere(
          (item) => item.songUrl == s.songUrl,
          orElse: () => s,
        );
        newPlaylist.add(existingSong);
      }
    }

    final firstSong = songs.first;
    await musicController.playSong(firstSong, playlist: newPlaylist);

    Get.back();

    try {
      final homeController = Get.find<HomeController>();
      homeController.changePage(1);
    } catch (e) {
      Get.toNamed(AppRoutes.player);
    }
  }

  void insertNextToPlay(int index) {
    if (songs.isEmpty || index < 0 || index >= songs.length) return;

    final song = songs[index];
    final musicController = Get.find<MusicController>();
    musicController.insertNextToPlay(song);

    Get.snackbar(
      '已添加到下一首播放',
      song.songName ?? '未知歌曲',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
