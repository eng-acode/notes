import 'package:flutter/material.dart';

// A dialog widget for selecting fonts from a predefined list
class FontPickerDialog {
  // Callback function that will be called when a font is selected
  final Function(String)? onFontSelected;

  // The BuildContext where the dialog will be displayed
  BuildContext context;

  // The currently selected font family
  String defaultFont;

  // Constructor for FontPickerDialog
  FontPickerDialog({
    required this.context,
    required this.defaultFont,
    this.onFontSelected,
  });

  // List of available Google Fonts for selection within application
  List<String> fontList = [
    'Amatic SC',
    'Comic Neue',
    'Gochi Hand',
    'Indie Flower',
    'Kalam',
    'La Belle Aurore',
    'Pacifico',
    'Patrick Hand SC',
    'Reenie Beanie',
    'Rock Salt',
  ];

  // Displays the font picker dialog with a list of available fonts
  void showFontPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            // Center the title for better visual alignment
            title: Center(child: Text('Pick Your Font')),
            content: SizedBox(
              // Set maximum width to ensure proper layout
              width: double.maxFinite, // Set maximum width
              child: ListView.builder(
                // Enable shrinking to fit content
                shrinkWrap: true,
                itemCount: fontList.length,
                // Builds each list item
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextButton(
                      onPressed: () {
                        // calling the function to return the value
                        onFontSelected?.call(fontList[index].toString());
                        // dismissing the dialog
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        fontList[index],
                        // Display font preview using the actual font
                        style: TextStyle(
                          fontFamily: fontList[index].toString(),
                          fontSize: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
    );
  }
}
