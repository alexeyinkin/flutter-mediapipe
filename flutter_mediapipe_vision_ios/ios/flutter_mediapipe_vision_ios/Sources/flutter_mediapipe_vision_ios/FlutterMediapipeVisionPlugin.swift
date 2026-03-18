import Flutter
import MediaPipeTasksVision
import UIKit

public class FlutterMediapipeVisionPlugin: NSObject, FlutterPlugin {
    private var poseHelper: PoseLandmarkerHelper?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "ainkin.com/flutter_mediapipe_vision",
            binaryMessenger: registrar.messenger(),
        )
        let instance = FlutterMediapipeVisionPlugin()

        let assetKey = registrar.lookupKey(
            forAsset: "assets/models/pose_landmarker_lite.task",
            fromPackage: "flutter_mediapipe_vision_platform_interface",
        )

        if let modelPath = Bundle.main.path(forResource: assetKey, ofType: nil)
        {
            instance.poseHelper = PoseLandmarkerHelper(modelPath: modelPath)
            instance.poseHelper?.setup()
        } else {
            print(
                "flutter_mediapipe_vision: ⚠️ Failed to find model asset on iOS.",
            )
        }

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult,
    ) {
        let args = call.arguments as? [String: Any]

        switch call.method {
        case "ensureInitialized":
            print(
                "flutter_mediapipe_vision: ensureInitialized called, doing nothing on iOS",
            )
            result("")

        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "detect":
            guard let imageBytes = args?["image"] as? FlutterStandardTypedData
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Missing image bytes",
                        details: nil,
                    )
                )
                return
            }

            guard let uiImage = UIImage(data: imageBytes.data) else {
                result(
                    FlutterError(
                        code: "DECODE_ERR",
                        message: "Failed to decode bytes to UIImage",
                        details: nil,
                    )
                )
                return
            }

            do {
                let mpImage = try MPImage(uiImage: uiImage)
                if let data = poseHelper?.detect(mpImage: mpImage) {
                    result(data)
                } else {
                    result(
                        FlutterError(
                            code: "DETECT_ERR",
                            message: "PoseLandmarkerHelper not initialized",
                            details: nil,
                        )
                    )
                }
            } catch {
                result(
                    FlutterError(
                        code: "DETECT_ERR",
                        message: error.localizedDescription,
                        details: nil,
                    )
                )
            }

        case "detectOnPlanes":
            guard
                let planesData = args?["planes"] as? [FlutterStandardTypedData],
                let width = args?["width"] as? Int,
                let height = args?["height"] as? Int,
                !planesData.isEmpty
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS",
                        message: "Missing or invalid planes/dimensions",
                        details: nil,
                    )
                )
                return
            }

            // iOS camera stream provides a single BGRA8888 plane.
            let bgraData = planesData[0].data

            guard
                let uiImage = createUIImage(
                    fromBgraData: bgraData,
                    width: width,
                    height: height,
                )
            else {
                result(
                    FlutterError(
                        code: "IMAGE_ERR",
                        message: "Failed to create UIImage from BGRA data",
                        details: nil,
                    )
                )
                return
            }

            do {
                let mpImage = try MPImage(uiImage: uiImage)
                if let data = poseHelper?.detect(mpImage: mpImage) {
                    result(data)
                } else {
                    result(
                        FlutterError(
                            code: "DETECT_ERR",
                            message: "PoseLandmarkerHelper not initialized",
                            details: nil,
                        )
                    )
                }
            } catch {
                result(
                    FlutterError(
                        code: "DETECT_ERR",
                        message: error.localizedDescription,
                        details: nil,
                    )
                )
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // Wraps Flutter's raw BGRA bytes into a native iOS UIImage instantly
    private func createUIImage(fromBgraData data: Data, width: Int, height: Int)
        -> UIImage?
    {
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // This specific combination tells CoreGraphics to read the memory layout as B, G, R, A
        let bitmapInfo = CGBitmapInfo(
            rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue
                | CGBitmapInfo.byteOrder32Little.rawValue
        )

        guard let provider = CGDataProvider(data: data as CFData),
            let cgImage = CGImage(
                width: width,
                height: height,
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                bytesPerRow: width * 4,  // 4 bytes per pixel (B, G, R, A)
                space: colorSpace,
                bitmapInfo: bitmapInfo,
                provider: provider,
                decode: nil,
                shouldInterpolate: false,
                intent: .defaultIntent,
            )
        else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

class PoseLandmarkerHelper {
    let modelPath: String
    var poseLandmarker: PoseLandmarker?

    init(modelPath: String) {
        self.modelPath = modelPath
    }

    func setup() {
        let baseOptions = BaseOptions()
        baseOptions.modelAssetPath = modelPath

        let options = PoseLandmarkerOptions()
        options.baseOptions = baseOptions
        options.minPoseDetectionConfidence = 0.5
        options.minTrackingConfidence = 0.5
        options.runningMode = .image

        do {
            poseLandmarker = try PoseLandmarker(options: options)
            print("flutter_mediapipe_vision: PoseLandmarker Initialized.")
        } catch {
            print(
                "flutter_mediapipe_vision: Failed to initialize - \(error.localizedDescription)",
            )
        }
    }

    func detect(mpImage: MPImage) -> [String: Any]? {
        guard let poseLandmarker = poseLandmarker else { return nil }

        do {
            let result = try poseLandmarker.detect(image: mpImage)
            var allPoses: [[[String: Float]]] = []

            for singlePoseLandmarks in result.landmarks {
                var convertedLandmarks: [[String: Float]] = []
                for landmark in singlePoseLandmarks {
                    convertedLandmarks.append([
                        "x": landmark.x,
                        "y": landmark.y,
                        "z": landmark.z,
                        "visibility": landmark.visibility?.floatValue ?? 0.0,
                    ])
                }
                allPoses.append(convertedLandmarks)
            }

            return ["landmarks": allPoses]
        } catch {
            print(
                "flutter_mediapipe_vision: Detection failed - \(error.localizedDescription)",
            )
            return nil
        }
    }
}
