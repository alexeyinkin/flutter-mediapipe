package com.ainkin.flutter_mediapipe_vision

import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.framework.image.ByteBufferImageBuilder
import com.google.mediapipe.framework.image.MPImage
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.nio.ByteBuffer
import android.util.Log

class FlutterMediapipeVisionPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var poseHelper: PoseLandmarkerHelper

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val modelPath = flutterPluginBinding.flutterAssets.getAssetFilePathByName(
            "assets/models/pose_landmarker_lite.task",
            "flutter_mediapipe_vision_platform_interface",
        )

        poseHelper = PoseLandmarkerHelper(flutterPluginBinding.applicationContext, modelPath)
        poseHelper.setup()

        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "ainkin.com/flutter_mediapipe_vision",
        )
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "ensureInitialized" -> {
                Log.d(
                    "flutter_mediapipe_vision",
                    "ensureInitialized called, doing nothing on Android",
                )
                result.success("")
            }

            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "detect" -> {
                try {
                    val imageBytes = call.argument<ByteArray>("image")!!
                    val bitmap = android.graphics.BitmapFactory.decodeByteArray(
                        imageBytes,
                        0,
                        imageBytes.size,
                    )
                    val mpImage = BitmapImageBuilder(bitmap).build()
                    val data = poseHelper.detect(mpImage)
                    result.success(data)
                } catch (e: Exception) {
                    result.error("DETECT_ERR", e.message, e)
                }
            }

            "detectOnPlanes" -> {
                try {
                    val planes = call.argument<List<ByteArray>>("planes")!!
                    val width = call.argument<Int>("width")!!
                    val height = call.argument<Int>("height")!!
                    val buffer = convertYuvToRgbaBuffer(planes, width, height)

                    val mpImage = ByteBufferImageBuilder(
                        buffer,
                        width,
                        height,
                        MPImage.IMAGE_FORMAT_RGBA
                    ).build()

                    val data = poseHelper.detect(mpImage)
                    result.success(data)
                } catch (e: Exception) {
                    result.error("DETECT_ERR", e.message, e)
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun convertYuvToRgbaBuffer(
        planes: List<ByteArray>,
        width: Int,
        height: Int
    ): ByteBuffer {
        val rgba = ByteBuffer.allocateDirect(width * height * 4)
        val yPlane = planes[0]
        val uPlane = planes[1]
        val vPlane = planes[2]

        var yp = 0
        for (j in 0 until height) {
            val uvp = (j shr 1) * (width shr 1)
            for (i in 0 until width) {
                val y = (yPlane[yp].toInt() and 0xff)
                val u = (uPlane[uvp + (i shr 1)].toInt() and 0xff) - 128
                val v = (vPlane[uvp + (i shr 1)].toInt() and 0xff) - 128

                // Standard YUV to RGB conversion formulas
                val r = (y + 1.402 * v).toInt().coerceIn(0, 255)
                val g = (y - 0.3441 * u - 0.7141 * v).toInt().coerceIn(0, 255)
                val b = (y + 1.772 * u).toInt().coerceIn(0, 255)

                rgba.put(r.toByte()).put(g.toByte()).put(b.toByte()).put(255.toByte())
                yp++
            }
        }
        rgba.rewind()
        return rgba
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
