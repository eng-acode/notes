import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/Model/notes_model.dart';

class HiveCRUD {
  // The box instance used for storing and retrieving notes
  Box<NotesModel>? noteBox;

  // Initializes the HiveCRUD instance and sets up the database connection
  HiveCRUD() {
    init();
  }

  // Initializes the Hive box for notes storage
  Future<void> init() async {
    // Check if the box is already open to prevent duplicate initialization
    if (Hive.isBoxOpen('NotesBox')) {
      noteBox = Hive.box<NotesModel>('NotesBox');
      return;
    }
    // else Open a new box if it doesn't exist
    noteBox = await Hive.openBox<NotesModel>('NotesBox');
  }

  // Adds a new note to the database
  void addData({myNotes}) async {
    await noteBox?.add(myNotes);
  }

  // Updates an existing note at the specified index
  void updateData({index, myNotes}) async {
    await noteBox?.put(index, myNotes);
  }

  // Converts a hex color string to a Color object
  Color colorCreation(String colorString) {
    Color color = Color(
      int.parse(colorString.replaceFirst('#', '0x'), radix: 16),
    );
    return color;
  }

  // Retrieves a single note by its index
  NotesModel? getData(int index) {
    return noteBox!.get(index);
  }

  // Returns a list of all stored notes
  List<NotesModel> getAllData() {
    List<NotesModel> test = noteBox!.values.cast<NotesModel>().toList();
    return test;
  }

  // Removes a note from the database at the specified index
  Future<void> deleteData({index}) async {
    await noteBox?.deleteAt(index);
    return;
  }
}
