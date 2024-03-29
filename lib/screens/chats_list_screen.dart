import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './main_drawer.dart';
import '../widgets/user_list_item.dart';

class ChatsListScreen extends StatelessWidget {
  static const routeName = '/chats_list';

  const ChatsListScreen({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> _getChats() {
    final snapshot1 = FirebaseFirestore.instance
        .collection('chat_id')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();

    return snapshot1;
  }

  Map<String, String?> _receiverDetails(QuerySnapshot allUsers,
      QueryDocumentSnapshot<Map<String, dynamic>> chat) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final receiverId =
        currentUserId == chat['user1'] ? chat['user2'] : chat['user1'];
    final receiver = allUsers.docs.firstWhere((doc) => doc['uid'] == receiverId)
        as QueryDocumentSnapshot<Map<String, dynamic>>;

    String receiverName;
    if (receiver.data().containsKey('name')) {
      receiverName = receiver['name'];
    } else if (receiver.data().containsKey('username')) {
      receiverName = receiver['username'];
    } else {
      receiverName = receiver['email'];
    }

    String? profilePicture;
    if (receiver.data().containsKey('profile_picture')) {
      profilePicture = receiver['profile_picture'];
    }

    String? lastMessage;
    if (chat.data().containsKey('lastMessage')) {
      lastMessage = chat['lastMessage'];
    }

    String? lastMessageImage;
    if (chat.data().containsKey('lastMessageImage')) {
      lastMessageImage = chat['lastMessageImage'];
    }

    String? lastMessageSentBy;
    if (chat.data().containsKey('sentBy')) {
      lastMessageSentBy = chat['sentBy'];
    }

    String? lastMessageTime;
    if (chat.data().containsKey('lastMessageTime')) {
      lastMessageTime = chat['lastMessageTime'];
    }

    return {
      'receiver_name': receiverName,
      'receiver_id': receiverId,
      'profile_picture': profilePicture,
      'last_message': lastMessage,
      'last_message_image': lastMessageImage,
      'last_message_sent_by': lastMessageSentBy,
      'last_message_time': lastMessageTime,
      'last_message_type': chat['lastMessageType'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      drawer: const MainDrawer(),
      body: StreamBuilder(
        stream: _getChats(),
        builder: (ctx, streamSnapshot) {
          return FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (ctx, futureSnapshot) {
              List<QueryDocumentSnapshot<Object?>> chats = [];
              if (!(streamSnapshot.connectionState == ConnectionState.waiting ||
                  futureSnapshot.connectionState == ConnectionState.waiting)) {
                chats = streamSnapshot.data!.docs.where((doc) {
                  if (doc['user1'] == userId && doc['user2'] != userId) {
                    return true;
                  } else if (doc['user1'] != userId && doc['user2'] == userId) {
                    return true;
                  } else {
                    return false;
                  }
                }).toList();
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    stretch: true,
                    expandedHeight: 100,
                    floating: true,
                    centerTitle: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Users'),
                        if (streamSnapshot.connectionState ==
                                ConnectionState.waiting ||
                            futureSnapshot.connectionState ==
                                ConnectionState.waiting)
                          Text(
                            'Connecting...',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                      ),
                    ],
                  ),
                  if (streamSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      futureSnapshot.connectionState == ConnectionState.waiting)
                    SliverList.list(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      ],
                    ),
                  if (!(streamSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      futureSnapshot.connectionState ==
                          ConnectionState.waiting))
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          UserListItem(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            userName: 'Saved Messages',
                            lastMessageType: 'Text',
                          ),
                          if (chats.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Center(
                                child: Text(
                                  'You haven\'t spoken to anyone yet, go to '
                                  'Available users and start talking to see them here.',
                                ),
                              ),
                            ),
                          if (chats.isNotEmpty)
                            ...chats.map(
                              (chat) {
                                final receiverDetails = _receiverDetails(
                                    futureSnapshot.data!,
                                    chat as QueryDocumentSnapshot<
                                        Map<String, dynamic>>);

                                return UserListItem(
                                  userName: receiverDetails['receiver_name']!,
                                  uid: receiverDetails['receiver_id']!,
                                  profilePicture:
                                      receiverDetails['profile_picture'],
                                  lastMessage: receiverDetails['last_message'],
                                  lastMessageImage:
                                      receiverDetails['last_message_image'],
                                  lastMessageSentBy:
                                      receiverDetails['last_message_sent_by'],
                                  lastMessageTime:
                                      receiverDetails['last_message_time'] ==
                                              null
                                          ? null
                                          : DateTime.tryParse(receiverDetails[
                                              'last_message_time']!),
                                  lastMessageType:
                                      receiverDetails['last_message_type']!,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
