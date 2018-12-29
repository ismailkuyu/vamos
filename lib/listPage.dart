import 'package:vamos/model/lunch.dart';
import 'package:flutter/material.dart';
import 'package:vamos/model/user.dart';
import 'package:vamos/LunchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:device_id/device_id.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Firestore db = Firestore.instance;
  Lunch votedLunch;

  createUser() async {
    String deviceId = await DeviceId.getID;

    DocumentReference userRef = db.collection('user').document(deviceId);

    userRef.get()
      .then((docSnapshot) {
        if (!docSnapshot.exists) {
          var dataMap = new Map<String, dynamic>();
          dataMap['id'] = deviceId;
          dataMap['lunch_id'] = "";
          userRef.setData(dataMap); // create the document
        }
    });
  }


  Future<dynamic> getLunch(String id) async {
    final TransactionHandler getTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('lunch').document(id));

      return ds;
    };

    return Firestore.instance
        .runTransaction(getTransaction)
        .then((result) => votedLunch)
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Future<dynamic> updateLunch(Lunch lunch) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('lunch').document(lunch.id));

      await tx.update(ds.reference, lunch.toMap());
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

    
  // Future<dynamic> updateUser(String lunchId) async {
  //   String deviceId = await DeviceId.getID;
  //   final TransactionHandler updateTransaction = (Transaction tx) async {
  //     final DocumentSnapshot ds =
  //         await tx.get(db.collection('user').document(deviceId));

  //     ds.data.update

  //     await tx.update(ds.reference, lunch.toMap());
  //     return {'updated': true};
  //   };

  //   return Firestore.instance
  //       .runTransaction(updateTransaction)
  //       .then((result) => result['updated'])
  //       .catchError((error) {
  //     print('error: $error');
  //     return false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    createUser();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMM yyyy').format(now);
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(formattedDate),
    );

    String getFormatted(int n) {
      return n < 10 ? "0" + n.toString() : n.toString();
    }

    Color getColor(Lunch lunch) {
      Color c;
      if (votedLunch == null){
        c = Color.fromRGBO(64, 75, 96, .9);
      } else if (votedLunch.id == lunch.id) {
        c = Colors.orange;
      } else {
        c = Color.fromRGBO(64, 75, 96, .9);
      }

      return c;
    }

    Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
      final lunch = Lunch.fromSnapshot(data);
      DateTime date = lunch.date;

      return Padding(
        key: ValueKey(lunch.date),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
            color: getColor(lunch),
          ),
          child: ListTile(
              title: Text(
                  getFormatted(date.hour) + ":" + getFormatted(date.minute),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              trailing: Text("Votes: " + lunch.vote.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                if (votedLunch.id != lunch.id) {
                  votedLunch.vote--;
                  updateLunch(votedLunch);
                }
                lunch.vote++;
                updateLunch(lunch);
                votedLunch = lunch;
                // updateUser(lunch.id);
              }
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => DetailPage(lunch: lunch)));
              // }

              // subtitle: getRests(lunch.rests),
              // subtitle: makeList(lunch.rests),
              // children: getRests(lunch.rests)
              // children: <Widget>[
              // Expanded(
              //     flex: 1,
              //     child: Container(
              //       // tag: 'hero',
              //       child: LinearProgressIndicator(
              //           backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
              //           value: 1,
              //           valueColor: AlwaysStoppedAnimation(Colors.green)),
              //     )),
              // Expanded(
              //   flex: 4,
              //   child: Padding(
              //       padding: EdgeInsets.only(left: 10.0),
              //       child: Text(lunch.name.toString(),
              //           style: TextStyle(color: Colors.white))),
              // )
              // ],
              ),
          // trailing: Text(lunch.rests.toString()),
          //   onTap: () => print(lunch),
          // ),
        ),
      );
    }

    Widget _buildLunchList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
      );
    }

    Widget _buildBody(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('lunch')
            .orderBy("date")
            .where("date", isGreaterThanOrEqualTo: DateTime.now())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildLunchList(context, snapshot.data.documents);
        },
      );
    }

    // final makeBottom = Container(
    //   height: 55.0,
    //   child: BottomAppBar(
    //     color: Color.fromRGBO(58, 66, 86, 1.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.home, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.blur_on, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.hotel, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.account_box, color: Colors.white),
    //           onPressed: () {},
    //         )
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,

      body: _buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LunchPage()));
        },
        icon: Icon(Icons.add),
        label: Text("Lunch"),
      ),
      // bottomNavigationBar: makeBottom,
    );
  }
}