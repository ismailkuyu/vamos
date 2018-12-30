import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_id/device_id.dart';
import 'package:vamos/model/lunch.dart';

class FirestoreService {
  static Firestore db = Firestore.instance;
  static CollectionReference usersRef = db.collection('user');

  static Future<Lunch> getInitialLunch() async {
    String deviceId = await DeviceId.getID;

    DocumentReference userRef = usersRef.document(deviceId);
    Future<DocumentSnapshot> userDS = userRef.get();
    userRef.get().then((userDS) {
      if (userDS.exists) {
        DocumentReference lunchRef =
            db.collection('lunch').document(userDS.data['lunch_id']);
        lunchRef.get().then((lunchDS) {
          if (lunchDS.exists) {
            var dataMap = lunchDS.data;
            return Lunch.fromMap(dataMap);
          }
        });
      }
    }).catchError((error) {
      print('error: $error');
      return false;
    });

    return null;
  }

  static validateUser() async {
    String deviceId = await DeviceId.getID;

    DocumentReference userRef = usersRef.document(deviceId);
    userRef.get().then((docSnapshot) {
      if (!docSnapshot.exists) {
        var dataMap = new Map<String, dynamic>();
        dataMap['id'] = deviceId;
        dataMap['lunch_id'] = "not selected";
        userRef.setData(dataMap);
        return null;
      }
    });
  }

  Future<Lunch> getLunch(String id) async {
    final TransactionHandler getTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('lunch').document(id));

      return ds;
    };

    return db
        .runTransaction(getTransaction)
        .then((result) => Lunch.fromMap(result))
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  static Future<dynamic> updateLunch(Lunch lunch) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot dsLunch =
          await tx.get(db.collection('lunch').document(lunch.id));
      final DocumentSnapshot dsUser =
          await tx.get(db.collection('user').document(await DeviceId.getID));
      var dataUser = dsUser.data;
      dataUser['lunch_id'] = lunch.id;

      await tx.update(dsLunch.reference, lunch.toMap());
      await tx.update(dsUser.reference, dataUser);
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
}
