import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photopuzzle/common/constants.dart';
import 'package:photopuzzle/widgets/components/my_common_button.dart';

import '../main_page.dart';
import 'components/my_loading_route.dart';

final loginModeProvider = StateProvider((ref) => false);

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);
  static int loginTag = 0001;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  static final StreamController<FirebaseUser> _authStreamController =
      StreamController<FirebaseUser>.broadcast();

  Future<void> _handleLogin(BuildContext context) async {
    if (!context.read(loginModeProvider).state) {
      GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;

      googleCurrentUser ??= await _googleSignIn.signInSilently();
      googleCurrentUser ??= await _googleSignIn.signIn();
      if (googleCurrentUser == null) {
        return null;
      }

      GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final user = (await _auth.signInWithCredential(credential)).user;
      _authStreamController.add(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: loginColor,
      body: _buildBody(size, context),
    );
  }

  Widget _buildBody(Size size, BuildContext context) {
    return Container(
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(size),
          _buildSwitch(context),
          _buildButton(context, size)
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, Size size) {
    return Container(
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
                            widgetLoginButton(context)
                          ],
                        ),
                      ),
                    );
                  }));
        },
      ),
    );
  }

  Widget _buildSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Auth',
          style: Theme.of(context).textTheme.headline5,
        ),
        Container(
          child: Consumer(
            builder: (context, watch, _) {
              return Switch(
                value: watch(loginModeProvider).state,
                onChanged: (value) {
                  context.read(loginModeProvider).state = value;
                },
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.white,
                activeColor: Colors.grey,
                activeTrackColor: Colors.black,
              );
            },
          ),
        ),
        Text(
          'Test',
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }

  Widget _buildIcon(Size size) {
    return Container(
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
    );
  }

  Widget widgetLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(smallPadding),
        child: StreamBuilder<FirebaseUser>(
            stream: _authStreamController.stream,
            builder: (context, snapshot) {
              /// this is test mode without firebase auth
              if (context.read(loginModeProvider).state) {
                SchedulerBinding.instance
                    .addPostFrameCallback((timeStamp) async {
                  /// mock loading
                  await Future<void>.delayed(const Duration(seconds: 1));
                  await Navigator.pushReplacement(
                      context,
                      MyLoadingRoute<void>(
                          duration: Duration(milliseconds: 500),
                          builder: (context) => MainPage(
                                heroTag: loginTag,
                              )));
                });
                // custom loading text view
                return widgetLoginSuccess();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                // change loading text view
                return widgetLoading();
              } else if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.data != null ||
                  snapshot.data == null) {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.pushReplacement(
                      context,
                      MyLoadingRoute<void>(
                          duration: Duration(milliseconds: 500),
                          builder: (context) => MainPage(
                                heroTag: loginTag,
                                user: snapshot.data,
                              )));
                });
                // custom loading text view
                return widgetLoginSuccess();
              } else {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context).pop();
                });
              }
              return Container();
            }),
      ),
    );
  }

  AnimatedDefaultTextStyle widgetLoginSuccess() {
    return AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 300),
        style: TextStyle(fontSize: mediumText),
        child: Text(
          'Welcome Back...',
        ));
  }

  AnimatedDefaultTextStyle widgetLoading() {
    return AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 300),
        style: TextStyle(fontSize: mediumText - 5.0),
        child: Text(
          'Loading...',
        ));
  }
}
