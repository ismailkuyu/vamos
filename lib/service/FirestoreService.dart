import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_id/device_id.dart';
import 'package:vamos/model/lunch.dart';
import 'package:vamos/model/user.dart';

class FirestoreService {

  static Firestore db = Firestore.instance;

  static Future<User> createUser(String userId) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('user').document(userId));

      if (!ds.exists) {
        var dataMap = new Map<String, dynamic>();
        dataMap['id'] = userId;
        dataMap['lunch_id'] = "not selected";
        await tx.set(ds.reference, dataMap);
        return dataMap;
      } else {
        return ds.data;
      }
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return User.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  static Future<dynamic> updateUser(String lunchId) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot dsUser =
          await tx.get(db.collection('user').document(await DeviceId.getID));
      var dataUser = dsUser.data;
      dataUser['lunch_id'] = lunchId;
      await tx.update(dsUser.reference, dataUser);
      return;
    };

    return db
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  static Future<dynamic> updateLunch(Lunch lunch) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot dsLunch =
          await tx.get(db.collection('lunch').document(lunch.id));

      await tx.update(dsLunch.reference, lunch.toMap());
      return {'updated': true};
    };

    return db
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  static Stream getBodyStream() {
    return db
        .collection('lunch')
        .orderBy("date")
        .where("date", isGreaterThanOrEqualTo: DateTime.now())
        .snapshots();
  }


  static Future<Lunch> getLunch(String lunchId) async {
    final TransactionHandler getTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('lunch').document(lunchId));
      return ds.data;
    };

    return Firestore.instance.runTransaction(getTransaction).then((mapData) {
      return Lunch.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  static Future<Lunch> createLunch(DateTime date) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('lunch').document());

      var dataMap = new Map<String, dynamic>();
      dataMap['id'] = ds.documentID;
      dataMap['date'] = date;
      dataMap['vote'] = 1;

      await tx.set(ds.reference, dataMap);

      return dataMap;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Lunch.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
}
// lesson-learnt

  // static Future<User> createUser(User user) {
  //   // String deviceId = await DeviceId.getID;

  //   DocumentReference userRef = db.collection('user').document(user.id);
  //   Future<User> fUser;
  //   userRef.get().then((docSnapshot) {
  //     if (!docSnapshot.exists) {
  //       var dataMap = new Map<String, dynamic>();
  //       dataMap['id'] = user.id;
  //       dataMap['lunch_id'] = "not selected";
  //       userRef.setData(dataMap);
  //       return User.fromSnapshot(docSnapshot);
  //       // user = User.fromSnapshot(docSnapshot);
  //     }
  //   });

  //   return fUser;
  // }

  // static Future<User> createUser2(User user) {
  //   final TransactionHandler createTransaction = (Transaction tx) async {
  //     final DocumentSnapshot ds =
  //         await tx.get(db.collection('user').document(user.id));

  //     if (!ds.exists) {
  //       var dataMap = new Map<String, dynamic>();
  //       dataMap['id'] = user.id;
  //       dataMap['lunch_id'] = user.lunchId;
  //       await tx.set(ds.reference, dataMap);
  //       return dataMap;
  //     } else {
  //       return ds.data;
  //     }
  //   };

  //   return Firestore.instance.runTransaction(createTransaction).then((mapData) {
  //     return User.fromMap(mapData);
  //   }).catchError((error) {
  //     print('error: $error');
  //     return null;
  //   });
  // }


  // static Future<Lunch> getLunch2(String lunchId) async {
  //   DocumentReference lunchRef = db.collection('lunch').document(lunchId);
  //   lunchRef.get().then((lunchDS) {
  //     if (lunchDS.exists) {
  //       return Lunch.fromSnapshot(lunchDS);
  //     }
  //   });
  // }

  // static Future<Lunch> getLunch(String lunchId) async {
  //   final TransactionHandler getTransaction = (Transaction transaction) async {
  //     final DocumentSnapshot ds =
  //         await transaction.get(db.collection('lunch').document(lunchId));

  //     return ds;
  //   };

  //   return db
  //       .runTransaction(getTransaction)
  //       .then((result) => Lunch.fromMap(result))
  //       .catchError((error) {
  //     print('error: $error');
  //     return false;
  //   });
  // }

  // static Future<User> getUser() async {
  //   String deviceId = await DeviceId.getID;
  //   DocumentReference userRef = db.collection('user').document(deviceId);
  //   userRef.get().then((userDS) {
  //     if (userDS.exists) {
  //       return User.fromSnapshot(userDS);
  //     }
  //   });
  // }

  // static Future<User> getUser() async {
  //   String deviceId = await DeviceId.getID;
  //   final TransactionHandler getTransaction = (Transaction tx) async {
  //     final DocumentSnapshot ds =
  //         await tx.get(db.collection('user').document(deviceId));

  //     return ds;
  //   };

  //   return db
  //       .runTransaction(getTransaction)
  //       .then((result) => User.fromMap(result))
  //       .catchError((error) {
  //     print('error: $error');
  //     return false;
  //   });
  // }
