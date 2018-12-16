import 'package:vamos/model/lunch.dart';
import 'package:flutter/material.dart';
import 'package:vamos/detailLunch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List lunchs;

  // @override
  // void initState() {
  //   lunchs = getLunchs();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // ListTile makeListTile(Lunch lunch) => ListTile(
    //       contentPadding:
    //           EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //       leading: Container(
    //         padding: EdgeInsets.only(right: 12.0),
    //         decoration: new BoxDecoration(
    //             border: new Border(
    //                 right: new BorderSide(width: 1.0, color: Colors.white24))),
    //         child: Icon(Icons.autorenew, color: Colors.white),
    //       ),
    //       title: Text(
    //         lunch.name,
    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    //       ),
    //       // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    //       subtitle: Row(
    //         children: <Widget>[
    //           Expanded(
    //               flex: 1,
    //               child: Container(
    //                 // tag: 'hero',
    //                 child: LinearProgressIndicator(
    //                     backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
    //                     value: 1,
    //                     valueColor: AlwaysStoppedAnimation(Colors.green)),
    //               )),
    //           Expanded(
    //             flex: 4,
    //             child: Padding(
    //                 padding: EdgeInsets.only(left: 10.0),
    //                 child: Text(lunch.reference.toString(),
    //                     style: TextStyle(color: Colors.white))),
    //           )
    //         ],
    //       ),
    //       trailing:
    //           Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    //       onTap: () {
    //         // Navigator.push(
    //         //     context,
    //         //     MaterialPageRoute(
    //         //         builder: (context) => DetailPage(lunch: lunch)));
    //       },
    //     );

    // Card makeCard(Lunch lunch) => Card(
    //       elevation: 8.0,
    //       margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    //       child: Container(
    //         decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    //         child: makeListTile(lunch),
    //       ),
    //     );

    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    // final makeBody = Container(
    //   // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
    //   child: ListView.builder(
    //     scrollDirection: Axis.vertical,
    //     shrinkWrap: true,
    //     itemCount: lunchs.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return makeCard(lunchs[index]);
    //     },
    //   ),
    // );

    Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
      final record = Lunch.fromSnapshot(data); 
      return Padding(
        key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(record.name),
            trailing: Text(record.restaurants.toString()),
            onTap: () => print(record),
          ),
        ),
      );
    }

    Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
      );
    }

    Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('lunch').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
    }
    

    

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: _buildBody(context),
      bottomNavigationBar: makeBottom,
    );
  }
}

// List getLunchList(BuildContext context){
//   return StreamBuilder<QuerySnapshot>(
//     stream: Firestore.instance.collection('lunch').snapshots(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) return LinearProgressIndicator();

//       return _buildList(context, snapshot.data.documents);
//     },
//  );
// }

// List getLunchs() {
//   return [
//     Lunch(
//         title: "Introduction to Driving",
//         level: "Beginner",
//         indicatorValue: 0.33,
//         price: 20,
//         content:
//             "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
//     Lunch(
//         title: "Observation at Junctions",
//         level: "Beginner",
//         indicatorValue: 0.33,
//         price: 50,
//         content:
//             "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
//     Lunch(
//         title: "Reverse parallel Parking",
//         level: "Intermidiate",
//         indicatorValue: 0.66,
//         price: 30,
//         content:
//             "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
//     Lunch(
//         title: "Reversing around the corner",
//         level: "Intermidiate",
//         indicatorValue: 0.66,
//         price: 30,
//         content:
//             "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
//     Lunch(
//         title: "Incorrect Use of Signal",
//         level: "Advanced",
//         indicatorValue: 1.0,
//         price: 50,
//         content:
//             "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
//     Lunch(
//         title: "Engine Challenges",
//         level: "Advanced",
//         indicatorValue: 1.0,
//         price: 50,
//         content:
//             "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
//     Lunch(
//         title: "Self Driving Car",
//         level: "Advanced",
//         indicatorValue: 1.0,
//         price: 50,
//         content:
//             "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.  ")
//   ];
// }
