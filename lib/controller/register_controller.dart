import 'package:flutter/material.dart';

class RegisterController {
  TextEditingController? nickCt;
  TextEditingController? nameSurnameCt;
  TextEditingController? ageCt;
  TextEditingController? horoscopeCt;
  TextEditingController? passwordCt;
  TextEditingController? confirmPasswordCt;

  init() {
    nickCt = TextEditingController();
    nameSurnameCt = TextEditingController();
    ageCt = TextEditingController();
    horoscopeCt = TextEditingController();
    passwordCt = TextEditingController();
    confirmPasswordCt = TextEditingController();
  }
}
