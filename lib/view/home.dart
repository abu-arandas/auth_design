import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_in.dart';
import 'phone.dart';
import 'profile.dart';

import '../config/delay.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool startAnimation = false;

  List<AuthItem> authItems(context) => [
        AuthItem(
          title: 'email and password',
          icon: FontAwesomeIcons.user,
          color: Colors.white,
          function: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const SignIn(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                child: child,
              ),
            ),
          ),
        ),
        AuthItem(
          title: 'phone number',
          icon: FontAwesomeIcons.phone,
          color: Colors.black,
          function: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const PhoneAuth(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                child: child,
              ),
            ),
          ),
        ),
        AuthItem(
          title: 'google',
          icon: FontAwesomeIcons.google,
          color: const Color(0xFFDB4437),
          function: () async {
            try {
              final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
              final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

              final AuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleSignInAuthentication.accessToken,
                idToken: googleSignInAuthentication.idToken,
              );

              await FirebaseAuth.instance.signInWithCredential(credential).then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const Profile(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                        position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                        child: child,
                      ),
                    ),
                    (route) => false,
                  ));
            } on FirebaseAuthException catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
            }
          },
        ),
      ];

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () => setState(() => startAnimation = true));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF8F9F9),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/social.gif'),
              AnimatedOpacity(
                opacity: startAnimation ? 1 : 0,
                duration: const Duration(seconds: 1),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: authItems(context).length,
                  itemBuilder: (context, index) => DelayedDisplay(
                    delay: Duration(seconds: 1 * (index + 1)),
                    child: Container(
                      width: 500,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: authItems(context)[index].color == Colors.white ? Colors.transparent : authItems(context)[index].color,
                        borderRadius: BorderRadius.circular(12.5),
                        border: authItems(context)[index].color == Colors.white ? Border.all(color: Colors.black) : null,
                      ),
                      child: ListTile(
                        onTap: authItems(context)[index].function,
                        leading: Icon(
                          authItems(context)[index].icon,
                          color: authItems(context)[index].color == Colors.white ? Colors.black : Colors.white,
                        ),
                        title: Text(
                          authItems(context)[index].title,
                          style: TextStyle(
                            color: authItems(context)[index].color == Colors.white ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class AuthItem {
  String title;
  IconData icon;
  Color color;
  void Function() function;

  AuthItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.function,
  });
}
