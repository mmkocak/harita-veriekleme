import 'package:flutter/material.dart';
import 'package:harita_uygulama_yyu/feature/color/colors.dart';

class Showdialog extends StatefulWidget {
  final String message;
  const Showdialog({Key? key, required this.message}) : super(key: key);

  @override
  _ShowdialogState createState() => _ShowdialogState();
}

class _ShowdialogState extends State<Showdialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: orangeShade800,
      title: const Text(
        "Hata",
        style: TextStyle(color: white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      content: Text(
        widget.message,
        style: const TextStyle(color: white, fontSize: 16, ),
      ),
      actions: [
        TextButton(
          child: const Text(
            "Tamam",
            style: TextStyle(color: white, fontSize: 14),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}