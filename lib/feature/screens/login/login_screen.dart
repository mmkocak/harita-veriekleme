import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harita_uygulama_yyu/core/services/auth.dart';
import 'package:harita_uygulama_yyu/feature/color/colors.dart';
import 'package:harita_uygulama_yyu/feature/screens/login/Strings.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();

  String? errorMessages;
 Future<void> signin() async{
  try{
    await Auth().signin(email: emailControler.text, password: passwordControler.text);
  }on FirebaseException catch(e){
    setState(() {
      errorMessages = e.message;
    });
  }
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
              const SizedBox(
                height: 80,
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringsLogin.girisYap,
                        style: TextStyle(color: white, fontSize: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        StringsLogin.hosgeldiniz,
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
                              child:  TextField(
                                controller: emailControler,
                                decoration: const InputDecoration(
                                  hintText: StringsLogin.girisTextField,
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
                              child:  Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: passwordControler,
                                      decoration: const InputDecoration(
                                        hintText: StringsLogin.sifreTextField,
                                        hintStyle: TextStyle(color: grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    
                                  ),
                                  /*  
                                  IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {},
                                  )
                                  */
                                  errorMessages != null ? Text(errorMessages!) : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        StringsLogin.sifremiUnuttum,
                        style: TextStyle(color: grey),
                      ),
                      const SizedBox(height: 40),
                      MaterialButton(
                        onPressed: () {
                          
                        },
                        height: 50,
                        color: orangeShade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            StringsLogin.girisYap,
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          
                        },
                        height: 50,
                        color: orangeShade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            StringsLogin.kayitOl,
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
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
