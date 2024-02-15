import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    if (message.image != null) {
      return ImageWithText(
        isMe: isMe,
        text: message.text,
        image: message.image!,
        time: message.time,
      );
    } else {
      return TextOnly(
        isMe: isMe,
        time: message.time,
        message: message.text!,
      );
    }
  }
}

class TextOnly extends StatelessWidget {
  final bool isMe;
  final String message;
  final DateTime time;

  const TextOnly({
    required this.isMe,
    required this.message,
    required this.time,
    super.key,
  });

  String get _hourMinute {
    return DateFormat(DateFormat.HOUR_MINUTE).format(time);
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      margin: const EdgeInsets.only(top: 6),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      backGroundColor: isMe
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.tertiary,
      clipper: ChatBubbleClipper4(
        type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message,
          ),
          const SizedBox(width: 8),
          Text(
            _hourMinute,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 11,
                ),
          ),
        ],
      ),
      // ),
    );
  }
}

class ImageWithText extends StatelessWidget {
  final bool isMe;
  final String? text;
  final String image;
  final DateTime time;

  const ImageWithText({
    super.key,
    required this.isMe,
    required this.text,
    required this.image,
    required this.time,
  });

  String get _hourMinute {
    return DateFormat(DateFormat.HOUR_MINUTE).format(time);
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      margin: const EdgeInsets.only(top: 6),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      backGroundColor: isMe
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.tertiary,
      clipper: ChatBubbleClipper4(
        type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: image,
              placeholder: (ctx, url) =>
                  Image.asset('assets/image_placeholder.jpg'),
              errorWidget: (ctx, url, error) =>
                  Image.asset('assests/image_placeholder.jpg'),
              fit: BoxFit.contain,
            ),
            if (text != null) const SizedBox(height: 5),
            if (text != null) Text(text!),
            Container(
              margin: const EdgeInsets.only(top: 5),
              alignment: Alignment.centerRight,
              child: Text(
                _hourMinute,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 11,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class VideoOnly extends StatelessWidget {
//   const VideoOnly({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class VideoAndText extends StatelessWidget {
  const VideoAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
