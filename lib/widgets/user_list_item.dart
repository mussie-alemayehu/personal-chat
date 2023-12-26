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
          radius: 25,
          child: ProfilePicture(
            firstLetter: userName.substring(0, 1),
            imageUrl: imageUrl,
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

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final String firstLetter;

  // ignore: constant_identifier_names
  static const double RADIUS = 25;

  const ProfilePicture({
    this.imageUrl,
    required this.firstLetter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2 * RADIUS,
      height: 2 * RADIUS,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RADIUS),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RADIUS),
        child: imageUrl != null
            ? FadeInImage(
                placeholder: const AssetImage('assets/person_placeholder.jpg'),
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : Center(
                child: Text(
                  firstLetter,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
