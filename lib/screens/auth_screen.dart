import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  // static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Text(
              'YouChat',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    AuthForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
