import 'package:auth_design/widgets/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'profile.dart';
import 'sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> signUpFormState = GlobalKey();

  TextEditingController givenName = TextEditingController();
  TextEditingController familyName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController checkPassword = TextEditingController();

  bool obscureText = true;

  @override
  void dispose() {
    super.dispose();
    givenName.dispose();
    familyName.dispose();
    email.dispose();
    password.dispose();
    checkPassword.dispose();
  }

  Future<void> signUpWithGoogle() async {
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
        key: signUpFormState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Register',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofillHints: const [AutofillHints.givenName],
                    controller: givenName,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    enableSuggestions: true,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    autofillHints: const [AutofillHints.familyName],
                    controller: familyName,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    enableSuggestions: true,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
              textInputAction: TextInputAction.next,
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
            const SizedBox(height: 16),
            TextFormField(
              autofillHints: const [AutofillHints.password],
              controller: checkPassword,
              decoration: const InputDecoration(labelText: 'Check Password'),
              enableSuggestions: true,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (password.text != value) {
                  return 'different than first password';
                } else if (value!.isEmpty) {
                  return 'empty';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                if (signUpFormState.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
                    await FirebaseAuth.instance.currentUser!.updateDisplayName('${givenName.text} ${familyName.text}');
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
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: signUpWithGoogle,
              icon: const Icon(FontAwesomeIcons.google),
              label: const Text('Sign up with Google'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('already have an account'),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SignIn(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                        position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                        child: child,
                      ),
                    ),
                  ),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
