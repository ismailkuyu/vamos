import 'package:vamos/model/lunch.dart';
import 'package:flutter/material.dart';
import 'package:vamos/ListPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LunchPage extends StatelessWidget {

  Future<Lunch> createLunch(String name) async {
    Firestore db = Firestore.instance;

    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('lunch_coll').document());

      var dataMap = new Map<String, dynamic>();
      dataMap['name'] = name;

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

  Widget createLunchForm(BuildContext context) {
    String lunchName;
    return new Container(
      padding: new EdgeInsets.all(20.0),
      child: new Form(
        child: new ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
            // TextFormField(
            //   // autofocus: false,
            //   validator: (value) {
            //     if (value.isEmpty) {
            //       return 'Please enter time';
            //     }
            //     lunchName = value;
            //   },
            // ),
            new TextField(
              decoration: const InputDecoration(
                labelText: "Name",
              ),
              onChanged: (String value) {
                lunchName = value;
              },
            ),
            new FloatingActionButton.extended(
              label: Text("Finish"),
              icon: Icon(Icons.done),
              onPressed: () {
                createLunch(lunchName);
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ListPage()));
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Lunch lunch = new Lunch();
    lunch.name = "Name";

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: createLunchForm(context),
      // body: Column(
      //   children: [
      //     TextFormField(
      //       validator: (value) {
      //         if (value.isEmpty) {
      //           return 'Please enter time';
      //         }
      //         lunch.name = value;
      //       },
      //     ),
      //   ],
      // ),
      // floatingActionButton: new FloatingActionButton.extended(
      //   label: Text("Finish"),
      //   icon: Icon(Icons.done),
      //   onPressed: () {
      //     createLunch(lunch.name);
      //   },
      // ),
    );

    // return new ListView.builder(
    //   itemCount: lunch.rests.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return new Container(
    //       padding: const EdgeInsets.all(20.0),
    //       decoration: new BoxDecoration(
    //         border: new Border.all(color: Colors.white),
    //         borderRadius: BorderRadius.circular(5.0)),
    //       child: makeCard(lunch.name, lunch.rests[index])
    //     );
    //   }
    // );
  }
}

// class DetailPage extends StatelessWidget {
//   final Lunch lunch;
//   DetailPage({Key key, this.lunch}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final levelIndicator = Container(
//       child: Container(
//         child: LinearProgressIndicator(
//             backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
//             value: lunch.indicatorValue,
//             valueColor: AlwaysStoppedAnimation(Colors.green)),
//       ),
//     );

//     final coursePrice = Container(
//       padding: const EdgeInsets.all(7.0),
//       decoration: new BoxDecoration(
//           border: new Border.all(color: Colors.white),
//           borderRadius: BorderRadius.circular(5.0)),
//       child: new Text(
//         "\$" + lunch.price.toString(),
//         style: TextStyle(color: Colors.white),
//       ),
//     );

//     final topContentText = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(height: 120.0),
//         Icon(
//           Icons.directions_car,
//           color: Colors.white,
//           size: 40.0,
//         ),
//         Container(
//           width: 90.0,
//           child: new Divider(color: Colors.green),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           lunch.title,
//           style: TextStyle(color: Colors.white, fontSize: 45.0),
//         ),
//         SizedBox(height: 30.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Expanded(flex: 1, child: levelIndicator),
//             Expanded(
//                 flex: 6,
//                 child: Padding(
//                     padding: EdgeInsets.only(left: 10.0),
//                     child: Text(
//                       lunch.level,
//                       style: TextStyle(color: Colors.white),
//                     ))),
//             Expanded(flex: 1, child: coursePrice)
//           ],
//         ),
//       ],
//     );

//     final topContent = Stack(
//       children: <Widget>[
//         Container(
//             padding: EdgeInsets.only(left: 10.0),
//             height: MediaQuery.of(context).size.height * 0.5,
//             decoration: new BoxDecoration(
//               image: new DecorationImage(
//                 image: new AssetImage("drive-steering-wheel.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             )),
//         Container(
//           height: MediaQuery.of(context).size.height * 0.5,
//           padding: EdgeInsets.all(40.0),
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
//           child: Center(
//             child: topContentText,
//           ),
//         ),
//         Positioned(
//           left: 8.0,
//           top: 60.0,
//           child: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back, color: Colors.white),
//           ),
//         )
//       ],
//     );

//     final bottomContentText = Text(
//       lunch.content,
//       style: TextStyle(fontSize: 18.0),
//     );
//     final readButton = Container(
//         padding: EdgeInsets.symmetric(vertical: 16.0),
//         width: MediaQuery.of(context).size.width,
//         child: RaisedButton(
//           onPressed: () => {},
//           color: Color.fromRGBO(58, 66, 86, 1.0),
//           child:
//               Text("TAKE THIS LESSON", style: TextStyle(color: Colors.white)),
//         ));
//     final bottomContent = Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.all(40.0),
//       child: Center(
//         child: Column(
//           children: <Widget>[bottomContentText, readButton],
//         ),
//       ),
//     );

//     return Scaffold(
//       body: Column(
//         children: <Widget>[topContent, bottomContent],
//       ),
//     );
//   }
// }
