# ==========================================
# This Plugin
# ==========================================
-keep class com.ainkin.flutter_mediapipe_vision.** { *; }

# ==========================================
# Flutter Framework & Plugins
# ==========================================
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# ==========================================
# MediaPipe
# ==========================================
-keep public class com.google.mediapipe.** { *; }
-keep class com.google.mediapipe.framework.** { *; }
-keep class com.google.mediapipe.solutioncore.** { *; }
-keep class com.google.mediapipe.tasks.** { *; }

-dontwarn com.google.mediapipe.proto.CalculatorProfileProto$CalculatorProfile
-dontwarn com.google.mediapipe.proto.GraphTemplateProto$CalculatorGraphTemplate

# ==========================================
# Protobuf
# ==========================================
-keep class com.google.protobuf.** { *; }
-keepclassmembers class * extends com.google.protobuf.GeneratedMessageLite { *; }

# ==========================================
# Google Common (Guava)
# ==========================================
-keep public class com.google.common.** { *; }

# ==========================================
# AndroidX Lifecycle
# ==========================================
-keep class androidx.lifecycle.** { *; }
-keep class * extends androidx.lifecycle.LifecycleObserver { *; }

# ==========================================
# Javax Annotations
# ==========================================
-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.**

# ==========================================
# Global Attributes
# ==========================================
-keepattributes Signature,InnerClasses,EnclosingMethod,*Annotation*
