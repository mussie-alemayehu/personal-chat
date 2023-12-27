import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/messages.dart';

class Actions {
  static Future<void> sendMessges(Message message, String chatId) async {
    await FirebaseFirestore.instance.collection('chats/1v1/$chatId').add({
      'message': message.text,
      'image': message.image,
      'sentBy': message.sentBy,
      'time': message.time.toIso8601String(),
    });
    String type;
    if (message.image != null && message.text != null) {
      type = 'ImageAndText';
    } else if (message.image != null) {
      type = 'Image';
    } else {
      type = 'Text';
    }
    await FirebaseFirestore.instance.doc('chat_id/$chatId').update(
      {
        'lastMessageTime': DateTime.now().toIso8601String(),
        'lastMessageType': type,
        'lastMessage': message.text,
        'sentBy': message.sentBy,
      },
    );
  }
}
