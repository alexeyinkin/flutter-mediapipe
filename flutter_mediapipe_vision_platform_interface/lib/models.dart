import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class PoseLandmarkerResult {
  final List<List<NormalizedLandmark>> landmarks;

  const PoseLandmarkerResult.empty() : landmarks = const [];

  const PoseLandmarkerResult({required this.landmarks});

  @override
  String toString() => landmarks.toString();

  Map<String, dynamic> toJson() => _$PoseLandmarkerResultToJson(this);

  factory PoseLandmarkerResult.fromJson(Map<String, dynamic> map) =>
      _$PoseLandmarkerResultFromJson(map);
}

@JsonSerializable()
class NormalizedLandmark {
  final double x;
  final double y;
  final double z;
  final double visibility;

  const NormalizedLandmark({
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  Offset get offset => Offset(x, y);

  @override
  String toString() => '[$x, $y, $z]';

  Map<String, dynamic> toJson() => _$NormalizedLandmarkToJson(this);

  factory NormalizedLandmark.fromJson(Map<String, dynamic> map) =>
      _$NormalizedLandmarkFromJson(map);
}
