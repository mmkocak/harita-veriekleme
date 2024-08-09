// lib/feature/screens/forgot_password/forgot_password_buttons.dart
import 'package:flutter/material.dart';
import 'package:harita_uygulama_yyu/feature/screens/login/login_screen.dart';
import 'package:harita_uygulama_yyu/feature/color/colors.dart';

class ForgotPasswordButtons extends StatelessWidget {
  final VoidCallback onResetPassword;

  const ForgotPasswordButtons({Key? key, required this.onResetPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          onPressed: onResetPassword,
          height: 50,
          color: orangeShade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Text(
              "Şifreyi Sıfırla",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        MaterialButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          height: 50,
          color: orangeShade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Text(
              "Giriş Ekranına Dön",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
