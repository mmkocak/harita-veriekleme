import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harita_uygulama_yyu/feature/color/colors.dart';
import 'package:harita_uygulama_yyu/feature/screens/home/home_page.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentuser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final userCollections = FirebaseFirestore.instance.collection("users");
  Future<void> _registerUser(
      {required String name,
      required String email,
      required String password}) async {
    await userCollections
        .doc()
        .set({"email": email, "name": name, "password": password});
  }

  // Register
  Future<void> createUser(
      {required BuildContext context,
      required String name,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        _registerUser(name: name, email: email, password: password);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>   HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessages;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessages = "Bu email adresi alınamıyor";
          break;
        case 'weak-password':
          errorMessages = 'Parola çok zayıf.';
          break;
        default:
          errorMessages = 'Bilinmeyen bir hata oluştu.';
      }
      Fluttertoast.showToast(
        msg: errorMessages,
        textColor: white,
        backgroundColor: red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
    }
  }

  // Login
  Future<void> signin(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>  HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessages;
      switch (e.code) {
        case 'user-not-found':
        errorMessages = "Kullanıcı bulunamadı.";
        break;
         case 'email-already-in-use':
        errorMessages = "Bu email adresi alınamıyor";
        break;
        case 'weak-password':
          errorMessages = 'Parola çok zayıf.';
          break;
          case 'wrong-password':
        errorMessages = 'Yanlış parola.';
        break;
        default:
          errorMessages = 'Bilinmeyen bir hata oluştu.';
      }
      Fluttertoast.showToast(
        msg: errorMessages,
        textColor: white,
        backgroundColor: red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
    }
  }
}
