import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ufukatay_todo/pages/SigninPage.dart';
import 'package:ufukatay_todo/pages/SignupPage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight / 13),
              Image.asset('images/plantist.png'),
              const Text(
                "Welcome back to",
                style: TextStyle(fontSize: 30),
              ),
              const Text(
                "Plantist",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight / 30),
              const Text(
                "Start your productive life now",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: screenHeight / 30),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => SigninPage());
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade100),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 44.0),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.email, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Sign in with email',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight / 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => Get.to(SignupPage()),
                    style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                    child: const Text("Sign up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
