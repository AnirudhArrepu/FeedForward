import 'package:fbm_app/Pages/authentication/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _forSplash();
}

class _forSplash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _forLogin();
  }

  _forLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        color: const Color.fromARGB(255, 150, 22, 12),
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
