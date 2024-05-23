import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/screens/splash_screen.dart';
import 'package:zodiac_star/states/expression_provider.dart';
import 'package:zodiac_star/states/home_page_provider.dart';
import 'package:zodiac_star/states/process_provider.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/storage_manager.dart';

FirebaseMessaging? messaging;
bool? isRemind;
bool? isExpert;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await StorageManager.initPrefs();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProcessProvider()),
    ChangeNotifierProvider(create: (_) => ExpressionProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => HomePageProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _init();

    super.initState();
  }

  _init() async {
    try {
      if (StorageManager.getBool("isRemind") != null) {
        isRemind = StorageManager.getBool("isRemind");
        print(isRemind);
        context.read<UserProvider>().rememberMe = isRemind!;
      }
    } catch (e) {
      print(e);
      isRemind = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('tr', 'TR'),
      ],
      locale: const Locale('tr', 'TR'),
      
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.openSans().fontFamily,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.blue[600]!,
            onSecondary: Colors.white,
            onPrimary: Colors.white,
          ),
          scaffoldBackgroundColor: Color.fromRGBO(34, 40, 49, 1)),
      home: Scaffold(body: SplashScreen()),
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
