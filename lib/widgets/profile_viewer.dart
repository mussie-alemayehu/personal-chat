import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/edit_profile_screen.dart';

class ProfileViewer extends StatelessWidget {
  const ProfileViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshotReference = FirebaseFirestore.instance.doc('users/$userId');

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: FutureBuilder(
        future: snapshotReference.get(),
        builder: (ctx, snapshot) {
          Map<String, dynamic>? data;
          String? username;
          if (snapshot.connectionState != ConnectionState.waiting) {
            data = snapshot.data!.data()!;
            if (data.containsKey('name')) {
              username = data['name'];
            } else if (data.containsKey('username')) {
              username = data['username'];
            } else {
              username = data['email'];
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: data != null
                      ? data.containsKey('profile_picture')
                          ? NetworkImage(data['profile_picture'])
                          : null
                      : null,
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator()
                      : null,
                ),
              ),
              Text(username ?? ''),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(EditProfileScreen.routeName);
                    },
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
