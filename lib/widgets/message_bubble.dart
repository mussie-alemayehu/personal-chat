import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../models/messages.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble(
    this.message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    bool isMe;
    if (currentUser == message.sentBy) {
      isMe = true;
    } else {
      isMe = false;
    }
    return TextOnly(
      isMe: isMe,
      message: message.text!,
    );
  }
}

class TextOnly extends StatelessWidget {
  final bool isMe;
  final String message;

  const TextOnly({
    required this.isMe,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      margin: const EdgeInsets.all(10),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      backGroundColor: isMe
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.tertiary,
      clipper: isMe
          ? ChatBubbleClipper4(type: BubbleType.sendBubble)
          : ChatBubbleClipper4(type: BubbleType.receiverBubble),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message,
        ),
      ),
    );
  }
}

class ImageOnly extends StatelessWidget {
  const ImageOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class VideoOnly extends StatelessWidget {
  const VideoOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ImageAndText extends StatelessWidget {
  const ImageAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class VideoAndText extends StatelessWidget {
  const VideoAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
