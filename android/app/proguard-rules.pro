# Flutter 应用的 ProGuard 规则

# 保留 Flutter 包装器类
-keep class io.flutter.app.** {
    *;
}
-keep class io.flutter.plugin.**  {
    *;
}
-keep class io.flutter.util.**  {
    *;
}
-keep class io.flutter.view.**  {
    *;
}
-keep class io.flutter.**  {
    *;
}
-keep class io.flutter.plugins.**  {
    *;
}

# 保留基本类型的包装类
-keep class java.lang.Integer {
    *;
}
-keep class java.lang.Long {
    *;
}
-keep class java.lang.Float {
    *;
}
-keep class java.lang.Double {
    *;
}
-keep class java.lang.Boolean {
    *;
}
-keep class java.lang.String {
    *;
}

# 保留 Android 基本组件
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# 保留构造函数
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

# 保留带有回调的类
-keepclasseswithmembers class * {
    public void *(android.view.View);
}

# 保留枚举类
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保留 Parcelable 实现
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# 保留 Serializable 实现
-keepclassmembers class * implements java.io.Serializable {
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ==================== 图片加载相关 ====================
# Cached Network Image (Flutter 插件)
-keep class com.reactnativecommunity.webview.** { *; }

# Flutter Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Glide 完整混淆规则 (cached_network_image 底层使用)
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class * extends com.bumptech.glide.module.AppGlideModule {
    <init>(...);
}
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
    **[] $VALUES;
    public *;
}
-keep class com.bumptech.glide.load.data.ParcelFileDescriptorRewinder$InternalRewinder {
    *** rewind();
}
# Glide 核心类
-keep class com.bumptech.glide.** { *; }
-keep class com.bumptech.glide.annotation.** { *; }
-keep class com.bumptech.glide.integration.** { *; }
-keep class com.bumptech.glide.load.** { *; }
-keep class com.bumptech.glide.request.** { *; }
-keep class com.bumptech.glide.manager.** { *; }
-keep class com.bumptech.glide.util.** { *; }
-dontwarn com.bumptech.glide.**

# Picasso 混淆规则 (备用)
-keep class com.squareup.picasso.** { *; }
-dontwarn com.squareup.picasso.**

# Coil 混淆规则 (备用)
-keep class coil.** { *; }
-dontwarn coil.**

# Fresco 混淆规则 (备用)
-keep class com.facebook.fresco.** { *; }
-dontwarn com.facebook.fresco.**

# 图片解码器
-keep class android.graphics.** { *; }
-keep class android.media.** { *; }

# OkHttp (图片加载使用)
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# 保留网络相关类
-keep class java.net.** { *; }
-keep class javax.net.** { *; }
-keep class android.net.** { *; }

# ==================== 音频相关 ====================
# Just Audio / ExoPlayer
-keep class com.google.android.exoplayer2.** {
    *;
}
-dontwarn com.google.android.exoplayer2.**

# Audio Service (Ryan Heise)
-keep class com.ryanheise.** {
    *;
}
-dontwarn com.ryanheise.**

# Audio Players
-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**

# Audio Session
-keep class com.ryanheise.audio_session.** { *; }

# ==================== 网络相关 ====================
# Dio HTTP 客户端
-keep class com.dio.** {
    *;
}

# OkHttp (Dio 底层) - 已在图片加载部分定义
# -keep class okhttp3.** { *; }
# -keep interface okhttp3.** { *; }
# -dontwarn okhttp3.**
# -dontwarn okio.**

# ==================== 状态管理 ====================
# GetX
-keep class com.get.** { *; }

# Provider
-keep class com.provider.** {
    *;
}

# ==================== 图片选择器 ====================
# Image Picker
-keep class com.imagepicker.** {
    *;
}
-keep class io.flutter.plugins.imagepicker.** { *; }

# ==================== 本地存储 ====================
# Shared Preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Path Provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# SQFlite
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**

# ==================== 设备信息 ====================
# Device Info Plus
-keep class dev.fluttercommunity.plus.device_info.** { *; }

# Connectivity Plus
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# ==================== 权限处理 ====================
# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# ==================== UI 组件 ====================
# Carousel Slider
-keep class com.carouselslider.** {
    *;
}

# Shimmer
-keep class com.shimmer.** { *; }

# Flutter SVG
-keep class com.dnfield.svg.** { *; }

# ==================== 工具类 ====================
# Flutter Dotenv
-keep class com.flutterdotenv.** {
    *;
}

# Freezed
-keep class com.freezed.** {
    *;
}

# Logger
-keep class com.logger.** {
    *;
}

# ==================== 启动页 ====================
# Flutter Native Splash
-keep class com.flutternativesplash.** {
    *;
}
-keep class net.jonhanson.flutter_native_splash.** { *; }

# ==================== 窗口管理 (Desktop) ====================
# Bitsdojo Window
-keep class com.bitsdojo.window.** { *; }

# ==================== 加密 ====================
# Pointy Castle
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**
-keep class pointycastle.** { *; }

# ==================== Google Play ====================
# Google Play Core
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# ==================== 保留所有 Flutter 插件 ====================
-keep class io.flutter.plugins.** { *; }
-keep class * extends io.flutter.plugin.common.PluginRegistry.Registrar { *; }

# 保留所有使用 @Keep 注解的类
-keep @androidx.annotation.Keep class * {*;}

# 保留所有使用 @Keep 注解的方法
-keepclassmembers @androidx.annotation.Keep class * {*;}

# 保留所有使用 @Keep 注解的字段
-keepclassmembers @androidx.annotation.Keep class * {
    @androidx.annotation.Keep <fields>;
}

# 保留所有使用 @Keep 注解的方法
-keepclassmembers @androidx.annotation.Keep class * {
    @androidx.annotation.Keep <methods>;
}

# 保留 R 类
-keepclassmembers class **.R$* {
    public static <fields>;
}

# 保留 BuildConfig
-keep class **.BuildConfig { *; }

# 保留 Kotlin 元数据
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations
-keepattributes MethodParameters

# 保留 Kotlin 相关
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# 保留 kotlinx.coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembers class kotlinx.coroutines.** {
    volatile <fields>;
}
