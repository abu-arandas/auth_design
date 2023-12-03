import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_in.dart';
import 'profile.dart';

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

  bool obscureText = false;

  @override
  void dispose() {
    super.dispose();

    givenName.dispose();
    familyName.dispose();
    email.dispose();
    password.dispose();
    checkPassword.dispose();
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
                  key: signUpFormState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      ListTile(
                        leading: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        title: Text(
                          'Register',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w900),
                        ),
                        subtitle: const Text('complete your informations to register'),
                      ),
                      const Spacer(flex: 2),

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
                        textInputAction: TextInputAction.next,
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
                      const SizedBox(height: 16),

                      // Check Password
                      TextFormField(
                        autofillHints: const [AutofillHints.password],
                        controller: checkPassword,
                        decoration: const InputDecoration(labelText: 'Check Password'),
                        enableSuggestions: true,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if (password.text != value) {
                            'diffrence than first password';
                          }
                        },
                        validator: (value) {
                          if (password.text != value) {
                            return 'diffrence than first password';
                          } else if (value!.isEmpty) {
                            return 'empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Sign Up
                      ElevatedButton(
                        onPressed: () {
                          if (signUpFormState.currentState!.validate()) {
                            try {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(email: email.text, password: password.text)
                                  .then((value) => FirebaseAuth.instance.currentUser!.updateDisplayName('${givenName.text} ${familyName.text}'))
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
                        child: const Text('Sign Up'),
                      ),
                      const Spacer(flex: 2),

                      // Sign In
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
