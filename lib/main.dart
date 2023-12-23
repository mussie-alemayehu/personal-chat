import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import './firebase_options.dart';
import './themes/light.dart';
import './screens/auth_screen.dart';
import './screens/chat_screen.dart';
import './screens/chats_list_screen.dart';
import './screens/available_users_screen.dart';
import '../screens/edit_profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return const ChatsListScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
      routes: {
        ChatScreen.routeName: (_) => const ChatScreen(),
        AvailableUsersScreen.routeName: (_) => const AvailableUsersScreen(),
        EditProfileScreen.routeName: (_) => const EditProfileScreen(),
      },
    );
  }
}
