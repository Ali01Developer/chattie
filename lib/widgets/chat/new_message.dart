import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = '';

  final _messageController = TextEditingController();

  void _sendMessgae() async {
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser;
    final userdata = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();
    FirebaseFirestore.instance.collection("chats").add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user?.uid ?? "",
        'userName': userdata['userName'],
        'userImage': userdata['image_url']
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: "Type your message....."),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessgae,
            icon: Icon(
              Icons.send,
            ),
          )
        ],
      ),
    );
  }
}
