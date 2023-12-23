import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../components/form_components.dart';
import '../widgets/profile_picture_viewer.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit_profile';

  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late NavigatorState navigator;
  late String name;
  late String username;
  late ScaffoldMessengerState scaffoldMessenger;
  late ThemeData theme;
  late String uid;
  File? _pickedImage;

  Future<void> _saveForm() async {
    if (_pickedImage == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Please provide your profile picture.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (_formKey.currentState == null) {
      return;
    }
    var isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        final uploadRef = FirebaseStorage.instance.ref('user_images');
        uploadRef.child('/$uid.jpg').putFile(_pickedImage!);
        final downloadUrl = await uploadRef.child('/$uid.jpg').getDownloadURL();
        await FirebaseFirestore.instance.doc('users/$uid').update({
          'username': username,
          'name': name,
          'profile_picture': downloadUrl,
        });
      } catch (error) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: theme.colorScheme.error,
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
      navigator.pop();
    }
  }

  Future<void> _imagePicker() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
      maxWidth: 200,
      maxHeight: 200,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    scaffoldMessenger = ScaffoldMessenger.of(context);
    theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Edit Your Profile'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: FutureBuilder(
              future: FirebaseFirestore.instance.doc('users/$uid').get(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null ||
                    snapshot.data!.data() == null) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                name = snapshot.data!.data()!.containsKey('name')
                    ? snapshot.data!['name']
                    : '';
                username = snapshot.data!.data()!.containsKey('username')
                    ? snapshot.data!['username']
                    : '';
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      ProfilePictureViewer(
                        pickedImage: _pickedImage,
                        imagePicker: _imagePicker,
                      ),
                      const SizedBox(height: 50),
                      FormComponents.buildTextFormField(
                        context: context,
                        initialValue: name,
                        icon: const Icon(Icons.person),
                        hintText: 'Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field can\'t be empty.';
                          }
                          if (value.length < 4) {
                            return 'Your name must be at least 4 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value!;
                        },
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Enter a User Name that can be used to uniquely identify you on YouChat.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white60,
                            ),
                      ),
                      const SizedBox(height: 30),
                      FormComponents.buildTextFormField(
                        context: context,
                        initialValue: username,
                        icon: const Icon(Icons.person),
                        hintText: 'User Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'User Name can\'t be empty.';
                          }
                          if (value.length < 4) {
                            return 'User Name must be at least 4 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            onPressed: _saveForm,
                            child: _isLoading
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    navigator = Navigator.of(context);
  }
}
