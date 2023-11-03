import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  static Future<String> createChat() async {
    final db = FirebaseFirestore.instance;
    final chatRef = db.collection('chats').doc();
    await chatRef.set({});
    return chatRef.id;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChat(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }
  static void addMessage(String chatId, String message, String id)
  {
    FirebaseFirestore.instance.collection('/chats/$chatId/messages').add({
      'text': message,
      'sentAt': Timestamp.now(),
      'senderId': id,
    });
  }
}
