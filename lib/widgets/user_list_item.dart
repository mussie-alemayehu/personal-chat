import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class UserListItem extends StatelessWidget {
  final String userName;
  final String uid;
  final String? lastMessage;

  const UserListItem({
    super.key,
    required this.userName,
    required this.uid,
    this.lastMessage,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Text('A'),
        ),
        title: Text(userName),
        subtitle: lastMessage == null ? null : Text(lastMessage!),
        onTap: () async {
          navigator.pushNamed(
            ChatScreen.routeName,
            arguments: {
              'uid': uid,
              'username': userName,
            },
          );
        },
      ),
    );
  }
}
