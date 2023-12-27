import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './displayable_time.dart';
import '../screens/chat_screen.dart';

class UserListItem extends StatelessWidget {
  final String userName;
  final String uid;
  final String? imageUrl;
  final String? lastMessage;
  final String? lastMessageSentBy;
  final DateTime? lastMessageTime;

  const UserListItem({
    super.key,
    required this.userName,
    required this.uid,
    this.imageUrl,
    this.lastMessage,
    this.lastMessageSentBy,
    this.lastMessageTime,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    String? editedLastMessage = lastMessage;
    if (lastMessage != null && lastMessageSentBy == currentUser) {
      editedLastMessage = 'You: $lastMessage';
    }
    final navigator = Navigator.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: ListTile(
        leading: ProfilePicture(
          firstLetter: userName.substring(0, 1),
          imageUrl: imageUrl,
        ),
        title: Text(
          userName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: lastMessage == null
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editedLastMessage!,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  DisplayableTime(lastMessageTime!),
                ],
              ),
        onTap: () {
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
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
      ),
    );
  }
}
