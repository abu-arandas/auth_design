import 'package:auth_design/widgets/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'profile.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> signInFormState = GlobalKey();
  GlobalKey<FormState> forgetPasswordFormState = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgetPasswordEmail = TextEditingController();

  bool obscureText = true;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    forgetPasswordEmail.dispose();
  }

  Future<void> signInWithGoogle() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        navigator.pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const Profile(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
              position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
              child: child,
            ),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Form(
        key: signInFormState,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 32),
            TextFormField(
              autofillHints: const [AutofillHints.email],
              controller: email,
              decoration: const InputDecoration(labelText: 'Email'),
              enableSuggestions: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'empty';
                } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                  return 'not a valid email address';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              autofillHints: const [AutofillHints.password],
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => obscureText = !obscureText),
                  icon: Icon(obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 18),
                ),
              ),
              enableSuggestions: true,
              keyboardType: TextInputType.visiblePassword,
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'empty';
                } else if (value.length < 6) {
                  return 'less than 6';
                } else {
                  return null;
                }
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Password'),
                    content: Form(
                      key: forgetPasswordFormState,
                      child: TextFormField(
                        autofillHints: const [AutofillHints.email],
                        controller: forgetPasswordEmail,
                        decoration: const InputDecoration(labelText: 'Email'),
                        enableSuggestions: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'empty';
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                            return 'not a valid email address';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          if (forgetPasswordFormState.currentState!.validate()) {
                            try {
                              FirebaseAuth.instance.sendPasswordResetEmail(email: forgetPasswordEmail.text);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('check your inbox')),
                              );
                            } on FirebaseAuthException catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.message.toString())),
                              );
                            }
                          }
                        },
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Forget Password'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                if (signInFormState.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                    navigator.pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const Profile(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                          position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                          child: child,
                        ),
                      ),
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (error) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(error.message.toString())),
                    );
                  }
                }
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: signInWithGoogle,
              icon: const Icon(FontAwesomeIcons.google),
              label: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('don\'t have an account?'),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SignUp(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                        position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                        child: child,
                      ),
                    ),
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
