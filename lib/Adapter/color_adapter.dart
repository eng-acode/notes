import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'color_adapter.g.dart';

@HiveType(typeId: 2)
class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 2;

  @override
  Color read(BinaryReader reader) {
    final int value = reader.read();
    return Color(value);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.write(obj.toARGB32());
  }
}
