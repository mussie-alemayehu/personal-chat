import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/form_components.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _repassNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  var _isLogin = true;
  var _isLoading = false;
  final Map<String, String> _credentials = {
    'email': '',
    'password': '',
  };
  late ScaffoldMessengerState scaffoldMessenger;
  late ThemeData theme;

  Future<void> _saveForm() async {
    if (_formKey.currentState == null) {
      return;
    }
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        if (_isLogin) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _credentials['email']!,
            password: _credentials['password']!,
          );
          setState(() {
            _isLoading = false;
          });
        } else {
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _credentials['email']!,
            password: _credentials['password']!,
          );
          firestoreInstance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(
            {
              'email': _credentials['email'],
              'uid': userCredential.user!.uid,
            },
          );
          setState(() {
            _isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: theme.colorScheme.error,
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    scaffoldMessenger = ScaffoldMessenger.of(context);
    theme = Theme.of(context);

    return Container(
      width: mediaQuerySize.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      decoration: FormComponents.boxDecoration(context),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isLogin ? 'Login' : 'New Account',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(height: 15),
              FormComponents.buildTextFormField(
                context: context,
                hintText: 'E-Mail',
                focusNode: _emailNode,
                icon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_passwordNode);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Not a valid e-mail address.';
                  }
                  if (value.isEmpty) {
                    return 'This field cannot be empty';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid e-mail address.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _credentials['email'] = value!;
                },
              ),
              const SizedBox(height: 15),
              FormComponents.buildTextFormField(
                context: context,
                controller: _passwordController,
                focusNode: _passwordNode,
                hintText: 'Password',
                obscure: true,
                icon: const Icon(Icons.lock),
                onEditingComplete: () {
                  if (!_isLogin) {
                    FocusScope.of(context).requestFocus(_repassNode);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Not a valid password.';
                  } else if (value.isEmpty) {
                    return 'This field cannot be empty.';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _credentials['password'] = value!;
                },
              ),
              if (!_isLogin) const SizedBox(height: 15),
              if (!_isLogin)
                FormComponents.buildTextFormField(
                  context: context,
                  focusNode: _repassNode,
                  hintText: 'Re-Enter Password',
                  obscure: true,
                  icon: const Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value == null) {
                      return 'Enter the same password here.';
                    } else if (!(value == _passwordController.text)) {
                      return 'Enter the same password here.';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: CircularProgressIndicator(),
                      )
                    : Text(_isLogin ? 'Login' : 'Continue >'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin ? 'New to YouChat?' : 'Already have an account?',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white70),
                  ),
                  TextButton(
                    child: Text(
                      _isLogin ? 'Join now' : 'Login',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
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
