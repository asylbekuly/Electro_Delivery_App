import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/cart_provider.dart';
import 'Provider/theme_provider.dart';
import 'View/onboard_page.dart';
import 'View/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ожидаем инициализацию
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
    await Firebase.initializeApp(); // Для мобильных устройств
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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Electronics Delivery App',
            theme: lightTheme, // Ваши темы
            darkTheme: darkTheme,
            themeMode: themeProvider.currentTheme,
            home: const AppOnBoardPage(),
            routes: {'/main': (context) => const MainPage()},
          );
        },
      ),
    );
  }
}
