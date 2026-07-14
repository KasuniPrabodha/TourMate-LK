import 'package:flutter/material.dart';

class CategoryModel {
  final String title;
  final Color squareColor;
  final Color iconColor;
  final IconData myIcon;

  CategoryModel({
    required this.title,
    required this.squareColor,
    required this.iconColor,
    required this.myIcon,
  });

  // Later, when categories come from Firestore, icon/color can't be stored
  // directly (Firestore only stores primitives), so you'd map an icon "key"
  // string (e.g. "eco", "pets") to an IconData using a lookup map, and store
  // colors as hex strings (e.g. "#F1B7CA") converted with Color(int.parse(...)).
  // fromMap()/toMap() would go here once that's needed.
}