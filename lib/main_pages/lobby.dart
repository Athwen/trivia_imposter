import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trivia_imposter/css/colors.dart';
import 'package:trivia_imposter/css/globals.dart';

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
          List players = [];
          String host = '';
          if (snapshot.hasData) {
            Map data = (snapshot.data as DocumentSnapshot).data() as Map;
            host = data['host'];
            players = data['players'];
          }
          return (snapshot.hasData)
              ? Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 200,
                      height: 600,
                      child: ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                players[index].toString(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (host == username)
                            ? Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                buttonColor)),
                                    onPressed: () async {},
                                    child: Text('Start Game'),
                                  ),
                                  SizedBox(
                                    width: 35.0,
                                  ),
                                ],
                              )
                            : Container(),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(buttonColor)),
                          onPressed: () async {},
                          child: Text('Leave Game'),
                        ),
                      ],
                    ),
                  ],
                )
              : Container();
        });
  }
}
