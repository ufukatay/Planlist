import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ufukatay_todo/pages/TodoListPage.dart';

class SignupController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUp() async {
    var email = emailController.text.trim();
    var password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
        );
        Get.offAll(() => TodoListPage());
      } on FirebaseAuthException catch (e) {
        String message = "";
        switch (e.code) {
          case 'weak-password':
            message = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            message = 'An account already exists for that email.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          default:
            message = 'An error occurred. Please try again later.';
            print(e.code);
        }
        Get.snackbar("Sign Up Error", message, snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        print(e.toString());
        Get.snackbar("Sign Up Error", "An unexpected error occurred.", snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Error", "Please fill in all fields", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
