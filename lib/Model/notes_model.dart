import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part '../Adapter/my_notes_adapter.g.dart';

// Annotate the class with HiveType to enable database storage
@HiveType(typeId: 1)
// A data model representing a note in the application, extending HiveObject for database storage.
class NotesModel extends HiveObject {
  // The title of the note, stored as a nullable string
  @HiveField(0)
  String? title;

  // The main content of the note, stored as a nullable string
  @HiveField(1)
  String? description;

  // The font family to use when displaying the note, stored as a nullable string
  @HiveField(2)
  String? fontFamily;

  // The color of the note, stored as a non-nullable Color object
  @HiveField(3)
  Color color;

  // Constructor for creating new NotesModel instances
  NotesModel({
    required this.title,
    required this.description,
    required this.fontFamily,
    this.color = const Color(0xff333333),
  });
}
