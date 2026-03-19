import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_music_app/src/pages/playlist_detail/widgets/controller.dart';
import 'package:vibe_music_app/src/pages/playlist_detail/widgets/view.dart';

class PlaylistDetailPage extends StatelessWidget {
  final int playlistId;

  const PlaylistDetailPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlaylistDetailController>(
      init: PlaylistDetailController(playlistId: playlistId),
      builder: (controller) {
        return const PlaylistDetailView();
      },
    );
  }
}
