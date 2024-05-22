import 'package:mongo_dart/mongo_dart.dart';

class ExpertModel {
  ObjectId? id;
  String? expertUsername;
  String? expertName;
  String? expertPw;
  String? fcmToken;
  ExpertModel({
    this.expertUsername,
    this.expertName,
    this.expertPw,
    this.fcmToken,
    this.id,
  });

  static ExpertModel parseRegisterModelFromDocument(
      Map<String, dynamic> document) {
    return ExpertModel(
      id: document['_id'],
      expertUsername: document['expert_username'],
      expertName: document['expert_name'],
      expertPw: document['expert_pw'],
      fcmToken: document['fcmToken'],
    );
  }
}
