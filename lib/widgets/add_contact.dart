// ignore_for_file: use_build_context_synchronously

import 'package:chat_revamp/firebase/contacts.dart';
import 'package:flutter/material.dart';

class AddContactCard extends StatefulWidget {
  final BuildContext ctx;
  const AddContactCard(this.ctx, {super.key});

  @override
  State<AddContactCard> createState() => _AddContactCardState();
}

class _AddContactCardState extends State<AddContactCard> {
  final _controller = TextEditingController();

  String _contactToSearch = '';

  bool _isFound = false;
  bool _isAdding = false;

  void searchContact() async {
    if (_contactToSearch.isEmpty) {
      return;
    }
    var account = await Contacts.getContactFromEmail(_contactToSearch.trim());
    if (account.docs.isNotEmpty) {
      setState(() {
        _isFound = true;
      });
    } else {
      setState(() {
        _isFound = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                          labelText: 'Enter an email address'),
                      onChanged: (value) {
                        _contactToSearch = value;
                        searchContact();
                      },
                      onSubmitted: (value) => FocusScope.of(context).unfocus(),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: _isFound == false
                          ? null
                          : () async {
                              setState(() {
                                _isAdding = true;
                              });

                              bool added = await Contacts.addContact(
                                  _contactToSearch.trim());
                              setState(() {
                                _isAdding = false;
                              });
                              _controller.clear();
                              _contactToSearch = '';
                              Navigator.of(context).pop();
                              if (added == false) {
                                showDialog(
                                  context: widget.ctx,
                                  builder: (context) => AlertDialog(
                                    content:
                                        const Text('Can\'t add contact again !'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('OK'))
                                    ],
                                  ),
                                );
                              }
                            },
                      child: _isAdding == true
                          ? const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Send Request'),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
