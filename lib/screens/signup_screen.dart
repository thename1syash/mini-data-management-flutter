import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signup() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString('users');

    List users = usersString == null ? [] : jsonDecode(usersString);

    final exists = users.any((u) => u['email'] == emailController.text);

    if (exists) {
      showError('User already exists');
      return;
    }

    users.add({
      'email': emailController.text,
      'password': passwordController.text,
    });

    await prefs.setString('users', jsonEncode(users));

    Navigator.pop(context);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signup,
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
