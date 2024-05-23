/* import 'package:mongo_dart/mongo_dart.dart'; */

class ExpertModel {
/*   ObjectId? id; */
  dynamic uid;
  String? expertUsername;
  String? expertName;
  String? expertPw;
  String? fcmToken;
  ExpertModel({
    this.expertUsername,
    this.expertName,
    this.expertPw,
    this.fcmToken,
    this.uid,
/*     this.id, */
  });

  static ExpertModel parseRegisterModelFromDocument(
      Map<String, dynamic> document) {
    return ExpertModel(
/*       id: document['_id'], */
      uid: document['uid'],
      expertUsername: document['expert_username'],
      expertName: document['expert_name'],
      expertPw: document['expert_pw'],
      fcmToken: document['fcmToken'],
    );
  }
}
