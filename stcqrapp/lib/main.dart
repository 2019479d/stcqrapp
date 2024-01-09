import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcqrapp/Screens/splash_screen.dart';
import 'package:stcqrapp/configs/custom_colors.dart';
import 'package:stcqrapp/models/auth_model.dart';

import 'models/logs_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LogsModel()),
        ChangeNotifierProvider(create: (context) => AuthModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'STC QR App',
        theme: ThemeData(
          fontFamily: 'Karla',
          colorScheme:
              ColorScheme.fromSeed(seedColor: CustomColors.oliveSkinColor),
          useMaterial3: true,
          appBarTheme: const AppBarTheme().copyWith(
            titleTextStyle: const TextStyle(
              fontSize: 22,
              fontFamily: 'Karla',
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: CustomColors.brownColor,
            foregroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
