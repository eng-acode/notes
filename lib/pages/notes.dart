import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/HiveDB/hive_crud.dart';
import 'package:notes_app/Model/notes_model.dart';
import 'package:notes_app/components/color_picker.dart';
import 'package:notes_app/components/font_picker.dart';
import 'package:notes_app/components/text_widget.dart';
import 'package:notes_app/components/toast.dart';

class Notes extends StatefulWidget {
  const Notes({super.key, this.noteID});

  // variable to fetch/store/get NoteID from DB from NoteList Page
  final String? noteID;

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  // creating variables for later use
  late HiveCRUD hiveCRUD;
  late NotesModel notesModel;

  // boolean to check if note available if available we update else we add new
  bool isNoteExist = false;
  bool _switchViewMode = true;
  bool _focusCursor = false;

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();

  // finding my notesBox
  var notesBox = Hive.box<NotesModel>("NotesBox");

  // default picked color which will appear when this page is opened
  Color pickedColor = Color(0xffee7ead);
  bool isColorSelected = false;
  String _selectedFontFamily = 'Comic Neue';

  // Text Editing Controller for user inputs
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // HIVECRUD CLASS OBJECT;
    hiveCRUD = HiveCRUD();
    // checking if we got ID from NotesList Page
    if (widget.noteID != null) {
      // if yes we get Data at Index using noteID we passed to this page
      notesModel = hiveCRUD.getData(int.parse(widget.noteID.toString()))!;
      // setting default values if note is clicked for update
      isColorSelected = true;
      isNoteExist = true;
      // populating out notes page with data for UPDATE
      setState(() {
        _titleController.text = notesModel.title.toString();
        _notesController.text = notesModel.description.toString();
        _selectedFontFamily = notesModel.fontFamily.toString();
        pickedColor = notesModel.color;
      });
    }
  }

  @override
  void dispose() {
    // clearing textControllers when not in use
    _titleController.dispose();
    _notesController.dispose();
    _titleFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // calling FontPickerDialog
    FontPickerDialog fontPickerDialog = FontPickerDialog(
      context: context,
      defaultFont: _selectedFontFamily,
      // calling the callback from dialog Box to Notes Widget to Update UI
      onFontSelected: (font) {
        // setting _selectedFont of this page as font from dialog box return/callback
        setState(() {
          _selectedFontFamily = font;
        });
      },
    );

    // calling ColorPickerDialog
    ColorPickerDialog colorPickerDialog = ColorPickerDialog(
      context: context,
      pickedColor: pickedColor,
      isColorSelected: isColorSelected,
      // calling the callback from dialog Box to Notes Widget to Update UI
      onColorSelected: (colorValue, boolValue) {
        // setting pickedColor of this page as colorValue and isColorSelected as boolValue from dialog box return/callback
        setState(() {
          pickedColor = colorValue;
          isColorSelected = boolValue;
        });
      },
    );

    return Scaffold(
      // isColorSelected == true then color else default
      backgroundColor: isColorSelected ? pickedColor : Color(0xff333333),

      // Appbar with Actions
      appBar: AppBar(
        leading: IconButton.filledTonal(
          disabledColor: Colors.white,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_outlined),
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (state) => Colors.white,
            ),
          ),
        ),
        // setting default color for our Icons to white
        iconTheme: IconThemeData(color: Color(0xff333333), size: 24),
        backgroundColor: isColorSelected ? pickedColor : Color(0xff333333),

        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              spacing: 8,
              children: [
                if (isNoteExist)
                  IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        _switchViewMode = !_switchViewMode;
                      });
                    },
                    icon:
                        _switchViewMode
                            ? Icon(Icons.edit_calendar_outlined)
                            : Icon(Icons.remove_red_eye_outlined),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith(
                        (state) => Colors.white,
                      ),
                    ),
                  ),

                // Font Selector
                IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      // calling fontPickerDialog
                      fontPickerDialog.showFontPicker();
                    });
                  },
                  icon: Icon(Icons.font_download_outlined),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (state) => Colors.white,
                    ),
                  ),
                ),

                //Color Selector
                IconButton.filledTonal(
                  onPressed: () {
                    // calling colorPickerDialog
                    colorPickerDialog.showColorPicker();
                  },
                  icon: Icon(Icons.color_lens_outlined),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (state) => Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isNoteExist
                ? _switchViewMode
                    ? InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _focusCursor = true;
                          _switchViewMode = false;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          FocusScope.of(context).requestFocus(_titleFocusNode);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextWidget(
                            title: _titleController.text.toString(),
                            fontFamily: notesModel.fontFamily.toString(),
                            fontSize: 36.0,
                            fontColor: Colors.white,
                            letterSpacing: 3,
                            fontWeight: null,
                          ),
                        ),
                      ),
                    )
                    : TextFormField(
                      focusNode: _titleFocusNode,
                      autofocus: _focusCursor,
                      // setting min and max lines for Title TextField
                      minLines: 1,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      // setting TextEditing Controller
                      controller: _titleController,
                      style: TextStyle(
                        fontFamily: _selectedFontFamily,
                        fontSize: 36.0,
                        color: Color(0xffffffff),
                        letterSpacing: 3,
                      ),

                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Color(0xffffffff)),
                        border: InputBorder.none,
                      ),
                    )
                : TextFormField(
                  // setting min and max lines for Title TextField
                  minLines: 1,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  // setting TextEditing Controller
                  controller: _titleController,
                  style: TextStyle(
                    fontFamily: _selectedFontFamily,
                    fontSize: 36.0,
                    color: Color(0xffffffff),
                    letterSpacing: 3,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Color(0xffffffff)),
                    border: InputBorder.none,
                  ),
                ),

            SizedBox(height: 16),

            Expanded(
              child:
                  isNoteExist
                      ? _switchViewMode
                          ? Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _focusCursor = true;
                                  _switchViewMode = false;
                                });

                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_noteFocusNode);
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                color: Colors.transparent,
                                child: TextWidget(
                                  title: _notesController.text.toString(),
                                  fontFamily: notesModel.fontFamily.toString(),
                                  fontSize: 20.0,
                                  fontColor: Colors.white,
                                  letterSpacing: 3,
                                  fontWeight: null,
                                ),
                              ),
                            ),
                          )
                          : TextFormField(
                            focusNode: _noteFocusNode,
                            autofocus: _focusCursor,
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            // setting TextEditing Controller
                            controller: _notesController,
                            style: TextStyle(
                              fontFamily: _selectedFontFamily,
                              fontSize: 20.0,
                              color: Color(0xffffffff),
                              letterSpacing: 3,
                            ),

                            decoration: InputDecoration(
                              hintText: 'Type Something...',
                              hintStyle: TextStyle(color: Color(0xffffffff)),
                              border: InputBorder.none,
                            ),
                          )
                      : TextFormField(
                        focusNode: _noteFocusNode,
                        autofocus: _focusCursor,
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        // setting TextEditing Controller
                        controller: _notesController,
                        style: TextStyle(
                          fontFamily: _selectedFontFamily,
                          fontSize: 20.0,
                          color: Color(0xffffffff),
                          letterSpacing: 3,
                        ),

                        decoration: InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(color: Color(0xffffffff)),
                          border: InputBorder.none,
                        ),
                      ),
            ),
          ],
        ),
      ),

      // this button will allow us to save note in hiveDB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          // checking if any of the text field is not Empty
          if (_titleController.text != "" || _notesController.text != "") {
            // checking if we click on a note from NoteList for to Update
            if (isNoteExist) {
              // we call updateData function and send int Index/Key/noteID, and noteModelClass with updated values
              hiveCRUD.updateData(
                index: int.parse(widget.noteID!),
                // colorString: "#${pickedColor.toHexString()}",
                // notesBox: notesBox,
                myNotes: NotesModel(
                  title: _titleController.text,
                  description: _notesController.text,
                  fontFamily: _selectedFontFamily,
                  color: pickedColor,
                ),
              );
              // once our update is complete we have to make noteExist boolean as false
              isNoteExist = false;
              // printing a Toast Message
              toast(
                context: context,
                message: "Note Updated Successfully!",
                isDeleted: false,
              );
              // going back page while remove old cache so fresh new page will be loaded
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homepage',
                (Route<dynamic> route) => false,
              );
            }
            // if we press the Add button and not any note from list then we get empty page to write new note
            else {
              // adding note to DB using addData Function and sending modelClass as parameter/object
              hiveCRUD.addData(
                // notesBox: notesBox,
                myNotes: NotesModel(
                  title: _titleController.text,
                  description: _notesController.text,
                  fontFamily: _selectedFontFamily,
                  color: pickedColor,
                ),
              );

              // printing Success Toast Message
              toast(
                context: context,
                message: "Note Saved Successfully",
                isDeleted: false,
              );
              // going back page while remove old cache so fresh new page will be loaded
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homepage',
                (Route<dynamic> route) => false,
              );
            }
          }
        },
        child: Icon(Icons.save, color: Colors.green, size: 34),
      ),
    );
  }
}
