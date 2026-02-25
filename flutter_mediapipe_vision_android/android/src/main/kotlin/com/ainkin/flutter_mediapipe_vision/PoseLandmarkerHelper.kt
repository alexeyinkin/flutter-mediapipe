package com.ainkin.flutter_mediapipe_vision

import android.content.Context
import com.google.mediapipe.framework.image.MPImage
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker.PoseLandmarkerOptions
import android.graphics.Bitmap
import android.util.Log

class PoseLandmarkerHelper(val context: Context, val modelPath: String) {
    var poseLandmarker: PoseLandmarker? = null

    fun setup() {
        val baseOptions = BaseOptions.builder()
            .setModelAssetPath(modelPath)
            .build()

        val options = PoseLandmarkerOptions.builder()
            .setBaseOptions(baseOptions)
            .setMinPoseDetectionConfidence(0.5f)
            .setMinTrackingConfidence(0.5f)
            .setRunningMode(RunningMode.IMAGE)
            .build()

        poseLandmarker = PoseLandmarker.createFromOptions(context, options)
        Log.d("flutter_mediapipe_vision", "PoseLandmarker Initialized.")
    }

    fun detect(mpImage: MPImage): Map<String, Any> {
        val result = poseLandmarker?.detect(mpImage)

        val allPoses = mutableListOf<List<Map<String, Float>>>()

        result?.landmarks()?.forEach { singlePoseLandmarks ->
            val convertedLandmarks = singlePoseLandmarks.map { landmark ->
                mapOf(
                    "x" to landmark.x(),
                    "y" to landmark.y(),
                    "z" to landmark.z(),
                    "visibility" to landmark.visibility().orElse(0.0f)
                )
            }
            allPoses.add(convertedLandmarks)
        }

        return mapOf("landmarks" to allPoses)
    }
}
