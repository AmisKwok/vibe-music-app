// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlaylistDetailModel {
  int? get playlistId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get introduction => throw _privateConstructorUsedError;
  List<Song>? get songs => throw _privateConstructorUsedError;

  /// Create a copy of PlaylistDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaylistDetailModelCopyWith<PlaylistDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaylistDetailModelCopyWith<$Res> {
  factory $PlaylistDetailModelCopyWith(
          PlaylistDetailModel value, $Res Function(PlaylistDetailModel) then) =
      _$PlaylistDetailModelCopyWithImpl<$Res, PlaylistDetailModel>;
  @useResult
  $Res call(
      {int? playlistId,
      String? title,
      String? coverUrl,
      String? introduction,
      List<Song>? songs});
}

/// @nodoc
class _$PlaylistDetailModelCopyWithImpl<$Res, $Val extends PlaylistDetailModel>
    implements $PlaylistDetailModelCopyWith<$Res> {
  _$PlaylistDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaylistDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = freezed,
    Object? title = freezed,
    Object? coverUrl = freezed,
    Object? introduction = freezed,
    Object? songs = freezed,
  }) {
    return _then(_value.copyWith(
      playlistId: freezed == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
      songs: freezed == songs
          ? _value.songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<Song>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaylistDetailModelImplCopyWith<$Res>
    implements $PlaylistDetailModelCopyWith<$Res> {
  factory _$$PlaylistDetailModelImplCopyWith(_$PlaylistDetailModelImpl value,
          $Res Function(_$PlaylistDetailModelImpl) then) =
      __$$PlaylistDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? playlistId,
      String? title,
      String? coverUrl,
      String? introduction,
      List<Song>? songs});
}

/// @nodoc
class __$$PlaylistDetailModelImplCopyWithImpl<$Res>
    extends _$PlaylistDetailModelCopyWithImpl<$Res, _$PlaylistDetailModelImpl>
    implements _$$PlaylistDetailModelImplCopyWith<$Res> {
  __$$PlaylistDetailModelImplCopyWithImpl(_$PlaylistDetailModelImpl _value,
      $Res Function(_$PlaylistDetailModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaylistDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = freezed,
    Object? title = freezed,
    Object? coverUrl = freezed,
    Object? introduction = freezed,
    Object? songs = freezed,
  }) {
    return _then(_$PlaylistDetailModelImpl(
      playlistId: freezed == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
      songs: freezed == songs
          ? _value._songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<Song>?,
    ));
  }
}

/// @nodoc

class _$PlaylistDetailModelImpl extends _PlaylistDetailModel {
  const _$PlaylistDetailModelImpl(
      {this.playlistId,
      this.title,
      this.coverUrl,
      this.introduction,
      final List<Song>? songs})
      : _songs = songs,
        super._();

  @override
  final int? playlistId;
  @override
  final String? title;
  @override
  final String? coverUrl;
  @override
  final String? introduction;
  final List<Song>? _songs;
  @override
  List<Song>? get songs {
    final value = _songs;
    if (value == null) return null;
    if (_songs is EqualUnmodifiableListView) return _songs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PlaylistDetailModel(playlistId: $playlistId, title: $title, coverUrl: $coverUrl, introduction: $introduction, songs: $songs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaylistDetailModelImpl &&
            (identical(other.playlistId, playlistId) ||
                other.playlistId == playlistId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.introduction, introduction) ||
                other.introduction == introduction) &&
            const DeepCollectionEquality().equals(other._songs, _songs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playlistId, title, coverUrl,
      introduction, const DeepCollectionEquality().hash(_songs));

  /// Create a copy of PlaylistDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaylistDetailModelImplCopyWith<_$PlaylistDetailModelImpl> get copyWith =>
      __$$PlaylistDetailModelImplCopyWithImpl<_$PlaylistDetailModelImpl>(
          this, _$identity);
}

abstract class _PlaylistDetailModel extends PlaylistDetailModel {
  const factory _PlaylistDetailModel(
      {final int? playlistId,
      final String? title,
      final String? coverUrl,
      final String? introduction,
      final List<Song>? songs}) = _$PlaylistDetailModelImpl;
  const _PlaylistDetailModel._() : super._();

  @override
  int? get playlistId;
  @override
  String? get title;
  @override
  String? get coverUrl;
  @override
  String? get introduction;
  @override
  List<Song>? get songs;

  /// Create a copy of PlaylistDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaylistDetailModelImplCopyWith<_$PlaylistDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
