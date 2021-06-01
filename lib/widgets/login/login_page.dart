import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photopuzzle/routes/scale_route.dart';
import 'package:photopuzzle/widgets/home.dart';

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
          child: ElevatedButton(
            onPressed: () {
              EasyLoading.show(status: 'loading...');
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
    var googleCurrentUser = _googleSignIn.currentUser;

    googleCurrentUser ??= await _googleSignIn.signInSilently();
    googleCurrentUser ??= await _googleSignIn.signIn();
    if (googleCurrentUser == null) {
      return null;
    }

    var googleAuth =
        await googleCurrentUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final user =
        (await _auth.signInWithCredential(credential)).user;
    await Navigator.push(context, ScaleRoute(page: HomePage()));
    return user;
  }
}
