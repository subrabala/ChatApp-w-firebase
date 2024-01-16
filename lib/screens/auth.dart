import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // firebase instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  var _enteredEmail = '';
  var _enteredPassword = '';

// ---------LOG IN----------------------
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    // if user doesn't exist then create a document and merge
    await _firestore.collection('users').doc(userCred.user!.uid).set(
        {'uid': userCred.user!.uid, 'email': _enteredEmail},
        SetOptions(merge: true));
    return userCred;
  }

// ---------CREATE USER-------------------
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCred = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    // create a new user in the collection
    await _firestore
        .collection('users')
        .doc(userCred.user!.uid)
        .set({'uid': userCred.user!.uid, 'email': _enteredEmail});
    return userCred;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        if (_isLogin) {
          await signInWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );
        } else {
          await createUserWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
        }
        
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      firebaseAuth: _firebaseAuth,
                      firestore: _firestore,
                    )));
      } catch (err) {
        // print('Authentication Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(28, 46, 70, 1),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 20, right: 20),
                  width: 250,
                  height: 250,
                  child: Image.asset('assets/chat.png'),
                ),
                Container(
                  height: 450,
                  child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isLogin ? 'Login' : 'Sign Up',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 30),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Email Address'),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email address.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    _enteredEmail = value!;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Password'),
                                  autocorrect: false,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return 'Please must be atleast 6 characters';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    _enteredPassword = value!;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        backgroundColor:
                                            const Color.fromRGBO(28, 46, 70, 1),
                                        textStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.bold),
                                        minimumSize:
                                            const Size(double.infinity, 50)),
                                    child: Text(
                                      _isLogin ? 'Login' : 'Sign Up',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(
                                      _isLogin
                                          ? 'Create an account'
                                          : 'I already have an account',
                                      style: const TextStyle(fontSize: 12.0)),
                                ),
                              ],
                            )),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
