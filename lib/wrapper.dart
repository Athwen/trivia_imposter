import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trivia_imposter/css/globals.dart';
import 'package:trivia_imposter/main.dart';

import 'main_pages/landing.dart';

class Wrapper extends StatelessWidget {
  Wrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, userSnapshot) {
        if (userSnapshot.hasData) print(userSnapshot.data);
        return (userSnapshot.hasData)
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc((userSnapshot.data as User).uid)
                    .get(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    print((snapshot.data as DocumentSnapshot).data());
                  }
                  // username = snapshot.data.toString();
                  return (!snapshot.hasData)
                      ? RoomCodePage()
                      : LandingPage(
                          username: ''); //LandingPage(username: username);
                },
              )
            : RoomCodePage();
        // return (!snapshot.hasData)
        //     ? RoomCodePage()
        //     : LandingPage(username: username);
      },
    );
  }
}
