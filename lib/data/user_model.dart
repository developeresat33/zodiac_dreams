class UserModel {
  String? uid;
  String? email;
  String? nameSurname;
  String? age;
  String? horoscope;
  String? password;
  int? gem;
  String? fcmToken;
  bool isExpert;

  UserModel({
    this.email,
    this.isExpert = false, // default olarak false olarak ayarlandı
    this.uid,
    this.nameSurname,
    this.age,
    this.horoscope,
    this.password,
    this.gem = 0,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isExpert': isExpert,
      'nameSurname': nameSurname,
      'age': age,
      'horoscope': horoscope,
      'password': password,
      'gem': gem,
      'fcmToken': fcmToken,
      'uid': uid,
    };
  }

  static UserModel parseRegisterModelFromDocument(
      Map<String, dynamic> document) {
    return UserModel(
      uid: document['uid'],
      isExpert: document['isExpert'] ?? false,
      email: document['email'],
      nameSurname: document['nameSurname'],
      age: document['age'],
      horoscope: document['horoscope'],
      password: document['password'],
      gem: document['gem'],
      fcmToken: document['fcmToken'],
    );
  }
}
