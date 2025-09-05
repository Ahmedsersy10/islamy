# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.** { *; }
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Firebase (لو بتستخدمه)
-keep class com.google.firebase.** { *; }

# Keep classes with native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
