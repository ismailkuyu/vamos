import 'package:vamos/model/lunch.dart';
import 'package:flutter/material.dart';
import 'package:vamos/LunchPage.dart';
import 'package:intl/intl.dart';
import 'package:vamos/service/FirestoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vamos/stateContainer.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.lunch}) : super(key: key);

  final Lunch lunch;

  @override
  _ListPageState createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  static const Color defaultColor = Color.fromRGBO(64, 75, 96, .9);
  static const Color orangeColor = Colors.orange;

  // static Lunch votedLunch;

  // @override
  // void initState() {
  //   super.initState();
  // }

  toggleSelection(Lunch newLunch) {
    final container = StateContainer.of(context);
    var prevSelectedLunch = container.selectedLunch;
    setState(() {
      if (prevSelectedLunch == null) {
        container.increaseVote(newLunch);
      } else if (prevSelectedLunch.id != newLunch.id) {
        container.decreaseVote(prevSelectedLunch);
        container.increaseVote(newLunch);
      } else {
        container.decreaseVote(newLunch);
      }
    });

    container.changeSelectedLunch(newLunch);
  }

  Color paintTile(Lunch lunch) {
    final container = StateContainer.of(context);
    Color c = defaultColor;
    if (container.selectedLunch != null &&
        container.selectedLunch.id == lunch.id) {
      c = orangeColor;
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
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
            color: paintTile(lunch),
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
                // setState(() {
                toggleSelection(lunch);
                // });
              }),
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
      Stream stream = FirestoreService.getBodyStream();
      return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildLunchList(context, snapshot.data.documents);
        },
      );
    }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: makeBottom,
    );
  }
}
