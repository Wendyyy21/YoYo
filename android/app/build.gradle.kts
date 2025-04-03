plugins {
    id("com.android.application")
    id("com.google.gms.google-services")  // FlutterFire
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.android.gms.oss-licenses-plugin") version "0.10.6"  // Add this line
}

val backgroundGeolocation = project(":flutter_background_geolocation")
apply { from("${backgroundGeolocation.projectDir}/background_geolocation.gradle") }

android {
    namespace = "com.petrichor4.yoyo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.petrichor4.yoyo"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isShrinkResources = false
        }
    }
}

dependencies {
    implementation("com.google.android.gms:play-services-oss-licenses:17.0.1")  // Add this line
    implementation(project(":flutter_background_geolocation"))  // Keep existing
}

flutter {
    source = "../.."
}