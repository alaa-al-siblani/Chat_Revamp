import 'package:chat_revamp/firebase/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestItem extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> _contact;
  const RequestItem(this._contact, {super.key});

  @override
  State<RequestItem> createState() => _RequestItemState();
}

class _RequestItemState extends State<RequestItem> {

 bool _isAccepting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 25,
          backgroundImage: widget._contact.data().containsKey('imageUrl')
              ? NetworkImage(widget._contact.data()['imageUrl'])
              : const AssetImage('assets/images/profile.png') as ImageProvider,
        ),
        title: Text(
          widget._contact['username'],
          style: const TextStyle(fontSize: 22),
        ),
        trailing:_isAccepting == true? CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,) : IconButton(
          icon: Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
          onPressed: () async{
            setState(() {
              _isAccepting = true;
            });
            await Contacts.acceptRequest(widget._contact.id);
            setState(() {
              _isAccepting = false;
            });
          }
        ),
      ),
    );
  }
}
