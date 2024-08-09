
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const ForgotPasswordForm({
    Key? key,
    required this.formKey,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'E-posta Adresi',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen e-posta adresinizi girin';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Geçersiz e-posta adresi';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
