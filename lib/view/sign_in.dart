import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up.dart';
import 'profile.dart';

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

  bool obscureText = false;

  @override
  void dispose() {
    super.dispose();

    email.dispose();
    password.dispose();
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
                  key: signInFormState,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      ListTile(
                        title: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('enter your email and password to sign'),
                      ),
                      const Spacer(flex: 2),

                      // Email
                      TextFormField(
                        autofillHints: const [AutofillHints.email],
                        controller: email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        enableSuggestions: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
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
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        autofillHints: const [AutofillHints.password],
                        controller: password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscureText = !obscureText),
                            icon: Icon(obscureText ? Icons.remove_red_eye : Icons.lock),
                          ),
                        ),
                        enableSuggestions: true,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            'empty';
                          } else if (value.length < 6) {
                            'less than 6';
                          } else {
                            null;
                          }
                        },
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

                      // Forget Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Enter your email to get the reset password link',
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              content: Form(
                                key: forgetPasswordFormState,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: TextFormField(
                                    autofillHints: const [AutofillHints.email],
                                    controller: email,
                                    decoration: const InputDecoration(labelText: 'Email'),
                                    enableSuggestions: true,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
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
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (forgetPasswordFormState.currentState!.validate()) {
                                      try {
                                        FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('check your inbox')),
                                        );
                                      } on FirebaseAuthException catch (error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(error.message.toString())),
                                        );
                                      }

                                      Navigator.pop(context);
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

                      // Sign In
                      ElevatedButton(
                        onPressed: () {
                          if (signInFormState.currentState!.validate()) {
                            try {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(email: email.text, password: password.text)
                                  .then((value) => Navigator.pushAndRemoveUntil(
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.message.toString())),
                              );
                            }
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                      const Spacer(flex: 2),

                      // Sign Up
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
                      const SizedBox(height: 16)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
