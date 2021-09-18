import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PlayerLobby extends StatefulWidget {
  PlayerLobby({Key? key, required this.roomCode}) : super(key: key);
  String roomCode;
  @override
  _PlayerLobbyState createState() => _PlayerLobbyState();
}

class _PlayerLobbyState extends State<PlayerLobby> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('rooms').doc(widget.roomCode).snapshots(),
        builder: (BuildContext context, snapshot) {
          print(snapshot.data);
          return (snapshot.hasData)
              ? Container(
                  child: Text('testing'),
                )
              : Container();
        });
  }
}
