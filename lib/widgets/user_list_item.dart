import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class UserListItem extends StatelessWidget {
  final String userName;
  final String uid;
  final String? imageUrl;
  final String? lastMessage;

  const UserListItem({
    super.key,
    required this.userName,
    required this.uid,
    this.imageUrl,
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
        leading: CircleAvatar(
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl != null
              ? null
              : Text(
                  userName.substring(0, 1),
                ),
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
