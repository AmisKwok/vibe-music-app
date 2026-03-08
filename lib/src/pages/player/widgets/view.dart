import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_music_app/generated/app_localizations.dart';
import 'package:vibe_music_app/src/controllers/theme_controller.dart';
import 'package:vibe_music_app/src/pages/player/widgets/controller.dart';
import 'package:vibe_music_app/src/pages/player/components/player_cover_art.dart';
import 'package:vibe_music_app/src/pages/player/components/player_song_info.dart';
import 'package:vibe_music_app/src/pages/player/components/player_progress_bar.dart';
import 'package:vibe_music_app/src/pages/player/components/player_controls.dart';
import 'package:vibe_music_app/src/pages/player/components/player_playlist.dart';
import 'package:vibe_music_app/src/utils/glass_morphism/responsive_layout.dart';
import 'package:vibe_music_app/src/theme/app_theme.dart';
import 'dart:ui';

class PlayerView extends GetView<PlayerController> {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenSize.isDesktop(context);
    final themeController = Get.find<ThemeController>();
    final isMusikeTheme = themeController.isMusikeTheme();

    if (isMusikeTheme) {
      return _buildMusikePlayer(context);
    }

    return _buildDefaultPlayer(context, isDesktop);
  }

  Widget _buildMusikePlayer(BuildContext context) {
    final textColor = const Color(0xFF1F2937);
    final subTextColor = const Color(0xFF6B7280);

    return Stack(
      children: [
        Positioned.fill(
          child: Obx(() {
            final coverUrl = controller.currentSong?.coverUrl;
            if (coverUrl != null) {
              return Image.network(
                coverUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.musikeBackground,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.3),
                          const Color(0xFF818CF8).withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.3),
                    const Color(0xFF818CF8).withValues(alpha: 0.3),
                  ],
                ),
              ),
            );
          }),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context)?.nowPlaying ?? '正在播放',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
            actions: [
              Obx(() {
                final currentSong = controller.currentSong;
                final isFavorited = currentSong != null &&
                    controller.isSongFavorited(currentSong);
                final isLoading = currentSong?.id != null
                    ? controller.favoriteLoadingStates[currentSong!.id!] ??
                        false
                    : false;
                return IconButton(
                  onPressed: isLoading ? null : controller.toggleFavorite,
                  icon: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF6366F1),
                            ),
                          ),
                        )
                      : Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 24,
                          color: isFavorited
                              ? Colors.red
                              : const Color(0xFF6366F1),
                        ),
                );
              }),
              IconButton(
                icon: Icon(
                  Icons.queue_music,
                  color: const Color(0xFF6366F1),
                ),
                onPressed: controller.togglePlaylistExpanded,
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          Obx(() => PlayerCoverArt(
                                coverUrl: controller.currentSong?.coverUrl,
                              )),
                          const SizedBox(height: 32),
                          Obx(() => PlayerSongInfo(
                                songName: controller.currentSong?.songName,
                                artistName: controller.currentSong?.artistName,
                              )),
                          const SizedBox(height: 90),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: StreamBuilder<Duration>(
                              stream: controller.positionStream,
                              builder: (context, positionSnapshot) {
                                final position =
                                    positionSnapshot.data ?? Duration.zero;
                                final duration = controller.duration;
                                return PlayerProgressBar(
                                  position: position,
                                  duration: duration,
                                  onSeek: controller.seekTo,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Obx(() => PlayerControls(
                                isPlaying: controller.isPlaying,
                                isShuffle: controller.isShuffle,
                                repeatMode: controller.repeatMode,
                                volume: controller.volume,
                                onPlay: controller.play,
                                onPause: controller.pause,
                                onPrevious: controller.previous,
                                onNext: controller.next,
                                onToggleShuffle: controller.toggleShuffle,
                                onToggleRepeat: controller.toggleRepeat,
                                onToggleVolumeControls: controller.toggleMute,
                              )),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultPlayer(BuildContext context, bool isDesktop) {
    final mainContent = Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.nowPlaying ?? '正在播放'),
        automaticallyImplyLeading: false,
        actions: [
          Obx(() {
            final currentSong = controller.currentSong;
            final isFavorited =
                currentSong != null && controller.isSongFavorited(currentSong);
            final isLoading = currentSong?.id != null
                ? controller.favoriteLoadingStates[currentSong!.id!] ?? false
                : false;
            return IconButton(
              onPressed: isLoading ? null : controller.toggleFavorite,
              icon: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                      color: isFavorited
                          ? Colors.red
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
            );
          }),
          IconButton(
            icon: Icon(Icons.queue_music),
            onPressed: controller.togglePlaylistExpanded,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        controller.adjustVolume(details.delta.dy);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => PlayerCoverArt(
                                coverUrl: controller.currentSong?.coverUrl,
                              )),
                          const SizedBox(height: 40),
                          Obx(() => PlayerSongInfo(
                                songName: controller.currentSong?.songName,
                                artistName: controller.currentSong?.artistName,
                              )),
                          const SizedBox(height: 40),
                          StreamBuilder<Duration>(
                            stream: controller.positionStream,
                            builder: (context, positionSnapshot) {
                              final position =
                                  positionSnapshot.data ?? Duration.zero;
                              final duration = controller.duration;

                              return PlayerProgressBar(
                                position: position,
                                duration: duration,
                                onSeek: controller.seekTo,
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                          Obx(() => PlayerControls(
                                isPlaying: controller.isPlaying,
                                isShuffle: controller.isShuffle,
                                repeatMode: controller.repeatMode,
                                volume: controller.volume,
                                onPlay: controller.play,
                                onPause: controller.pause,
                                onPrevious: controller.previous,
                                onNext: controller.next,
                                onToggleShuffle: controller.toggleShuffle,
                                onToggleRepeat: controller.toggleRepeat,
                                onToggleVolumeControls: controller.toggleMute,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (isDesktop) {
      return Stack(
        children: [
          mainContent,
          _buildDesktopPlaylistPanel(context),
        ],
      );
    }

    return Stack(
      children: [
        mainContent,
        Obx(() => controller.isExpanded.value && controller.playlist.isNotEmpty
            ? Positioned.fill(
                child: GestureDetector(
                  onTap: controller.togglePlaylistExpanded,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              )
            : const SizedBox()),
        Obx(() => controller.isExpanded.value && controller.playlist.isNotEmpty
            ? PlayerPlaylist(
                playlist: controller.playlist,
                currentIndex: controller.currentIndex,
                onSongTap: controller.playSongAtIndex,
                onToggleFavorite: controller.handlePlaylistFavoriteToggle,
                isSongFavorited: controller.isSongFavorited,
                onRemoveSong: controller.removeFromPlaylist,
                onClearPlaylist: controller.clearPlaylist,
              )
            : const SizedBox()),
      ],
    );
  }

  Widget _buildDesktopPlaylistPanel(BuildContext context) {
    return Obx(() => AnimatedPositioned(
          right: controller.isExpanded.value ? 0 : -400,
          top: 0,
          bottom: 0,
          width: 400,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 20,
                  offset: Offset(-10, 0),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '播放列表',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete_sweep),
                            onPressed: controller.clearPlaylist,
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: controller.togglePlaylistExpanded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: controller.playlist.length,
                    itemBuilder: (context, index) {
                      final song = controller.playlist[index];
                      final isCurrentSong = controller.currentIndex == index &&
                          controller.currentSong?.id == song.id;
                      final isFavorited = controller.isSongFavorited(song);
                      final isLoading = song.id != null
                          ? controller.favoriteLoadingStates[song.id!] ?? false
                          : false;

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: song.coverUrl != null
                              ? Image.network(
                                  song.coverUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.music_note,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                        ),
                        title: Text(
                          song.songName ?? 'Unknown',
                          style: TextStyle(
                            color: isCurrentSong
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isCurrentSong
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.artistName ?? 'Unknown',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      isFavorited
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      color: isFavorited
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                    ),
                              onPressed: isLoading
                                  ? null
                                  : () => controller
                                      .handlePlaylistFavoriteToggle(song),
                              constraints: BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                size: 20,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () =>
                                  controller.removeFromPlaylist(index),
                              constraints: BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        onTap: () => controller.playSongAtIndex(index),
                        selected: isCurrentSong,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
