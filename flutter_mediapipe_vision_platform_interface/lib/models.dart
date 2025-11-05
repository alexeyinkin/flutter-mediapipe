import 'dart:ui';

class PoseLandmarkerResult {
  final List<List<NormalizedLandmark>> landmarks;

  const PoseLandmarkerResult.empty() : landmarks = const [];

  const PoseLandmarkerResult({required this.landmarks});
}

class NormalizedLandmark {
  final double x;
  final double y;

  const NormalizedLandmark({required this.x, required this.y});

  Offset get offset => Offset(x, y);
}
