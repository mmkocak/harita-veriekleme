import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harita_uygulama_yyu/feature/mixins/error_handling_mixin.dart';
import 'package:harita_uygulama_yyu/feature/screens/forgotPassword/forgot_password_background.dart';
import 'package:harita_uygulama_yyu/feature/screens/forgotPassword/forgot_password_form.dart';
import 'package:harita_uygulama_yyu/feature/screens/forgotPassword/forgot_password_buttons.dart';



class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with ErrorHandlingMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _sendPasswordResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        showSuccessDialog(context, 'Şifre sıfırlama e-postası gönderildi. Lütfen e-posta adresinizi kontrol edin.');
      } catch (e) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ForgotPasswordBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                      ForgotPasswordForm(
                        formKey: _formKey,
                        emailController: _emailController,
                      ),
                      const SizedBox(height: 40),
                      ForgotPasswordButtons(
                        onResetPassword: _sendPasswordResetEmail,
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
