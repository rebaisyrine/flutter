// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'screens/home_screen.dart';
import 'screens/notes_screen.dart';

Future<void> main() async {
  // S'assurer que Flutter est initialisé avant le chargement du .env
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement depuis le fichier .env
  await dotenv.load(fileName: ".env");

  // Lancer l'application
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/notes': (context) => NotesScreen(),
      },
    );
  }
}
// ...existing code...