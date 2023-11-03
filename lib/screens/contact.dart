// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:chat_revamp/firebase/contacts.dart';
import 'package:chat_revamp/widgets/add_contact.dart';
import 'package:chat_revamp/widgets/contact_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  void _goToChat(BuildContext context, String chatId, String contactId) async {
    Navigator.of(context).pushNamed('chats',
        arguments: {'chatId': chatId, 'contactId': contactId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('requests');
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Contacts.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>>? data;
          if (snapshot.hasData == false || snapshot.data!.docs.isEmpty) {
            data = null;
          } else {
            data = snapshot.data!.docs;
          }
          return data == null
              ? Center(
                  child: Text(
                    'Start adding friends :)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: ContactItem(data![index]),
                      onTap: () => _goToChat(
                          context, data![index]['chatId'], data[index].id),
                    );
                  },
                );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddContactCard(context),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
