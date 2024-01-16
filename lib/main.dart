import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyB9tiRyQC1UMHsG4fU8u2T-n-Ym3TZViYs',
          appId: '1:977710342491:android:9fbd7b9e8f4dc54a727a7e',
          messagingSenderId: '977710342491',
          projectId: 'chatapp-cd74b'));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          )),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
