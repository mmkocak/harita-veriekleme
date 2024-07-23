import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentuser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges =>_firebaseAuth.authStateChanges() ;

  // Register
  Future<void> createUser(
      {required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
  // Login
  Future<void> signin({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
  // Log Out
  Future<void> SignOut() async{
    await _firebaseAuth.signOut();
  }
}
