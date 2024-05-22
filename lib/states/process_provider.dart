import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/data/request_model.dart';
import 'package:zodiac_star/dbHelper/mongodb.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class ProcessProvider extends ChangeNotifier {
  RequestModel? requestModel;

  Future<List<Map<String, dynamic>>> getMyRequest() async {
    var userprop = Provider.of<UserProvider>(Get.context!, listen: false);
    return await MongoDatabase.requesDreamsCollection
        .find(where.eq('sender', userprop.userModel!.nick))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getExpertRequest() async {
    var userprop = Provider.of<UserProvider>(Get.context!, listen: false);
    log(userprop.expertModel!.expertUsername!.toString());
    return await MongoDatabase.requesDreamsCollection
        .find(where.eq('receive', userprop.expertModel!.expertUsername))
        .toList();
  }

  Future<void> addRequest(String? comment) async {
    onLoading(false);
    try {
      requestModel!.comment = comment;
      requestModel!.reply = '';

      final maxRequestIdDocument = await MongoDatabase.requesDreamsCollection
          .find(where.sortBy('request_id', descending: true).limit(1))
          .toList();

      int newRequestId = 1;
      if (maxRequestIdDocument.isNotEmpty) {
        newRequestId = maxRequestIdDocument.first['request_id'] + 1;
      }

      requestModel!.request_id = newRequestId;

      await MongoDatabase.requesDreamsCollection.insert(requestModel!.toJson());
      onLoading(true);
      GetMsg.showMsg("Talebiniz eklendi", option: 1);
    } on Exception catch (e) {
      GetMsg.showMsg(e.toString(), option: 0);
      onLoading(true);
      print(e.toString());
    }
  }
}
