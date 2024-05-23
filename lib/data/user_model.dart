/* import 'package:mongo_dart/mongo_dart.dart'; */

class UserModel {
  dynamic uid;
  String? nick;
  String? nameSurname;
  String? age;
  String? birthDate;
  String? horoscope;
  String? password;
  int? gem;
  String? fcmToken;

  UserModel(
      {this.nick,
      this.uid,
      this.nameSurname,
      this.age,
      this.birthDate,
      this.horoscope,
      this.password,
      this.gem = 0,
      this.fcmToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nick'] = this.nick;
    data['nameSurname'] = this.nameSurname;
    data['age'] = this.age;
    data['birthDate'] = this.birthDate;
    data['horoscope'] = this.horoscope;
    data['password'] = this.password;
    data['gem'] = this.gem;
    data['fcmToken'] = this.fcmToken;
    data['uid'] = this.uid;

    return data;
  }

  static UserModel parseRegisterModelFromDocument(
      Map<String, dynamic> document) {
    return UserModel(
      uid: document['uid'],
      nick: document['nick'],
      nameSurname: document['nameSurname'],
      age: document['age'],
      birthDate: document['birthDate'],
      horoscope: document['horoscope'],
      password: document['password'],
      gem: document['gem'],
      fcmToken: document['fcmToken'],
    );
  }
}
