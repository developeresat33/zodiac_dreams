import 'package:flutter/material.dart';

extension IntExtensions on int {
  //Kısayol olarak integer genişlik ve uzunluk belirlemek için yazılmış olan bir extension.
  /// return SizedBox(height: [this])
  Widget get h {
    // ignore: unnecessary_this
    return SizedBox(height: this.toDouble());
  }

  /// return SizedBox(width: [this])
  Widget get w {
    // ignore: unnecessary_this
    return SizedBox(width: this.toDouble());
  }

  /// Create [this] * [this] square
  /// return SizedBox(width: [this], height: [this])
  Widget get square {
    // ignore: unnecessary_this
    return SizedBox(height: this.toDouble(), width: this.toDouble());
  }
}
