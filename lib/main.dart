import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:move_metrics_app/design/theme.dart';
import 'package:provider/provider.dart'; // Importiere den Provider
import 'app_router.dart';
import 'server/service_locator.dart';
import 'stores/exercise_store.dart'; // Importiere den ExerciseStore

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ExerciseStore>(create: (_) => ExerciseStore()), // Füge den ExerciseStore hinzu
        // Weitere Provider können hier hinzugefügt werden, falls erforderlich
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Auth',
        theme: appTheme, // Verwende das importierte Theme
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/', 
      ),
    );
  }
}
