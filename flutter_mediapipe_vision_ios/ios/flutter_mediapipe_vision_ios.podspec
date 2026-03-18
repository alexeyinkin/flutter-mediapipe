#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_mediapipe_vision.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_mediapipe_vision_ios'
  s.version          = '0.3.1'
  s.summary          = 'A minimal wrapper for the pose landmark detector'
  s.description      = 'A minimal wrapper for the pose landmark detector'
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Alexey Inkin' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_mediapipe_vision_ios/Sources/flutter_mediapipe_vision_ios/**/*'
  s.dependency 'Flutter'
  s.dependency 'MediaPipeTasksVision' #, '~> 0.10.32'
  s.platform = :ios, '13.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_mediapipe_vision_privacy' => ['flutter_mediapipe_vision/Sources/flutter_mediapipe_vision/PrivacyInfo.xcprivacy']}
end
