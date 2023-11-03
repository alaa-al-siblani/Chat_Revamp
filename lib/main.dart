import 'package:chat_revamp/screens/auth.dart';
import 'package:chat_revamp/screens/chat.dart';
import 'package:chat_revamp/screens/contact.dart';
import 'package:chat_revamp/screens/requests.dart';
import 'package:chat_revamp/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // await user.User.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.white, primary: Colors.teal),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const SplashScreen();
          }
          if (snapshot.hasData == true) {
            return const ContactsScreen();
          }
          return const AuthScreen();
        },
      ),
      routes: {
        'chats': (context) => const ChatsScreen(),
        'requests': (context) => const RequestsScreen(),
      },
    );
  }
}
