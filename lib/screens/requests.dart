import 'package:chat_revamp/firebase/contacts.dart';
import 'package:chat_revamp/widgets/request_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Requests'),
      ),
      body: StreamBuilder(
        stream: Contacts.getRequests(),
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
                    'No Requests :(',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return RequestItem(data![index]);
                  },
                );
        },
      ),
    );
  }
}
