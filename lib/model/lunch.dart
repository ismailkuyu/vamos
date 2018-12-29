import 'package:cloud_firestore/cloud_firestore.dart';


class Lunch {
  String id;
  DateTime date;
  num vote;
  Lunch({this.id, this.date, this.vote});
      
  Lunch.fromMap(Map<String, dynamic> map)
       :date = map['date'],
       id = map['id'],
       vote = map['vote'];

  Lunch.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data);

Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['date'] = date;
    map['vote'] = vote;
 
    return map;
  }
  
 @override
 String toString() => "Lunch<$date:$vote>";
}