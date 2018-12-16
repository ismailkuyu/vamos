import 'package:cloud_firestore/cloud_firestore.dart';


class Lunch {
  String name;
  String time;
  // String level;
  // double indicatorValue;
  // int price;
  // String content;
  List<dynamic> rests;
  // final DocumentReference reference;

  // Lunch(
  //     {this.title, this.level, this.indicatorValue, this.price, this.content, this.date, this.time, this.reference});
  Lunch(
      {this.name, this.time, this.rests});//, this.reference});

      
  Lunch.fromMap(Map<String, dynamic> map)//, {this.reference})
     : assert(map['name'] != null),
       name = map['name'],
       rests = map['rests'],
       time = map['time'];

  // Lunch.fromSnapshot(DocumentSnapshot snapshot)
  //    : this.fromMap(snapshot.data, reference: snapshot.reference);

  Lunch.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data);

  
 @override
 String toString() => "Lunch<$name:$rests>";
}