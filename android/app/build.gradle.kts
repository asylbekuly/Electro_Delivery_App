plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.food_delivery_app"
    compileSdk = 30  // Используйте нужную версию
    ndkVersion = "21.4.7075529"  // Используйте нужную версию NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.food_delivery_app"
        minSdk = 21  // Минимальная версия Android, используемая в вашем проекте
        targetSdk = 30  // Целевая версия Android
        versionCode = 1  // Версия приложения (увеличивайте при обновлениях)
        versionName = "1.0"  // Версия приложения
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")  // Для релиза настройте подписку
        }
    }
}

flutter {
    source = "../.." // Путь до исходников Flutter
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.12.0")) // BOM контролирует версии
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
}

