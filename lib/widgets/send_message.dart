import 'package:chat_revamp/firebase/chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  final String _chatId ;
  const SendMessage(this._chatId, {super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {

  final _messageController = TextEditingController();
  String _message = '';
  final _id = FirebaseAuth.instance.currentUser!.uid;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Message'),
                    controller: _messageController,
                    onChanged: (value) => setState(() {
                      _message = value;
                    }),
                    onSubmitted: (value) =>
                        Navigator.of(context).focusNode.unfocus(),
                  ),
                ),
                IconButton(
                  onPressed: _message.isEmpty
                      ? null
                      : () {
                          Chats.addMessage(widget._chatId, _message, _id);
                          _messageController.clear();
                          setState(() {
                            _message = '';
                          });
                        },
                  icon: Icon(
                    Icons.send,
                    color: _message.isEmpty
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          );
  }
}