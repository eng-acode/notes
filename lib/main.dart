import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/Model/notes_model.dart';
import 'package:notes_app/pages/notes.dart';
import 'package:notes_app/pages/notes_list.dart';
import 'package:notes_app/pages/homepage.dart';
import 'package:notes_app/pages/splash_screen.dart';
import 'Adapter/color_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  // await Hive.initFlutter(appDocumentDir.path);

  await Hive.initFlutter();
  Hive.registerAdapter<NotesModel>(MyNotesAdapter());
  Hive.registerAdapter<Color>(ColorAdapter());
  await Hive.openBox<NotesModel>('NotesBox');

  runApp(const NoteMain());
}

class NoteMain extends StatelessWidget {
  const NoteMain({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // declaring initial Route
      initialRoute: '/splash_screen',

      // creating route links
      routes: {
        '/splash_screen': (context) => SplashScreen(),
        '/homepage': (context) => HomePage(),
        '/notes_list': (context) => NotesList(),
      },

      // creating route with Passing value
      onGenerateRoute: (settings) {
        // if route name is /notes
        if (settings.name == '/notes') {
          // if route name is null then return parameter as null
          if (settings.name == null) {
            return MaterialPageRoute(builder: (context) => Notes(noteID: null));
          }
          // else set parameter as dataType of our Choice
          final String? noteID = settings.arguments as String?;
          // return our parameter
          return MaterialPageRoute(builder: (context) => Notes(noteID: noteID));
        }
        return null;
      },
    );
  }
}
