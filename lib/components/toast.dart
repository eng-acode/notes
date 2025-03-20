import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// creating a Toat Message using Toastification Package using context and message as required/dynamic fields
void toast({required context, required message, isDeleted}) {
  Toastification().show(
    context: context,
    autoCloseDuration: Duration(milliseconds: 2000),
    // time how long toast will appear on screen
    type: ToastificationType.success,
    // Toast Type Success
    title: Text(message),
    // title property is where our Message will be displayed
    icon: isDeleted ? Icon(Icons.delete, color: Colors.red) : Icon(Icons.check),
    // Adding Icon check as Success Notification
    alignment: Alignment.bottomCenter, // Alignment is location of our Toast
  );
}
