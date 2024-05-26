import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  factory FirebaseAuthService() => _instance;

  FirebaseAuthService._internal();

  User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      return user;
    } catch (e) {
      print('Kullanıcı kayıt hatası: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print('Kullanıcı giriş hatası: $e');
      return null;
    }
  }

  // Kullanıcı çıkış işlemi
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      user = null;
    } catch (e) {
      print('Kullanıcı çıkış hatası: $e');
    }
  }
}
