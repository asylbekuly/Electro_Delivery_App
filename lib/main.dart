import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/cart_provider.dart';
import 'Provider/theme_provider.dart';
import 'Provider/favorite_provider.dart';
import 'Theme/fade_page_transition.dart';
import 'View/auth/login_screen.dart';
import 'View/home_page.dart';
import 'View/favorites_page.dart';
import 'View/news_page.dart';
import 'View/map_page.dart';
import 'View/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBU1-FQzsk2J0y0j7UrYiXYwZ8b_tHg55U",
        authDomain: "electrodelivery-7dcfa.firebaseapp.com",
        projectId: "electrodelivery-7dcfa",
        storageBucket: "electrodelivery-7dcfa.firebasestorage.app",
        messagingSenderId: "287799798736",
        appId: "1:287799798736:web:710ee881b53b3d083f67d5",
        measurementId: "G-52JXHHM2XH",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Electronics Delivery App',
            theme: lightTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadePageTransitionsBuilder(),
                  TargetPlatform.iOS: FadePageTransitionsBuilder(),
                },
              ),
            ),
            darkTheme: darkTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadePageTransitionsBuilder(),
                  TargetPlatform.iOS: FadePageTransitionsBuilder(),
                },
              ),
            ),
            themeMode: themeProvider.currentTheme,
            home: const AuthGate(),
            routes: {
              '/favorites': (context) => const FavoritesPage(),
              '/news': (context) => const NewsPage(),
              '/map': (context) => const MapPage(),
            },
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const MainPage(); // Переход если авторизован
        } else {
          return LoginScreen(); // Переход если не авторизован
        }
      },
    );
  }
}
