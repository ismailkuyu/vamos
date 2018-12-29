import 'package:flutter/material.dart';
import 'package:vamos/listPage.dart';
import 'package:vamos/model/lunch.dart';
import 'package:device_id/device_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  static Firestore db2 = Firestore.instance;
  static Future<Lunch> getInitialLunch() async {
    String deviceId = await DeviceId.getID;

    DocumentReference userRef = db2.collection('user').document(deviceId);

    userRef.get().then((userDS) {
      if (userDS.exists) {
        DocumentReference lunchRef =
            db2.collection('lunch').document(userDS.data['lunch_id']);
        lunchRef.get().then((lunchDS) {
          if (lunchDS.exists) {
            var dataMap = lunchDS.data;
            return Lunch.fromMap(dataMap);
          }
        });
      }
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VAMOS!"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Lunch", Icons.file_upload),
            makeDashboardItem("Game", Icons.gamepad),
            makeDashboardItem("Coffee", Icons.local_cafe),
            makeDashboardItem("Beer", Icons.local_drink),
            makeDashboardItem("User Info", Icons.verified_user)
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  String lunchId;
                  Future<Lunch> fLunch = getInitialLunch();
                  fLunch.then((Lunch l) {
                    if(l != null){
                      lunchId = l.id;
                    } else{
                      lunchId = "not selected";
                    }
                    });
                  return ListPage(title: lunchId);
                }),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}
