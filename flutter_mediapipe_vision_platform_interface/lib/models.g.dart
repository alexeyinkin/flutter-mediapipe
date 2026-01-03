// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoseLandmarkerResult _$PoseLandmarkerResultFromJson(
  Map<String, dynamic> json,
) => PoseLandmarkerResult(
  landmarks: (json['landmarks'] as List<dynamic>)
      .map(
        (e) => (e as List<dynamic>)
            .map((e) => NormalizedLandmark.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      .toList(),
);

Map<String, dynamic> _$PoseLandmarkerResultToJson(
  PoseLandmarkerResult instance,
) => <String, dynamic>{'landmarks': instance.landmarks};

NormalizedLandmark _$NormalizedLandmarkFromJson(Map<String, dynamic> json) =>
    NormalizedLandmark(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
    );

Map<String, dynamic> _$NormalizedLandmarkToJson(NormalizedLandmark instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'visibility': instance.visibility,
    };
