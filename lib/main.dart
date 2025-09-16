import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';  // Add this
import 'providers/task_provider.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(QuickTickApp());
}

class QuickTickApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'QuickTick',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),  // Change this from HomeScreen()
      ),
    );
  }
}