import 'package:flutter/material.dart';

import 'package:notes_app/HiveDB/hive_crud.dart';
import 'package:notes_app/Model/notes_model.dart';
import 'package:notes_app/components/toast.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  // creating variable to check HiveCRUD
  late HiveCRUD hiveCRUD;
  // creating variable to store Data from HiveDB into list for printing
  List noteListFromDB = [];

  @override
  void initState() {
    super.initState();
    // making object of HiveCRUD class
    hiveCRUD = HiveCRUD();
    // calling _loadNotes Method
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    // setting state by updating List from hiveCRUD.getAllData
    // setState will auto populate list and display on screen
    setState(() {
      noteListFromDB = hiveCRUD.getAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // creating listview builder
    return ListView.builder(
      // adding list Item Count from Total of NoteList we have
      itemCount: noteListFromDB.length,
      itemBuilder: (context, index) {
        // creating model of each note retrieved from DB for displaying
        final NotesModel note = noteListFromDB[index];

        // Dismissible Widget is swipe to Delete in a listview
        return Dismissible(
          // key is the Unique key/index retrieved from DB
          key: Key(note.key.toString()), // Use unique ID from model
          // direction to swipe right to left
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          // making onDismiss Async so it waits for task to be completed
          onDismissed: (direction) async {
            // calling deleteDataAtIndex from hiveCRUD class and passing index
            await hiveCRUD.deleteData(index: index);

            // once data is deleted resetting state
            setState(() {
              // removing Item from out populated List
              noteListFromDB.removeAt(index);
              // checking if List is empty should show us homePage and note NotesList Page
              if (noteListFromDB.isEmpty) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/homepage',
                  (Route<dynamic> route) => false,
                );
              }
            });

            // printing a Toast message
            toast(
              context: context,
              message: "Note Deleted Successfully",
              isDeleted: true,
            );
          },
          // ListTile to display Data
          child: ListTile(
            onTap: () {
              // Routing to Add Nots Page and sending our DB note Key as parameter to access that note
              Navigator.pushNamed(
                context,
                '/notes',
                arguments: note.key.toString(),
              );
            },
            title: Container(
              margin: EdgeInsets.only(bottom: 8.0, left: 5.0),
              decoration: BoxDecoration(
                color: note.color,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // checking if note.title has value print else print ''
                      note.title ?? '',
                      style: TextStyle(
                        // setting fontFamily else set ''
                        fontFamily: note.fontFamily ?? '',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333),
                      ),
                    ),
                    Divider(height: 2, color: Color(0xff333333)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        // checking if note description length is >= 150 then we need 3 (DOTS)... to limit text in note like ...Read More
                        (note.description.toString().length >= 150)
                            ? '${note.description?.characters.take(150).toString()} ...'
                            : '${note.description?.toString()}',
                        style: TextStyle(
                          fontFamily: note.fontFamily ?? '',
                          color: Color(0xff333333),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
