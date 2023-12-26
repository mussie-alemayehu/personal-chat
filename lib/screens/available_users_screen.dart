import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/user_list_item.dart';

class AvailableUsersScreen extends StatelessWidget {
  static const routeName = '/available_users';

  const AvailableUsersScreen({super.key});

  List<String?> _name(QueryDocumentSnapshot<Map<String, dynamic>> user) {
    String name;
    String? imageUrl;

    if (user.data().containsKey('name')) {
      name = user['name'];
    } else if (user.data().containsKey('username')) {
      name = user['username'];
    } else {
      name = user['email'];
    }

    if (user.data().containsKey('profile_picture')) {
      imageUrl = user['profile_picture'];
    }
    return [
      name,
      imageUrl,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            expandedHeight: 70,
            floating: true,
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              'Available users',
            ),
          ),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ]),
                  );
                } else if (streamSnapshot.data!.docs.isEmpty) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                              'There are no available users at the moment.',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  );
                }
                final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                final usersList = streamSnapshot.data!.docs
                  ..removeWhere((user) => user['uid'] == currentUserId);

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx2, index) {
                      final userInfo = _name(usersList[index]);
                      return UserListItem(
                        uid: usersList[index]['uid'],
                        userName: userInfo[0]!,
                        imageUrl: userInfo[1],
                      );
                    },
                    childCount: usersList.length,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
