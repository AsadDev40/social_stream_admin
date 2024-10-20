import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_stream_admin/services/app_provider.dart';

import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppProvider(
    child: MaterialApp(
      home: MainScreen(),
    ),
  ));
}
