import 'package:chat_revamp/firebase/chats.dart';
import 'package:chat_revamp/firebase/contacts.dart';
import 'package:chat_revamp/widgets/message_bubble.dart';
import 'package:chat_revamp/widgets/send_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late String _chatId;
  late String _contactId;
  late User _user;

  @override
  void didChangeDependencies() {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    _chatId = data['chatId'];
    _contactId = data['contactId'];
    _user = FirebaseAuth.instance.currentUser!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Contacts.getContactFromId(_contactId),
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          leading: snapshot.connectionState == ConnectionState.waiting
              ? null
              : GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 18,
                        backgroundImage: snapshot.data!
                                .data()!
                                .containsKey('imageUrl')
                            ? NetworkImage(snapshot.data!.data()!['imageUrl'])
                            : const AssetImage('assets/images/profile.png')
                                as ImageProvider,
                      ),
                    ],
                  ),
                ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: snapshot.connectionState == ConnectionState.waiting
              ? const Text('')
              : Text(snapshot.data!.data()!['username']),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Chats.getChat(_chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs;
                  if (snapshot.hasData == false ||
                      snapshot.data!.docs.isEmpty) {
                    docs = null;
                  } else {
                    docs = snapshot.data!.docs;
                  }
                  return docs == null
                      ? Center(
                          child: Text(
                            'Start chatting !!',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: docs.length,
                          itemBuilder: (ctx, index) => MessageBubble(
                              docs![index]['text'],
                              _user.uid == docs[index]['senderId']),
                        );
                },
              ),
            ),
            SendMessage(_chatId),
          ],
        ),
      ),
    );
  }
}
