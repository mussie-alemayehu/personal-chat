import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './displayable_time.dart';
import '../screens/chat_screen.dart';

class UserListItem extends StatelessWidget {
  final String userName;
  final String uid;
  final String? lastMessageType;
  final String? profilePicture;
  final String? lastMessage;
  final String? lastMessageImage;
  final String? lastMessageSentBy;
  final DateTime? lastMessageTime;

  const UserListItem({
    super.key,
    required this.userName,
    required this.uid,
    this.lastMessageType,
    this.profilePicture,
    this.lastMessage,
    this.lastMessageImage,
    this.lastMessageSentBy,
    this.lastMessageTime,
  });

  Widget? _subtitleBuilder(BuildContext context) {
    Widget? subtitle;
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    if (lastMessageType == 'Text') {
      subtitle = lastMessage == null
          ? null
          : Text(
              'You: $lastMessage',
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            );
    } else {
      subtitle = lastMessageImage != null
          ? Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lastMessageSentBy == currentUser)
                  Text(
                    'You: ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const Icon(
                  Icons.image,
                  size: 20,
                  color: Colors.black54,
                ),
                if (lastMessage != null)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        lastMessage!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
              ],
            )
          : null;
    }

    return subtitle;
  }

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
        leading: ProfilePicture(
          firstLetter: userName.substring(0, 1),
          profilePicture: profilePicture,
        ),
        title: Text(
          userName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: (lastMessage != null || lastMessageImage != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: _subtitleBuilder(context)!,
                  ),
                  DisplayableTime(lastMessageTime!),
                ],
              )
            : null,
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
  final String? profilePicture;
  final String firstLetter;

  // ignore: constant_identifier_names
  static const double RADIUS = 25;

  const ProfilePicture({
    this.profilePicture,
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
        child: profilePicture != null
            ? FadeInImage(
                placeholder: const AssetImage('assets/person_placeholder.jpg'),
                image: NetworkImage(profilePicture!),
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
