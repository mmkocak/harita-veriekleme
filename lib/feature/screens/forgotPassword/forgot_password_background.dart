import 'package:flutter/material.dart';
import 'package:harita_uygulama_yyu/feature/color/colors.dart';

class ForgotPasswordBackground extends StatelessWidget {
  final Widget child;

  const ForgotPasswordBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            orangeShade400,
            orangeShade800,
            orangeShade400,
          ],
        ),
      ),
      child: child,
    );
  }
}
