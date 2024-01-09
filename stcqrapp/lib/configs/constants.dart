import 'package:flutter/material.dart';

class Constants {
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;
}

enum Grading { A, B, C }

enum SearchMethod { visibleMaterialNumber, qr }
