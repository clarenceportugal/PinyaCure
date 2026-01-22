# TensorFlow Lite ProGuard Rules
# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.nnapi.** { *; }
-keep class org.tensorflow.lite.flex.** { *; }

# Keep GpuDelegate classes
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Interpreter classes
-keep class org.tensorflow.lite.Interpreter { *; }
-keep class org.tensorflow.lite.InterpreterApi { *; }

# Keep model loading classes
-keep class org.tensorflow.lite.support.** { *; }

# Don't warn about missing classes (some may be optional)
-dontwarn org.tensorflow.lite.gpu.**
