import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photopuzzle/common/route_name.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              _handleLogin();
            },
            child: Container(
              height: 100,
              width: 200,
              child: Text('login'),
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleLogin() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;

    if (googleCurrentUser == null) {
      googleCurrentUser = await _googleSignIn.signInSilently();
    }
    if (googleCurrentUser == null) {
      googleCurrentUser = await _googleSignIn.signIn();
    }
    if (googleCurrentUser == null) {
      return null;
    }

    GoogleSignInAuthentication googleAuth =
        await googleCurrentUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    Navigator.pushNamed(context, RouteName.Home);
    return user;
  }
}
