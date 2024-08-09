import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:move_metrics_app/design/theme.dart';
import 'app_router.dart';
import 'network/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: appTheme, // Verwende das importierte Theme
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/', 
    );
  }
}
