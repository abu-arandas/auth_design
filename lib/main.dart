import 'package:flutter/material.dart';

import 'auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Simple Authentication Design',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8D83)),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5)),
            constraints: const BoxConstraints(maxWidth: 500),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(500, 50),
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFFF8D83),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
            ),
          ),
        ),
        home: const Home(),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('images/bg1.png'), fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset('images/bg2.png', fit: BoxFit.fill),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome', style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold)),
                    const Text('Sign in to your Registered Account'),
                    Container(
                      width: 75,
                      height: 5,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const Authentication(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                position: animation.drive(Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)),
                child: child,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.primary,
          shape: CircleBorder(side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)),
          child: const Icon(Icons.arrow_right),
        ),
      );
}
