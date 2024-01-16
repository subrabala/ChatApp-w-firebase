import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/drawer.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/message_screen.dart';

class ChatScreen extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const ChatScreen(
      {required this.firebaseAuth, required this.firestore, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String selectedPage = ' ';

  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthScreen()));
        print("User logged out successfully");
      } catch (e) {
        print("Error logging out: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'We Chat',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(28, 46, 70, 1),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(48, 64, 87, 1)),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))))),
            ),
          )
        ],
      ),
      drawer: DrawerWidget(
          selectedPage: selectedPage,
          onDrawerTap: (String page) {
            setState(() {
              selectedPage = page;
            });
          },
          signOut: signOut),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromRGBO(28, 46, 70, 1),
        shape: const CircleBorder(),
        child: const Icon(Icons.notification_add, color: Colors.white,),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        // stream = series of async events
        stream: widget.firestore.collection('users').snapshots(),
        // builder = tells what to do when a state occurs = useEffect
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _userListItem(doc))
                .toList(),
          );
        });
  }

  Widget _userListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    // display all users except current
    if (widget.firebaseAuth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: ListTile(
            title: Text(data['email']),
            leading: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ClipOval(
                child: Container(
                  height: 30,
                  width: 30,
                  color: Colors.lightBlue,
                  child: const Center(
                    child: Text('A'),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessageScreen(
                            receiverEmail: data['email'],
                            receiverID: data['uid'],
                          )));
            }),
      );
    } else {
      return const Text('');
    }
  }
}
