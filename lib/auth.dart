import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  GlobalKey<FormState> signInFormState = GlobalKey();
  GlobalKey<FormState> signUpFormState = GlobalKey();
  GlobalKey<FormState> forgetPasswordFormState = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController givenName = TextEditingController();
  TextEditingController familyName = TextEditingController();
  TextEditingController checkPassword = TextEditingController();

  bool obscureText = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: MediaQuery.sizeOf(context).height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('images/bg1.png'), fit: BoxFit.fill),
                ),
                child: Image.asset('images/bg2.png', fit: BoxFit.fill),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(tabs: [Tab(text: 'Sign In'), Tab(text: 'Sign Up')]),
                      Expanded(child: TabBarView(children: [signIn(), register()])),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget signIn() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: signInFormState,
          child: Column(
            children: [
              Text('Sign In', style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold)),

              social(),

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
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('go and check your inbox')));
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Succes')));
                  }
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );

  Widget register() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: signUpFormState,
          child: Column(
            children: [
              Text('Register', style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold)),

              social(),

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
                  if (password.text != checkPassword.text) {
                    'diffrence than first password';
                  }
                },
                validator: (value) {
                  if (password.text != checkPassword.text) {
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Succes')));
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      );

  Widget social() => Container(
        margin: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              onPressed: () {},
              icon: const Icon(Icons.facebook),
            ),
            const SizedBox(width: 16),
            IconButton.outlined(
              onPressed: () {},
              icon: const Icon(Icons.g_mobiledata),
            ),
          ],
        ),
      );
}
