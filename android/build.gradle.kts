buildscript {
    repositories {
        // Use faster, reliable mirrors
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:7.3.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}


plugins {
    id("com.google.gms.google-services") version "4.3.15" apply false
}
