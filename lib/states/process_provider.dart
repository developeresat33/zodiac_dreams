import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zodiac_star/data/request_model.dart';
import 'package:zodiac_star/dbHelper/firebase.dart';
import 'package:zodiac_star/services/firebase_message.dart';
import 'package:zodiac_star/utils/functions.dart';
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
      requestModel!.question = "";
      requestModel!.replyQuestion = "";
      requestModel!.created_at = Functions.getPSTTime();

      DocumentReference senderDocRef = await _firestore
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.sender_uid!)
          .collection(FirebaseConstant.dreamRequestCollection)
          .add(requestModel!.toJson());

      DocumentReference expertDocRef = await _firestore
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.receive_uid!)
          .collection(FirebaseConstant.dreamRequestCollection)
          .add(requestModel!.toJson());

      await senderDocRef.update({'request_uid': senderDocRef.id});
      await expertDocRef.update({'request_uid': senderDocRef.id});
      await alertMaster("Talep var.");
      onLoading(true);
      GetMsg.showMsg("Talebiniz eklendi", option: 1);
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);
      onLoading(true);
      print(e.toString());
    }
  }

  Future<void> voteRequest(double rating) async {
    onLoading(false);
    try {
      QuerySnapshot getExpert = await FirebaseFirestore.instance
          .collection(FirebaseConstant.expertCollection)
          .where('expert_name', isEqualTo: requestModel!.receiveName)
          .get();
      if (getExpert.docs.isNotEmpty) {
        var doc = getExpert.docs.first;
        var data = doc.data() as Map<String, dynamic>;

        double currentRate = data['rate'] ?? 0.0;
        int voteCount = data['vote_count'] ?? 0;

        double newRate = ((currentRate * voteCount) + rating) / (voteCount + 1);

        await FirebaseFirestore.instance
            .collection(FirebaseConstant.expertCollection)
            .doc(doc.id)
            .update({
          'rate': newRate,
          'vote_count': voteCount + 1,
        });
      }

      QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.sender_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      QuerySnapshot querySnapshotExpert = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.receive_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      if (querySnapshotUser.docs.isNotEmpty) {
        var doc = querySnapshotUser.docs.first;

        await doc.reference.update({'isRated': true, 'rate': rating});
      }

      if (querySnapshotExpert.docs.isNotEmpty) {
        var doc = querySnapshotExpert.docs.first;

        await doc.reference.update({'isRated': true, 'rate': rating});
      }
      onLoading(true);
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);
      onLoading(true);
      print(e.toString());
    }
  }

  Future<void> alertMaster(String msg) async {
    inspect(requestModel);
    try {
      DocumentSnapshot expertSnapshot = await _firestore
          .collection(FirebaseConstant.userCollection)
          .where('uid', isEqualTo: requestModel!.receive_uid)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      var fcmToken = expertSnapshot.get('fcmToken');
      print(fcmToken);
      FirebaseMessagingHelper.sendNotification(
        "Uyarı",
        msg,
        fcmToken,
      );
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);
      onLoading(true);
      print(e.toString());
    }
  }

  Future<void> alertUser(String msg) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection(FirebaseConstant.userCollection)
          .where('uid', isEqualTo: requestModel!.sender_uid)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      var fcmToken = userSnapshot.get('fcmToken');

      FirebaseMessagingHelper.sendNotification(
        "Uyarı",
        msg,
        fcmToken,
      );
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

    try {
      QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.sender_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      QuerySnapshot querySnapshotExpert = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
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
      await alertUser("Talebiniz yorumlandı.");
      GetMsg.showMsg("Yorum gönderildi.", option: 1);

      onLoading(true);
    } catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);

      onLoading(true);
    }
  }

  Future<void> replyQuestion(
    String answer,
  ) async {
    onLoading(false);
    try {
      QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.sender_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      QuerySnapshot querySnapshotExpert = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.receive_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      if (querySnapshotUser.docs.isNotEmpty) {
        var doc = querySnapshotUser.docs.first;

        await doc.reference.update({
          'isFinish': true,
          'reply_question': answer,
        });
      }

      if (querySnapshotExpert.docs.isNotEmpty) {
        var doc = querySnapshotExpert.docs.first;

        await doc.reference.update({
          'isFinish': true,
          'reply_question': answer,
        });
      }
      onLoading(true);
      await alertUser("Sorunuz yanıtlandı.");
      GetMsg.showMsg("Yanıtınız gönderildi.", option: 1);
    } on Exception catch (e) {
      onLoading(true);
      GetMsg.showMsg(e.toString(), option: 0);
      print(e);
    }
  }

  Future<void> askQuestion(String newQuestion) async {
    onLoading(false);
    try {
      QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.sender_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      QuerySnapshot querySnapshotExpert = await FirebaseFirestore.instance
          .collection(FirebaseConstant.userCollection)
          .doc(requestModel!.receive_uid)
          .collection(FirebaseConstant.dreamRequestCollection)
          .where('request_uid', isEqualTo: requestModel!.request_uid)
          .get();

      if (querySnapshotUser.docs.isNotEmpty) {
        var doc = querySnapshotUser.docs.first;

        await doc.reference.update({
          'isFinish': false,
          'isQuestionAsked': true,
          'question': newQuestion,
        });
      }

      if (querySnapshotExpert.docs.isNotEmpty) {
        var doc = querySnapshotExpert.docs.first;

        await doc.reference.update({
          'isFinish': false,
          'isQuestionAsked': true,
          'question': newQuestion,
        });
      }
      onLoading(true);
      await alertMaster("Soru var.");
      GetMsg.showMsg("Sorunuz gönderildi.", option: 1);
    } catch (e) {
      onLoading(true);
      GetMsg.showMsg(e.toString(), option: 0);
      print(e);
    }
  }

  Future<void> removeRequest(bool isExpert) async {
    QuerySnapshot? querySnapshotUser;
    QuerySnapshot? querySnapshotExpert;
    onLoading(false);

    try {
      if (isExpert) {
        querySnapshotExpert = await FirebaseFirestore.instance
            .collection(FirebaseConstant.userCollection)
            .doc(requestModel!.receive_uid)
            .collection(FirebaseConstant.dreamRequestCollection)
            .where('request_uid', isEqualTo: requestModel!.request_uid)
            .get();

        for (var doc in querySnapshotExpert.docs) {
          await FirebaseFirestore.instance
              .collection(FirebaseConstant.userCollection)
              .doc(requestModel!.receive_uid)
              .collection(FirebaseConstant.dreamRequestCollection)
              .doc(doc.id)
              .delete();
        }
      } else {
        querySnapshotUser = await FirebaseFirestore.instance
            .collection(FirebaseConstant.userCollection)
            .doc(requestModel!.sender_uid)
            .collection(FirebaseConstant.dreamRequestCollection)
            .where('request_uid', isEqualTo: requestModel!.request_uid)
            .get();

        for (var doc in querySnapshotUser.docs) {
          await FirebaseFirestore.instance
              .collection(FirebaseConstant.userCollection)
              .doc(requestModel!.sender_uid)
              .collection(FirebaseConstant.dreamRequestCollection)
              .doc(doc.id)
              .delete();
        }
      }
      onLoading(true);
      Get.back();
    } catch (e) {
      onLoading(true);
      print(e);
    }
  }
}
