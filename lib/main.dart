import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trivia_imposter/css/colors.dart';
import 'package:trivia_imposter/css/globals.dart';
import 'package:trivia_imposter/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: backgroundColor,
        canvasColor: backgroundColor,
      ),
      home: Wrapper(),
    );
  }
}

class RoomCodePage extends StatefulWidget {
  const RoomCodePage({Key? key}) : super(key: key);

  @override
  _RoomCodePageState createState() => _RoomCodePageState();
}

class _RoomCodePageState extends State<RoomCodePage> {
  TextEditingController _usernameController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Center(child: Text('Trivial Imposter')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Room Code: ',
            //   style: TextStyle(fontSize: 24, color: Colors.white),
            // ),
            // Container(
            //   width: 200,
            //   child: TextField(
            //     controller: _roomcodeController,
            //     decoration: InputDecoration(
            //       fillColor: Colors.white,
            //       filled: true,
            //       hintText: 'Room Code',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 25,
            // ),
            Text(
              'Username: ',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Container(
              width: 200,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     UserCredential user = await _auth.signInAnonymously();
            //     String roomCode = generateRandomCode();
            //     _firestore.collection('rooms').doc(roomCode).set({
            //       'players': [_usernameController.text]
            //     });
            //   },
            //   style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(buttonColor)),
            //   child: Text('Create Room!'),
            // ),
            // SizedBox(
            //   height: 25.0,
            // ),
            ElevatedButton(
              onPressed: () async {
                UserCredential user = await _auth.signInAnonymously();
                await _firestore.collection('users').doc(user.user!.uid).set(
                  {'username': _usernameController.text},
                );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor)),
              child: Text('Join!'),
            ),
          ],
        ),
      ),
    );
  }
}
