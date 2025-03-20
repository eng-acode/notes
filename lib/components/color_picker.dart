import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// A dialog widget for selecting colors from a predefined palette
class ColorPickerDialog {
  // Callback function that will be called when a color is selected
  // Parameters: (Color, bool) - the selected color and selection status
  final Function(Color, bool)? onColorSelected;

  BuildContext context;

  // The currently selected color
  Color pickedColor;
  // Flag indicating if a color has been selected
  bool isColorSelected;

  // Constructor for ColorPickerDialog
  ColorPickerDialog({
    required this.context,
    required this.pickedColor,
    required this.isColorSelected,
    this.onColorSelected,
  });

  // Builds the color picker widget with a predefined color palette
  // Color Picker Dialog and Function
  Widget buildColorPicker() => BlockPicker(
    // The currently selected color to display in the picker
    pickerColor: pickedColor,
    // Predefined palette of colors to choose from
    availableColors: [
      Color(0xffee7ead),
      Color(0xffffa9ba),
      Color(0xffea7d70),
      Color(0xfff69f95),
      Color(0xffffaf6e),
      Color(0xffffcc80),
      Color(0xffbcc07b),
      Color(0xffdbe098),
      Color(0xff7d8be0),
      Color(0xffb5bef5),
      Color(0xffabcdde),
      Color(0xffd5e2d3),
      Color(0xff9a81b0),
      Color(0xffcdbdeb),
      Color(0xff8e715b),
      Color(0xffc9a98d),
    ],

    // Callback function when a color is selected
    onColorChanged: (color) {
      // Update selection status and color
      isColorSelected = true;
      pickedColor = color;
      // Notify parent widget of color selection - send back values so we can set them in UI
      onColorSelected?.call(pickedColor, isColorSelected);
      // dismissing Dialog Box once Color is Selected
      Navigator.of(context).pop();
    },
  );

  // Shows the color picker dialog
  void showColorPicker() {
    showDialog(
      // Prevent dialog from being dismissed by tapping outside
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Pick Your Color'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [buildColorPicker()],
            ),
          ),
    );
  }
}
