import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/messages.dart';

class Actions {
  static Future<void> sendMessages(Message message, String chatId) async {
    await FirebaseFirestore.instance.collection('chats/1v1/$chatId').add({
      'message': message.text,
      'image': message.image,
      'sentBy': message.sentBy,
      'time': message.time.toIso8601String(),
    });
    String type;
    if (message.image != null) {
      type = 'ImageAndText';
    } else {
      type = 'Text';
    }
    await FirebaseFirestore.instance.doc('chat_id/$chatId').update(
      {
        'lastMessageTime': DateTime.now().toIso8601String(),
        'lastMessageType': type,
        'lastMessageImage': message.image,
        'lastMessage': message.text,
        'sentBy': message.sentBy,
      },
    );
  }
}
