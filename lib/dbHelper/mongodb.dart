import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:zodiac_star/dbHelper/constant.dart';

class MongoDatabase {
  static var db, userCollection, favCollection, dreamTitlesCollection, dreamCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();

    userCollection = db.collection(USER_COLLECTION);
    favCollection = db.collection(FAV_COLLECTION);
    dreamTitlesCollection = db.collection(DREAM_TITLE_COLLECTION);
    dreamCollection = db.collection(DREAM_COLLECTION);
    inspect(dreamTitlesCollection);
  }
}
