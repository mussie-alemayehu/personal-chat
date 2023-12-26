import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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
  String name = '';
  String username = '';
  String? imageUrl;
  late ScaffoldMessengerState scaffoldMessenger;
  late ThemeData theme;
  late String uid;
  File? _pickedImage;
  File? _existingImage;

  Future<File?> _getImageFile({String? url}) async {
    if (url == null) {
      return null;
    }
    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
    } catch (error) {
      return null;
    }
    final tempDirectory = await getTemporaryDirectory();
    File file = File(path.join(tempDirectory.path, '$uid.jpg'));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  Future<void> _saveForm(bool imageOk) async {
    if (!imageOk) {
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
        if (_pickedImage != null) {
          final uploadRef = FirebaseStorage.instance.ref('user_images');
          await uploadRef
              .child('/$uid.jpg')
              .putFile(_pickedImage!)
              .whenComplete(() => null);
          final downloadUrl =
              await uploadRef.child('/$uid.jpg').getDownloadURL();
          await FirebaseFirestore.instance.doc('users/$uid').update({
            'username': username,
            'name': name,
            'profile_picture': downloadUrl,
          });
        } else {
          await FirebaseFirestore.instance.doc('users/$uid').update({
            'username': username,
            'name': name,
          });
        }
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
      imageQuality: 75,
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
              if (name == '') {
                name = snapshot.data!.data()!.containsKey('name')
                    ? snapshot.data!['name']
                    : '';
              }
              if (username == '') {
                username = snapshot.data!.data()!.containsKey('username')
                    ? snapshot.data!['username']
                    : '';
              }
              imageUrl = snapshot.data!.data()!.containsKey('profile_picture')
                  ? snapshot.data!['profile_picture']
                  : null;

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    FutureBuilder(
                      future: _getImageFile(url: imageUrl),
                      builder: (ctx2, snapshot2) {
                        _existingImage = snapshot2.data;

                        return ProfilePictureViewer(
                          pickedImage: _pickedImage ?? _existingImage,
                          imagePicker: _imagePicker,
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    FormComponents.buildTextFormField(
                      context: context,
                      initialValue: name,
                      icon: const Icon(Icons.person),
                      hintText: 'Name',
                      onChanged: (value) {
                        if (value == null) {
                          name = '';
                        } else {
                          name = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty.';
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
                        return null;
                      },
                      onChanged: (value) {
                        if (value == null) {
                          username = '';
                        } else {
                          username = value;
                        }
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
                          onPressed: () {
                            bool isImageOk;
                            if (_pickedImage == null &&
                                _existingImage == null) {
                              isImageOk = false;
                            } else {
                              isImageOk = true;
                            }
                            _saveForm(isImageOk);
                          },
                          child: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
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
