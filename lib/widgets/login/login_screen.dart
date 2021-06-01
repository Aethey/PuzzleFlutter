import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/routes/scale_route.dart';
import 'package:photopuzzle/widgets/components/my_common_button.dart';

import '../home.dart';
import '../main_page.dart';
import 'components/my_loading_route.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);
  static var loginTag = 0001;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  static final StreamController<FirebaseUser> _authStreamController =
      StreamController<FirebaseUser>.broadcast();

  Future<void> _handleLogin(BuildContext context) async {
    var googleCurrentUser = _googleSignIn.currentUser;

    googleCurrentUser ??= await _googleSignIn.signInSilently();
    googleCurrentUser ??= await _googleSignIn.signIn();
    if (googleCurrentUser == null) {
      return null;
    }

    var googleAuth = await googleCurrentUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final user = (await _auth.signInWithCredential(credential)).user;
    _authStreamController.add(user);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: loginColor,
      body: Container(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.black.withOpacity(0.2))
              ]),
              height: size.height / 8,
              width: size.height / 8,
              child: Hero(
                  tag: '$loginTag',
                  child: SvgPicture.asset('assets/icons/profile_user.svg')),
            ),
            Container(
              margin: EdgeInsets.only(top: mediumPadding),
              child: MyCommonButton(
                text: 'LOGIN',
                press: () {
                  Navigator.push(
                      context,
                      MyLoadingRoute<void>(
                          duration: Duration(milliseconds: 300),
                          color: yPrimaryColor,
                          builder: (BuildContext context) {
                            _handleLogin(context);
                            return Center(
                              child: Container(
                                width: size.width,
                                height: size.height / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Hero(
                                          tag: '$loginTag',
                                          child: SvgPicture.asset(
                                              'assets/icons/profile_user.svg')),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: StreamBuilder<FirebaseUser>(
                                            stream:
                                                _authStreamController.stream,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                // change loading text view
                                                return AnimatedDefaultTextStyle(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    child: Text(
                                                      'Loading...',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ));
                                              } else if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.active &&
                                                  snapshot.data != null) {
                                                SchedulerBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MyLoadingRoute<void>(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          builder: (context) =>
                                                              MainPage(
                                                                heroTag:
                                                                    loginTag,
                                                                user: snapshot
                                                                    .data,
                                                              )));
                                                });
                                                // custom loading text view
                                                return AnimatedDefaultTextStyle(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    child: Text(
                                                      'Welcome Back...',
                                                    ));
                                              } else {
                                                SchedulerBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) {
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                              return Container();
                                            }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
