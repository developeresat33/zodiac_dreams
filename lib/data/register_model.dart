class UserModel {
  String? nick;
  String? nameSurname;
  String? age;
  String? birthDate;
  String? horoscope;
  String? password;
  int? gem;
  UserModel(
      {this.nick,
      this.nameSurname,
      this.age,
      this.birthDate,
      this.horoscope,
      this.password,
      this.gem = 0});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nick'] = this.nick;
    data['nameSurname'] = this.nameSurname;
    data['age'] = this.age;
    data['birthDate'] = this.birthDate;
    data['horoscope'] = this.horoscope;
    data['password'] = this.password;
    data['gem'] = this.gem;
    return data;
  }

  static UserModel parseRegisterModelFromDocument(
      Map<String, dynamic> document) {
    return UserModel(
      nick: document['nick'],
      nameSurname: document['nameSurname'],
      age: document['age'],
      birthDate: document['birthDate'],
      horoscope: document['horoscope'],
      password: document['password'],
      gem: document['gem'],
    );
  }
}
