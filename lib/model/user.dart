import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String lunchId;

  User({this.id, this.lunchId});

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        lunchId = map['lunch_id'];

  User.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['lunch_id'] = lunchId;

    return map;
  }

  @override
  String toString() => "User<$id:$lunchId>";
}
