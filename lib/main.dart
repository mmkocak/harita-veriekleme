import 'package:flutter/material.dart';
import 'package:harita_uygulama_yyu/feature/color/colors.dart';
import 'package:harita_uygulama_yyu/feature/main/main_text.dart';
import 'package:harita_uygulama_yyu/feature/screens/login/login_screen.dart';
import 'package:harita_uygulama_yyu/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MapApp());
}
class MapApp extends StatelessWidget {
  MapApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.title,
      theme: ThemeData(
        primarySwatch: green,
      ),
      home: const LoginScreen(),
    );
  }
}
