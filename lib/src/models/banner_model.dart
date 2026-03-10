import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_model.freezed.dart';

@freezed
class BannerModel with _$BannerModel {
  const factory BannerModel({
    int? bannerId,
    String? bannerUrl,
  }) = _BannerModel;

  const BannerModel._();

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerId: json['bannerId'],
      bannerUrl: json['bannerUrl']?.toString().trim(),
    );
  }
}
