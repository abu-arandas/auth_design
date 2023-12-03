import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:pinput/pinput.dart';

import 'home.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = FirebaseAuth.instance.currentUser!;
  GlobalKey<FormState> signUpFormState = GlobalKey();
  GlobalKey<FormState> pinFormState = GlobalKey();

  TextEditingController givenName = TextEditingController();
  TextEditingController familyName = TextEditingController();
  TextEditingController email = TextEditingController();
  PhoneController phone = PhoneController(null);
  TextEditingController pin = TextEditingController();

  late String verification;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (user.displayName != null) {
        givenName = TextEditingController(text: user.displayName);
      }

      if (user.email != null) {
        email = TextEditingController(text: user.email);
      }

      if (user.phoneNumber != null) {
        phone = PhoneController(PhoneNumber.fromRaw(user.phoneNumber!));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    givenName.dispose();
    familyName.dispose();
    email.dispose();
    phone.dispose();
    pin.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () => FirebaseAuth.instance.signOut().then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const Home(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                        position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                        child: child,
                      ),
                    ),
                    (route) => false,
                  )),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Center(
              child: SizedBox(
                width: 500,
                child: Form(
                  key: signUpFormState,
                  child: Column(
                    children: [
                      // Image
                      Container(
                        width: 125,
                        height: 125,
                        margin: const EdgeInsets.all(16),
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(color: Colors.black, blurRadius: 10, blurStyle: BlurStyle.outer),
                          ],
                          image: user.photoURL != null ? DecorationImage(image: NetworkImage(user.photoURL!), fit: BoxFit.fill) : null,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
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
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  'empty';
                                } else {
                                  null;
                                }
                              },
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
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  'empty';
                                } else {
                                  null;
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'empty';
                                } else {
                                  return null;
                                }
                              },
                              onFieldSubmitted: (value) {
                                try {
                                  FirebaseAuth.instance.currentUser!.updateDisplayName('${givenName.text} ${familyName.text}');
                                } on FirebaseAuthException catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.message.toString())),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        autofillHints: const [AutofillHints.email],
                        controller: email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        enableSuggestions: true,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            'empty';
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                            'not a valid email address';
                          } else {
                            null;
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'empty';
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                            return 'not a valid email address';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          try {
                            FirebaseAuth.instance.currentUser!.updateEmail(email.text);
                          } on FirebaseAuthException catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.message.toString())),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      PhoneFormField(
                        controller: phone,
                        defaultCountry: 'JO',
                        decoration: const InputDecoration(labelText: 'Phone'),
                        validator: PhoneValidator.validMobile(),
                        onEditingComplete: () {
                          try {
                            FirebaseAuth.instance
                                .verifyPhoneNumber(
                                  phoneNumber: phone.value!.international,
                                  verificationCompleted: (PhoneAuthCredential credential) async =>
                                      FirebaseAuth.instance.signInWithCredential(credential),
                                  verificationFailed: (FirebaseAuthException error) =>
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString()))),
                                  codeSent: (String verificationId, int? resendToken) => setState(() => verification = verificationId),
                                  codeAutoRetrievalTimeout: (String verificationId) => setState(() => verification = verificationId),
                                )
                                .then((value) => pinAlert());
                          } on FirebaseAuthException catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void pinAlert() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Enter the code',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: pinFormState,
            child: Pinput(length: 6, autofocus: true, controller: pin),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (pinFormState.currentState!.validate()) {
                  try {
                    FirebaseAuth.instance
                        .signInWithCredential(
                          PhoneAuthProvider.credential(verificationId: verification, smsCode: pin.text),
                        )
                        .then((value) => Navigator.pop(context));
                  } on FirebaseAuthException catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
                  }
                }
              },
              child: const Text('done'),
            )
          ],
        ),
      );
}
