import 'package:cloud_firestore/cloud_firestore.dart';

class Actions {
  static Future<void> sendMessges({
    required String chatId,
    required String message,
    required String sentBy,
  }) async {
    await FirebaseFirestore.instance.collection('chats/1v1/$chatId').add({
      'message': message,
      'sentBy': sentBy,
      'time': DateTime.now().toIso8601String(),
    });
    print('updating field lastMessage');
    await FirebaseFirestore.instance.doc('chat_id/$chatId').update(
      {
        'lastMessage': DateTime.now().toIso8601String(),
      },
    );
  }
}
