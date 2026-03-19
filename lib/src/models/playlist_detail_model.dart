import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vibe_music_app/src/models/song_model.dart';

part 'playlist_detail_model.freezed.dart';

@freezed
class PlaylistDetailModel with _$PlaylistDetailModel {
  const factory PlaylistDetailModel({
    int? playlistId,
    String? title,
    String? coverUrl,
    String? introduction,
    List<Song>? songs,
  }) = _PlaylistDetailModel;

  const PlaylistDetailModel._();

  factory PlaylistDetailModel.fromJson(Map<String, dynamic> json) {
    return PlaylistDetailModel(
      playlistId: json['playlistId'],
      title: json['title']?.toString().trim(),
      coverUrl: json['coverUrl']?.toString().trim().replaceAll('`', ''),
      introduction: json['introduction']?.toString().trim(),
      songs: json['songs'] != null
          ? (json['songs'] as List).map((item) => Song.fromJson(item)).toList()
          : [],
    );
  }
}
