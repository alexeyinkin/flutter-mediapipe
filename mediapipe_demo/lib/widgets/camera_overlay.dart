import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../controllers/inference.dart';
import '../enums/points.dart';

class CameraOverlayWidget extends StatelessWidget {
  final InferenceController inferenceController;

  const CameraOverlayWidget({required this.inferenceController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: inferenceController,
      child: CameraPreview(inferenceController.cameraController),
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: CameraOverlayPainter(
            inferenceController: inferenceController,
          ),
          willChange: true,
          child: child,
        );
      },
    );
  }
}

class CameraOverlayPainter extends CustomPainter {
  final InferenceController inferenceController;

  static final _paint = Paint()
    ..color = Colors.white
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..strokeWidth = 5;
  static const _pointRadius = 5.0;

  CameraOverlayPainter({required this.inferenceController});

  @override
  void paint(Canvas canvas, Size size) {
    _paintPose(canvas, size);
  }

  void _paintPose(Canvas canvas, Size size) {
    final pose = inferenceController.lastResult.landmarks.firstOrNull;
    if (pose == null) {
      return;
    }

    final nose = pose[Points.nose].offset.timesSize(size);
    final leftShoulder = pose[Points.leftShoulder].offset.timesSize(size);
    final rightShoulder = pose[Points.rightShoulder].offset.timesSize(size);
    final leftElbow = pose[Points.leftElbow].offset.timesSize(size);
    final rightElbow = pose[Points.rightElbow].offset.timesSize(size);
    final leftWrist = pose[Points.leftWrist].offset.timesSize(size);
    final rightWrist = pose[Points.rightWrist].offset.timesSize(size);
    final leftPelvis = pose[Points.leftPelvis].offset.timesSize(size);
    final rightPelvis = pose[Points.rightPelvis].offset.timesSize(size);
    final leftKnee = pose[Points.leftKnee].offset.timesSize(size);
    final rightKnee = pose[Points.rightKnee].offset.timesSize(size);
    final leftAnkle = pose[Points.leftAnkle].offset.timesSize(size);
    final rightAnkle = pose[Points.rightAnkle].offset.timesSize(size);

    _paintLine(canvas, leftShoulder, rightShoulder);
    _paintLine(canvas, leftShoulder, leftElbow);
    _paintLine(canvas, leftElbow, leftWrist);
    _paintLine(canvas, rightShoulder, rightElbow);
    _paintLine(canvas, rightElbow, rightWrist);
    _paintLine(canvas, leftShoulder, leftPelvis);
    _paintLine(canvas, rightShoulder, rightPelvis);
    _paintLine(canvas, leftPelvis, rightPelvis);
    _paintLine(canvas, leftPelvis, leftKnee);
    _paintLine(canvas, leftKnee, leftAnkle);
    _paintLine(canvas, rightPelvis, rightKnee);
    _paintLine(canvas, rightKnee, rightAnkle);

    _paintPoint(canvas, nose);
    _paintPoint(canvas, leftShoulder);
    _paintPoint(canvas, rightShoulder);
    _paintPoint(canvas, leftElbow);
    _paintPoint(canvas, rightElbow);
    _paintPoint(canvas, leftWrist);
    _paintPoint(canvas, rightWrist);
    _paintPoint(canvas, leftPelvis);
    _paintPoint(canvas, rightPelvis);
    _paintPoint(canvas, leftKnee);
    _paintPoint(canvas, rightKnee);
    _paintPoint(canvas, leftAnkle);
    _paintPoint(canvas, rightAnkle);
  }

  void _paintPoint(Canvas canvas, Offset offset) {
    canvas.drawCircle(offset, _pointRadius, _paint);
  }

  void _paintLine(Canvas canvas, Offset pt1, Offset pt2) {
    canvas.drawLine(pt1, pt2, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension on Offset {
  Offset timesSize(Size size) => Offset(dx * size.width, dy * size.height);
}
