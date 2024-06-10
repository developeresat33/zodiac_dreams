import 'package:flutter/material.dart';

BoxDecoration getDecoration() {
  return BoxDecoration(
    color: Color.fromRGBO(30, 33, 37, 1),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
  );
}
