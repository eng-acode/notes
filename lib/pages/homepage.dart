import 'package:flutter/material.dart';
import 'package:notes_app/HiveDB/hive_crud.dart';
import 'package:notes_app/components/text_widget.dart';
import 'package:notes_app/pages/notes_list.dart';
import 'package:notes_app/pages/welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // creating variable for later use
  late HiveCRUD hiveCRUD;

  // variable to check if out NotesBox is empty or does it has any Data
  bool? isBoxEmpty;

  @override
  void initState() {
    super.initState();
    hiveCRUD = HiveCRUD();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    // await hiveCRUD.init();
    setState(() {
      // checking and setting UI according to data exist or no
      isBoxEmpty = hiveCRUD.getAllData().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff333333),
      appBar: AppBar(
        // setting default color for our Icons to white
        iconTheme: IconThemeData(color: Color(0xff333333), size: 24),
        backgroundColor: Color(0xff333333),
        // calling TextWidget and initializing it
        title: TextWidget(
          title: "NOTES",
          fontFamily: 'Pacifico',
          fontSize: 24.0,
          fontColor: Colors.white,
          fontWeight: FontWeight.normal,
          letterSpacing: 0,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton.filledTonal(
              disabledColor: Colors.white,
              onPressed: () {
                showInfoDialog(context);
              },
              icon: Icon(Icons.info_outline),
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                  (state) => Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton.filledTonal(
              disabledColor: Colors.white,
              onPressed: () {
                showAuthorDialog(context);
              },
              icon: Icon(Icons.privacy_tip_outlined),
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                  (state) => Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),

      // BODY
      body:
          // First check if box/database exists
          isBoxEmpty == null
              ? const Center(
                // While loading data, show circular progress indicator
                child: CircularProgressIndicator(),
              )
              : isBoxEmpty! // Once loaded, check if box is empty
              ? WelcomePage() // If box is empty, show welcome page
              : NotesList(), // If box contains data, display notes list

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          Navigator.pushNamed(context, '/notes');
        },

        child: Icon(Icons.add_circle_sharp, color: Colors.green, size: 34),
      ),
    );
  }
}

void showAuthorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Center(child: Text("Credits")),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("This App is Made By TechyAmru"),
                Text("© Since 2025"),
              ],
            ),
          ),
        ],
      );
    },
  );
}

showInfoDialog(context) {
  int i = 0;
  final List instructions = [
    "To ADD A Note\n"
        " - Press On ADD Button\n"
        " - TYPE your Title\n"
        " - TYPE Your Note Content\n"
        " - CHOOSE your font Family & Color\n"
        " - Click ADD!\n",
    "To View a Note\n"
        " - Select a Note from list\n"
        " - NOTE opened in VIEW MODE\n"
        " - SWITCH mode with EDIT Icon\n",
    "To UPDATE A Note\n"
        " - Choose Your Note from List\n"
        " - UPDATE your Title\n"
        " - UPDATE Your Note Content\n"
        " - UPDATE your font Family & Color\n"
        " - Click SAVE!\n",
    "To DELETE A Note\n"
        " - Swipe Left on a Note Item\n   from Notes List\n"
        " - Your Note is DELETED!\n",
  ];
  List<String> infoSS = [
    'assets/info_images/add.png',
    'assets/info_images/view.png',
    'assets/info_images/update.png',
    'assets/info_images/delete.png',
  ];
  showDialog(
    useSafeArea: true,
    barrierDismissible: false,
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return SimpleDialog(
              title: Center(child: Text('How to use Notes App')),
              contentPadding: EdgeInsets.all(20.0),
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(instructions[i]),
                      ),
                    ),
                    Image(
                      image: AssetImage(infoSS[i]),
                      height: 400,
                      width: 300,
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    i > 0
                        ? TextButton(
                          onPressed: () => setDialogState(() => i--),
                          child: Text(
                            "<< Back",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                        : Container(),
                    i == instructions.length - 1
                        ? TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close", style: TextStyle(fontSize: 16)),
                        )
                        : TextButton(
                          onPressed: () => setDialogState(() => i++),
                          child: Text(
                            "Next >>",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  ],
                ),
              ],
            );
          },
        ),
  );
}
