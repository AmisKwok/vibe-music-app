import 'package:flutter/material.dart';
import 'package:vibe_music_app/generated/app_localizations.dart';
import 'package:vibe_music_app/src/models/song_model.dart';

/// 播放列表组件
/// 用于显示和管理当前播放列表
class PlayerPlaylist extends StatelessWidget {
  /// 播放列表
  final List<Song> playlist;

  /// 当前播放索引
  final int currentIndex;

  /// 点击歌曲回调
  final Function(int) onSongTap;

  /// 收藏状态回调
  final Function(Song) onToggleFavorite;

  /// 检查歌曲是否被收藏的函数
  final bool Function(Song) isSongFavorited;

  /// 删除歌曲回调
  final Function(int) onRemoveSong;

  /// 清空播放列表回调
  final Function()? onClearPlaylist;

  /// 关闭播放列表回调
  final VoidCallback? onClose;

  const PlayerPlaylist({
    Key? key,
    required this.playlist,
    required this.currentIndex,
    required this.onSongTap,
    required this.onToggleFavorite,
    required this.isSongFavorited,
    required this.onRemoveSong,
    this.onClearPlaylist,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFFFFBF5);

    return GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10 && onClose != null) {
            onClose!();
          }
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: onClose,
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 5 && onClose != null) {
                    onClose!();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withAlpha(128),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // 播放列表标题栏
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.queue_music_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)?.playlist ?? 'Playlist',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${playlist.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (onClearPlaylist != null && playlist.isNotEmpty)
                      TextButton.icon(
                        icon: Icon(
                          Icons.delete_sweep_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        label: Text(
                          'Clear',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        onPressed: onClearPlaylist,
                      ),
                  ],
                ),
              ),
              // 分隔线
              Divider(
                height: 1,
                thickness: 1,
                color:
                    Theme.of(context).colorScheme.outlineVariant.withAlpha(128),
              ),
              // 播放列表内容
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: false,
                  thickness: 4,
                  radius: const Radius.circular(2),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      final song = playlist[index];
                      final isCurrent = index == currentIndex;
                      final isFavorited = isSongFavorited(song);

                      return _SongListItem(
                        song: song,
                        index: index,
                        isCurrent: isCurrent,
                        isFavorited: isFavorited,
                        onSongTap: onSongTap,
                        onToggleFavorite: onToggleFavorite,
                        onRemoveSong: onRemoveSong,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

/// 歌曲列表项组件
class _SongListItem extends StatelessWidget {
  final Song song;
  final int index;
  final bool isCurrent;
  final bool isFavorited;
  final Function(int) onSongTap;
  final Function(Song) onToggleFavorite;
  final Function(int) onRemoveSong;

  const _SongListItem({
    required this.song,
    required this.index,
    required this.isCurrent,
    required this.isFavorited,
    required this.onSongTap,
    required this.onToggleFavorite,
    required this.onRemoveSong,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSongTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent
              ? Theme.of(context).colorScheme.primaryContainer.withAlpha(100)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant.withAlpha(64),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // 歌曲序号或播放图标
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: isCurrent
                  ? Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16,
                      ),
                    )
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // 歌曲封面
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: song.coverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        song.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.music_note_rounded,
                            size: 20,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.music_note_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
            ),
            const SizedBox(width: 12),
            // 歌曲信息
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.songName ?? 'Unknown',
                    style: TextStyle(
                      color: isCurrent
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artistName ?? 'Unknown Artist',
                    style: TextStyle(
                      color: isCurrent
                          ? Theme.of(context).colorScheme.primary.withAlpha(180)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 操作按钮
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorited
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorited
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () => onToggleFavorite(song),
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withAlpha(150),
                    size: 18,
                  ),
                  onPressed: () => onRemoveSong(index),
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
