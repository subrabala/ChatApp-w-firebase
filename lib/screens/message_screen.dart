import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat_service.dart';

class MessageScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const MessageScreen(
      {required this.receiverEmail, required this.receiverID, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // if there is some text in the input field only then send it
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      // after sending the message, clear the input field
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(28, 46, 70, 1),
          title: Text(
            widget.receiverEmail,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
      body: Column(children: [
        // messages
        Expanded(child: _buildMessageList()),

        // user Input field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                    controller: _messageController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: "Enter message",
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(28, 46, 70, 1),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  // message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }

          return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList());
        });
  }

  // message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        padding: const EdgeInsets.only(top: 10),
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Text(
                data['senderEmail'],
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                      color:
                          (data['senderId'] == _firebaseAuth.currentUser!.uid)
                              ? const Color.fromARGB(255, 139, 208, 240)
                              : const Color.fromARGB(255, 181, 227, 128),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0))),
                  child: Text(data['message']))
            ]));
  }
}
