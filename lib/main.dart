import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/dbHelper/mongodb.dart';
import 'package:zodiac_star/screens/splash_screen.dart';
import 'package:zodiac_star/states/home_page_provider.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await MongoDatabase.connect(); 
  await StorageManager.initPrefs();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => HomePageProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          brightness: Brightness.dark,
          primaryColor: Colors.blue[800],
          datePickerTheme: DatePickerThemeData(surfaceTintColor: Colors.blue),
          scaffoldBackgroundColor: Color.fromRGBO(7, 9, 19, 1)),
      home: Scaffold(
        body: SplashScreen()),
    );
  }
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
