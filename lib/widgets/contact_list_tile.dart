import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> _contact;
  const ContactItem(this._contact, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            backgroundImage: _contact.data().containsKey('imageUrl')
                ? NetworkImage(_contact.data()['imageUrl'])
                : Image.asset('assets/images/profile.png') as ImageProvider,
          ),
          title: Text(
            _contact['username'],
            style: const TextStyle(fontSize: 22),
          )),
    );
  }
}
