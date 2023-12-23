import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  const MessageBubble({
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
