plugins {
    id("com.android.application")
    id ("kotlin-android")
    id ("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services") // Firebase plugin
}

android {
    namespace = "com.example.peesha"
    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.peesha"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = "21"
    }
}

dependencies {
    // Firebase BoM (bill of materials)
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))
    implementation("com.google.firebase:firebase-analytics")

    // AndroidX and Material dependencies
    implementation("androidx.core:core-ktx:1.10.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.9.0")
}
