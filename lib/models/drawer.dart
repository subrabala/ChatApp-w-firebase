import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/image.dart';
import 'package:image_picker/image_picker.dart';

class DrawerWidget extends StatefulWidget {
  final String selectedPage;
  final Function(String) onDrawerTap;
  final Function() signOut;

  const DrawerWidget(
      {required this.selectedPage,
      required this.onDrawerTap,
      required this.signOut,
      super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(28, 46, 70, 1),
              ),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                          backgroundImage:
                              _image != null ? MemoryImage(_image!) : null)),
                  Tooltip(
                    message: 'Select profile picture',
                    child: IconButton(
                        onPressed: selectImage, icon: const Icon(Icons.camera)),
                  ),
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.account_circle, size: 20),
              title: const Text('Account'),
              onTap: () {
                widget.onDrawerTap('Messages');
              }),
          ListTile(
            leading: const Icon(Icons.chat_rounded, size: 20),
            title: const Text('Chats'),
            onTap: () {
              widget.onDrawerTap('Chats');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, size: 20),
            title: const Text('Settings'),
            onTap: () {
              widget.onDrawerTap('Settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded, size: 20),
            title: const Text('Help'),
            onTap: () {
              widget.onDrawerTap('Help');
            },
          ),
          const Divider(
            color: Color.fromARGB(113, 0, 0, 0),
          ),
          ListTile(
            leading: const Icon(Icons.people, size: 20),
            title: const Text('Invite a friend'),
            onTap: () {
              widget.onDrawerTap('Help');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, size: 20),
            title: const Text('Log Out'),
            onTap: widget.signOut,
          ),
        ],
      ),
    );
  }
}
