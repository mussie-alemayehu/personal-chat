import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/messages.dart';
import '../widgets/message_bubble.dart';
import '../widgets/new_messages.dart';

String _currentUserId = '';
String _receiverId = '';
String _chatId = '';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  Future<QuerySnapshot<Map<String, dynamic>>>? _querySnapshot() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('chat_id')
        .where('user1', isEqualTo: _receiverId)
        .where('user2', isEqualTo: _currentUserId)
        .get();

    if (snapshot.docs.isEmpty) {
      snapshot = await FirebaseFirestore.instance
          .collection('chat_id')
          .where('user2', isEqualTo: _receiverId)
          .where('user1', isEqualTo: _currentUserId)
          .get();
    }

    if (snapshot.docs.isEmpty) {
      final reference =
          await FirebaseFirestore.instance.collection('chat_id').add({
        'user1': _currentUserId,
        'user2': _receiverId,
      });
      _chatId = reference.id;
    } else {
      _chatId = snapshot.docs[0].id;
    }

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final receiverDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    _receiverId = receiverDetails['uid']!;
    final receiverName = receiverDetails['username']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(receiverName),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _querySnapshot(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc('1v1')
                      .collection(_chatId)
                      .orderBy('time')
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == null || !snapshot.hasData) {
                      return Center(
                        child: Text(
                          'No data found for this user.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    final messagesCollection =
                        snapshot.data!.docs.reversed.toList();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        reverse: true,
                        itemBuilder: (ctx, index) {
                          return MessageBubble(
                            Message(
                              sentBy: messagesCollection[index]['sentBy'],
                              text: messagesCollection[index]['message'],
                              time: DateTime.parse(
                                  messagesCollection[index]['time'] as String),
                            ),
                          );
                        },
                        itemCount: messagesCollection.length,
                      ),
                    );
                  },
                ),
              ),
              NewMessageSender(
                chatId: _chatId,
                receiverId: _receiverId,
                senderId: _currentUserId,
              ),
            ],
          );
        },
      ),
    );
  }
}
