import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String _message;
  final bool _isMe;
  const MessageBubble(this._message, this._isMe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isMe ? Theme.of(context).colorScheme.primary : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_isMe ? 12 : 5),
            topRight: Radius.circular(_isMe ? 5 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset:
                  Offset(_isMe ? 3 : -3, 3), // Adjust shadow offset as needed
            ),
          ],
        ),
        child: Text(
          _message,
          style: TextStyle(
            fontSize: 16,
            color: _isMe ? Colors.white : Colors.black,
          ),
          textAlign: _isMe ? TextAlign.start : TextAlign.end,
        ),
      ),
    );
  }
}
