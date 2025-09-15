import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay
          Container(
            color: Colors.black.withAlpha((255 * 0.5).round()),
          ),
          // Logo and Child
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Center(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(flex: 2),
                      Image.asset('images/logo.png', height: 100),
                      const Spacer(),
                      child,
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
