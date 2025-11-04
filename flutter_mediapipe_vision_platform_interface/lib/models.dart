import 'dart:ui';

class PoseLandmarkerResult {
  final List<List<NormalizedLandmark>> landmarks;

  const PoseLandmarkerResult.empty() : landmarks = const [];

  const PoseLandmarkerResult({
    required this.landmarks,
  });

  @override
  String toString() => landmarks.toString();
}

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
}
