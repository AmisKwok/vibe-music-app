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
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            controller.playlist.value?.title ?? localizations.playlistDetail)),
        actions: [
          Obx(() {
            if (controller.songs.isEmpty) {
              return const SizedBox();
            }
            return IconButton(
              icon: const Icon(Icons.playlist_play),
              tooltip: localizations.playAll,
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
                  child: Text(localizations.retry),
                ),
              ],
            ),
          );
        }

        if (controller.songs.isEmpty) {
          return Center(
            child: Text(localizations.noResults),
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
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: InkWell(
                    onTap: () => controller.handleSongTap(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                                ]
                              : [
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .shadowColor
                                .withAlpha(isDark ? 60 : 25),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(0, isDark ? 2 : 3),
                          ),
                          BoxShadow(
                            color: Theme.of(context)
                                .highlightColor
                                .withAlpha(isDark ? 20 : 40),
                            blurRadius: 0,
                            spreadRadius: 0,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withAlpha(180),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .shadowColor
                                      .withAlpha(40),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: coverUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: coverUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        child: Icon(
                                          Icons.music_note_rounded,
                                          size: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        child: Icon(
                                          Icons.music_note_rounded,
                                          size: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      child: Icon(
                                        Icons.music_note_rounded,
                                        size: 24,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.songName ?? localizations.unknownSong,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song.artistName ??
                                      localizations.unknownArtist,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() {
                                final musicController =
                                    Get.find<MusicController>();
                                final isFavorited = musicController
                                    .favoriteSongIds
                                    .contains(song.id);

                                return IconButton(
                                  onPressed: () async {
                                    final authController =
                                        Get.find<AuthController>();

                                    if (!authController.isAuthenticated) {
                                      Get.snackbar(
                                        localizations.tip,
                                        localizations.pleaseLogin,
                                        backgroundColor: Colors.blue,
                                        colorText: Colors.white,
                                        icon: Icon(Icons.info,
                                            color: Colors.white),
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
                                          title: localizations.success,
                                          message: localizations
                                              .removedFromFavoritesSuccess,
                                          icon: Icon(Icons.check_circle,
                                              color: Colors.white),
                                          duration: const Duration(seconds: 2),
                                        );
                                      }
                                    } else {
                                      success = await musicController
                                          .addToFavorites(song);
                                      if (success) {
                                        SnackbarManager().showSnackbar(
                                          title: localizations.success,
                                          message: localizations
                                              .addedToFavoritesSuccess,
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
                                    color: isFavorited
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                    size: 20,
                                  ),
                                  constraints: const BoxConstraints(
                                      minWidth: 36, minHeight: 36),
                                  padding: EdgeInsets.zero,
                                );
                              }),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: Icon(
                                  Icons.play_arrow_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                onPressed: () =>
                                    controller.handleSongTap(index),
                                constraints: const BoxConstraints(
                                    minWidth: 36, minHeight: 36),
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (context) => SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 12),
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withAlpha(128),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.queue_play_next_rounded),
                                            title: Text(localizations.playNext),
                                            onTap: () {
                                              controller
                                                  .insertNextToPlay(index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                constraints: const BoxConstraints(
                                    minWidth: 36, minHeight: 36),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
