import java.util.Properties
import java.io.FileInputStream
plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
android {
    namespace = "com.youssef.mkanak"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13113456"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // <--- هذا السطر يجب أن يبقى لـ flutter_local_notifications
        sourceCompatibility = JavaVersion.VERSION_11 // <--- أعد هذا إلى VERSION_11 أو VERSION_17
        targetCompatibility = JavaVersion.VERSION_11 // <--- أعد هذا إلى VERSION_11 أو VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString() // <--- أعد هذا إلى VERSION_11
    }

    defaultConfig {
        applicationId = "com.youssef.mkanak"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
             signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // هذا السطر ضروري لـ Core Library Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // تأكد من أن هذا الإصدار 2.0.4 كافٍ لإصدارات Java الأعلى، وإلا قد تحتاج للتحقق من أحدث إصدار
}