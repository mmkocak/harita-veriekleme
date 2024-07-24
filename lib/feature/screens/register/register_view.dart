import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harita_uygulama_yyu/core/services/auth.dart';
import 'package:harita_uygulama_yyu/feature/color/colors.dart';
import 'package:harita_uygulama_yyu/feature/screens/login/login_screen.dart';
import 'package:harita_uygulama_yyu/feature/screens/register/StringsRegister.dart';
import 'package:harita_uygulama_yyu/feature/screens/register/showdialog.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();
  String? errorMessages;
  bool _obscureText = true;
  Future<void> createUser() async {
    if (emailControler.text.isEmpty && passwordControler.text.isEmpty) {
      setState(() {
        _showErrorDialog("Lütfen tüm alanları doldurun");
      });
    } 
      else if (passwordControler.text.length <= 6) {
        setState(() {
          _showErrorDialog("Parolla En az 6 karakter olmalı");
        });
        return;
      }
     else if (!emailControler.text.contains('@')) {
        setState(() {
          _showErrorDialog("Geçerli bir e-posta giriniz");
        });
        return;
      }
    

    try {
      await Auth().createUser(
          email: emailControler.text, password: passwordControler.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessages = e.message;
      });
      _showErrorDialog(errorMessages ?? "Bir hata oluştu");
    }
  }

// Show Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
     builder:(BuildContext context){
      return  Showdialog(message: message);
     },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                orangeShade900,
                orangeShade800,
                orangeShade400,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringsRegister.kayitOl,
                        style: TextStyle(color: white, fontSize: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        StringsRegister.hosgeldiniz,
                        style: TextStyle(color: white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: kahve,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: greySheed200),
                                ),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: StringsRegister.username,
                                  hintStyle: TextStyle(color: grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: greySheed200),
                                ),
                              ),
                              child: TextField(
                                controller: emailControler,
                                decoration: const InputDecoration(
                                  hintText: StringsRegister.email,
                                  hintStyle: TextStyle(color: grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: greySheed200)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      obscureText: _obscureText,
                                      controller: passwordControler,
                                      decoration: InputDecoration(
                                        hintText: StringsRegister.sifre,
                                        hintStyle: const TextStyle(color: grey),
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                          icon: Icon(_obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      //Kayıt Ol
                      MaterialButton(
                        onPressed: () {
                          createUser();
                        },
                        height: 50,
                        color: orangeShade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            StringsRegister.kayitOl,
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        StringsRegister.hesapvarmi,
                        style: TextStyle(color: grey),
                      ),
                      //Giriş Yap yönlendir
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: Text(
                          StringsRegister.girisYap,
                          style: TextStyle(
                            color: orangeShade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
