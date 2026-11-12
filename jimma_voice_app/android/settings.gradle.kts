pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")

gradle.beforeProject {
    if (project.name != "app" && project.name != rootProject.name) {
        project.extensions.extraProperties.set("flutter", mapOf("compileSdkVersion" to 35, "minSdkVersion" to 23, "targetSdkVersion" to 35, "ndkVersion" to "27.0.12077973"))
    }
}
