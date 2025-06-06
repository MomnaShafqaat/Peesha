// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        // You can include mirrors, but Google and MavenCentral are required.
        google()
        mavenCentral()
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") } // Required for Flutter
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0") // ✅ Correct version for Gradle 8.2
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22") // ✅ Matches Flutter 3.16+
        classpath("com.google.gms:google-services:4.3.15") // ✅ Firebase
        // ❌ Do NOT add flutter-gradle-plugin manually — Flutter handles this automatically.
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") } // Flutter artifacts
    }
}

plugins {
    id("com.google.gms.google-services") version "4.3.15" apply false
}
