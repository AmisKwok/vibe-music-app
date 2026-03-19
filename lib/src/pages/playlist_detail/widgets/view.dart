import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vibe_music_app/generated/app_localizations.dart';
import 'package:vibe_music_app/src/controllers/auth_controller.dart';
import 'package:vibe_music_app/src/controllers/music_controller.dart';
import 'package:vibe_music_app/src/pages/playlist_detail/widgets/controller.dart';
import 'package:vibe_music_app/src/pages/home/components/currently_playing_bar.dart';
import 'package:vibe_music_app/src/routes/app_routes.dart';
import 'package:vibe_music_app/src/utils/snackbar_manager.dart';

class PlaylistDetailView extends GetView<PlaylistDetailController> {
  const PlaylistDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.playlist.value?.title ?? '歌单详情')),
        actions: [
          Obx(() {
            if (controller.songs.isEmpty) {
              return const SizedBox();
            }
            return IconButton(
              icon: const Icon(Icons.playlist_play),
              tooltip: '播放全部',
              onPressed: () => controller.playAll(),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refresh(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (controller.songs.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)?.noResults ?? '暂无歌曲'),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 106),
              itemCount: controller.songs.length,
              itemBuilder: (context, index) {
                final song = controller.songs[index];
                final coverUrl = song.coverUrl;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: coverUrl != null
                        ? CachedNetworkImageProvider(
                            coverUrl,
                            maxWidth: 100,
                            maxHeight: 100,
                            scale: 0.8,
                          )
                        : null,
                    child:
                        coverUrl == null ? const Icon(Icons.music_note) : null,
                  ),
                  title: Text(song.songName ?? '未知歌曲'),
                  subtitle: Text(
                    song.artistName ??
                        (AppLocalizations.of(context)?.artist ?? '未知艺术家'),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        final musicController = Get.find<MusicController>();
                        final isFavorited =
                            musicController.favoriteSongIds.contains(song.id);

                        return IconButton(
                          onPressed: () async {
                            final authController = Get.find<AuthController>();
                            final localizations = AppLocalizations.of(context);

                            if (!authController.isAuthenticated) {
                              Get.snackbar(
                                localizations?.tip ?? '提示',
                                localizations?.pleaseLogin ?? '请先登录',
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                                icon: Icon(Icons.info, color: Colors.white),
                                duration: const Duration(seconds: 2),
                              );
                              Get.toNamed(AppRoutes.login);
                              return;
                            }

                            bool success;
                            if (isFavorited) {
                              success = await musicController
                                  .removeFromFavorites(song);
                              if (success) {
                                SnackbarManager().showSnackbar(
                                  title: '成功',
                                  message: '已取消收藏',
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.white),
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            } else {
                              success =
                                  await musicController.addToFavorites(song);
                              if (success) {
                                SnackbarManager().showSnackbar(
                                  title: '成功',
                                  message: '已添加到收藏',
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.white),
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorited ? Colors.red : null,
                          ),
                        );
                      }),
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => controller.handleSongTap(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading:
                                          const Icon(Icons.queue_play_next),
                                      title: const Text('下一首播放'),
                                      onTap: () {
                                        controller.insertNextToPlay(index);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CurrentlyPlayingBar(),
            ),
          ],
        );
      }),
    );
  }
}
