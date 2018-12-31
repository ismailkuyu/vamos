import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:vamos/model/lunch.dart';
import 'package:vamos/model/user.dart';
import 'package:vamos/service/FirestoreService.dart';
import 'package:device_id/device_id.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final Lunch lunch;
  final User user;

  StateContainer({@required this.child, this.lunch, this.user});

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  Lunch selectedLunch;
  User user;

  void handleStates() {
    handleUser();
  }

  void handleUser() {
    if (user == null) {
      // setState(() {
      // user = new User();
      Future<String> deviceId = DeviceId.getID;
      deviceId.then((dId) {
        // user.id = dId;
        Future<User> fUser = FirestoreService.createUser(dId);
        fUser.then((u) {
          handleLunch(u.lunchId);
        });
      });
      // });
    }
  }

  void handleLunch(String lunchId) {
    if (selectedLunch == null) {
      // setState(() {
      Future<Lunch> lunch = FirestoreService.getLunch(lunchId);
      lunch.then((l) {
        selectedLunch = l;
      });
      // });
      // });
    }
  }

  void changeSelectedLunch(Lunch lunch) {
    setState(() {
      selectedLunch = lunch;
      FirestoreService.updateUser(selectedLunch.id);
    });
  }

  void increaseVote(Lunch lunch) {
    // setState(() {
      lunch.vote++;
      FirestoreService.updateLunch(lunch);
    // });
  }

  void decreaseVote(Lunch lunch) {
    // setState(() {
      lunch.vote--;
      FirestoreService.updateLunch(lunch);
    // });
  }

  void createLunch(DateTime date) {
    setState(() {
      if (selectedLunch != null) {
        decreaseVote(selectedLunch);
        // FirestoreService.updateLunch(selectedLunch);
      }
      // increaseVote(lunch);
      Future<Lunch> fLunch = FirestoreService.createLunch(date);
      fLunch.then((l) => changeSelectedLunch(l));
      // changeSelectedLunch(lunch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
