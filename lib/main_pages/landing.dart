import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trivia_imposter/css/colors.dart';
import 'package:trivia_imposter/css/globals.dart';
import 'package:trivia_imposter/main_pages/lobby.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key, required this.username}) : super(key: key);

  String username;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // 0 should be room code page
  // 1 should be lobby
  // 2 - ?? however many pages should
  // get you through the game
  int screenIndex = 0;

  String roomCode = '';

  void nextScreen(int nextScreen, String roomCode) {
    setState(() {
      screenIndex = nextScreen;
      this.roomCode = roomCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      CreateJoinRoom(
        username: widget.username,
        callback: nextScreen,
      ),
      PlayerLobby(roomCode: roomCode),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text('Sign Out'),
          ),
        ],
        backgroundColor: appBarColor,
        title: Center(
          child: Text('Trivial Imposter'),
        ),
      ),
      body: Center(
        child: screens[screenIndex],
      ),
    );
  }
}

// ignore: must_be_immutable
class CreateJoinRoom extends StatefulWidget {
  CreateJoinRoom({Key? key, required this.username, required this.callback})
      : super(key: key);

  String username;
  Function(int, String) callback;

  @override
  CreateJoinRoomState createState() => CreateJoinRoomState();
}

class CreateJoinRoomState extends State<CreateJoinRoom> {
  TextEditingController _roomcodeController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool host = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Room Code: ',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        Container(
          width: 200,
          child: TextField(
            controller: _roomcodeController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Room Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                String roomCode = _roomcodeController.text;
                DocumentSnapshot data =
                    await _firestore.collection('rooms').doc(roomCode).get();
                if (data.exists) {
                  Map roomDetails = data.data() as Map;
                  List players = roomDetails['players'];
                  players.add(username);
                  await _firestore
                      .collection('rooms')
                      .doc(roomCode)
                      .update({'players': players});
                  setState(() {
                    roomCode = roomCode;
                    widget.callback(Screens.Lobby.index, roomCode);
                  });
                } else {
                  print('room does not exist');
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor)),
              child: Text('Join Room'),
            ),
            SizedBox(
              width: 35.0,
            ),
            ElevatedButton(
              onPressed: () async {
                String roomCode = generateRandomCode();
                print(roomCode);
                _firestore.collection('rooms').doc(roomCode).set({
                  'host': username,
                  'players': [username]
                });
                widget.callback(Screens.Lobby.index, roomCode);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor)),
              child: Text('Create Room'),
            ),
          ],
        ),
        SizedBox(
          height: 150,
        ),
      ],
    );
  }

  String generateRandomCode() {
    Random rand = Random();
    List<String> alphabet =
        'abcdefghijklmnopqrstuvwxyz'.toUpperCase().split('');
    String roomCode = '';
    for (int i = 0; i < 4; i++) {
      roomCode += alphabet[rand.nextInt(alphabet.length - 1)];
    }

    return roomCode;
  }
}

enum Screens {
  JoinCreate,
  Lobby,
}
