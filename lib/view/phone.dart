import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  GlobalKey<FormState> formState = GlobalKey();
  PhoneController phone = PhoneController(null);
  TextEditingController pin = TextEditingController();

  bool phoneInput = true;

  late String verification;

  @override
  void dispose() {
    super.dispose();

    phone.dispose();
    pin.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Center(
              child: SizedBox(
                width: 500,
                child: Form(
                  key: formState,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      ListTile(
                        leading: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        title: Text(
                          'Phone Number',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),

                      // Phone Number
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        child: phoneInput
                            ? PhoneFormField(
                                controller: phone,
                                defaultCountry: 'JO',
                                decoration: const InputDecoration(labelText: 'Phone'),
                                validator: PhoneValidator.validMobile(),
                                autofocus: true,
                                onEditingComplete: () => validate(),
                              )
                            : Pinput(
                                length: 6,
                                autofocus: true,
                                controller: pin,
                                onCompleted: (pin) => validate(),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Continue
                      ElevatedButton(
                        onPressed: () => validate(),
                        child: const Text('Continue'),
                      ),
                      const Spacer(flex: 2),
                      const SizedBox(height: 16)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void validate() {
    if (phoneInput) {
      try {
        FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone.value!.international,
          verificationCompleted: (PhoneAuthCredential credential) async => FirebaseAuth.instance.signInWithCredential(credential),
          verificationFailed: (FirebaseAuthException error) {
            if (mounted) {
              setState(() => phoneInput = false);
            }

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
          },
          codeSent: (String verificationId, int? resendToken) {
            if (mounted) {
              setState(() {
                verification = verificationId;

                phoneInput = false;
              });
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            if (mounted) {
              setState(() {
                verification = verificationId;

                phoneInput = false;
              });
            }
          },
        );
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
      }
    } else {
      try {
        FirebaseAuth.instance
            .signInWithCredential(
              PhoneAuthProvider.credential(verificationId: verification, smsCode: pin.text),
            )
            .then((value) {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const Profile(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                child: child,
              ),
            ),
            (route) => false,
          );
        });
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
      }
    }
  }
}
