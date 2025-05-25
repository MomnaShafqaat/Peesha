rootProject.name = "Peesha"

pluginManagement {
    val flutterSdkPath: String = run {
        val properties = java.util.Properties().apply {
            file("local.properties").inputStream().use(::load)
        }
        properties.getProperty("flutter.sdk")
            ?: error("flutter.sdk not set in local.properties")
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("com.android.application") version "8.4.0" apply false
    id("com.google.gms.google-services") version "4.3.15" apply false
    id("org.jetbrains.kotlin.android") version "2.0.20" apply false
}

include(":app")