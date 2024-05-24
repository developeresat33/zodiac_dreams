import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zodiac_star/data/request_model.dart';
import 'package:zodiac_star/dbHelper/firebase.dart';
import 'package:zodiac_star/services/notification_service.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class ProcessProvider extends ChangeNotifier {
  RequestModel? requestModel;
  bool? isList = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRequest(
    String? comment,
  ) async {
    onLoading(false);
    try {
      requestModel!.comment = comment;
      requestModel!.reply = "";
      requestModel!.created_at = DateTime.now();

      DocumentReference senderDocRef = await _firestore
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.sender_uid!)
          .collection(FirebaseConstant.dreamRequestCollection)
          .add(requestModel!.toJson());

      DocumentReference expertDocRef = await _firestore
          .collection(FirebaseConstant.expertAccountCollection)
          .doc(requestModel!.receive_uid!)
          .collection(FirebaseConstant.dreamRequestCollection)
          .add(requestModel!.toJson());

      await senderDocRef.update({'request_uid': senderDocRef.id});
      await expertDocRef.update({'request_uid': senderDocRef.id});
      await alertMaster();
      onLoading(true);
      GetMsg.showMsg("Talebiniz eklendi", option: 1);
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);
      onLoading(true);
      print(e.toString());
    }
  }

  Future<void> alertMaster() async {
    try {
      DocumentSnapshot expertSnapshot = await _firestore
          .collection('expert_account')
          .where('uid', isEqualTo: requestModel!.receive_uid)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      var fcmToken = expertSnapshot.get('fcmToken');

      CloudNotificationService.sendNotification(
          "Uyarı", "Talep var.", fcmToken, true);
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);
      onLoading(true);
      print(e.toString());
    }
  }

  Future<void> alertUser() async {
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: requestModel!.sender_uid)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      var fcmToken = userSnapshot.get('fcmToken');

      CloudNotificationService.sendNotification(
          "Uyarı", "Talebiniz yorumlandı.", fcmToken, false);
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);
      onLoading(true);
      print(e.toString());
    }
  }

  Future<void> replyRequest(
    String? comment,
  ) async {
    onLoading(false);

    inspect(requestModel);

    try {
      QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.sender_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      QuerySnapshot querySnapshotExpert = await FirebaseFirestore.instance
          .collection(FirebaseConstant.expertAccountCollection)
          .doc(requestModel!.receive_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      if (querySnapshotUser.docs.isNotEmpty) {
        var doc = querySnapshotUser.docs.first;

        await doc.reference.update({
          'isFinish': true,
          'reply': comment,
        });
      }

      if (querySnapshotExpert.docs.isNotEmpty) {
        var doc = querySnapshotExpert.docs.first;

        await doc.reference.update({
          'isFinish': true,
          'reply': comment,
        });
      }
      await alertUser();
      GetMsg.showMsg("Yorum gönderildi.", option: 1);

      onLoading(true);
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);

      onLoading(true);
    }
  }
}
