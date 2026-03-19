import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_model.freezed.dart';

@freezed
class PlaylistModel with _$PlaylistModel {
  const factory PlaylistModel({
    int? playlistId,
    String? title,
    String? coverUrl,
  }) = _PlaylistModel;

  const PlaylistModel._();

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      playlistId: json['playlistId'],
      title: json['title']?.toString().trim(),
      coverUrl: json['coverUrl']?.toString().trim().replaceAll('`', ''),
    );
  }
}
