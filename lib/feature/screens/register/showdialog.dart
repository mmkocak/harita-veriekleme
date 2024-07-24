  import 'package:flutter/material.dart';

class Showdialog extends StatefulWidget {
  final String message;
  const Showdialog({ Key? key, required this.message }) : super(key: key);

  @override
  _ShowdialogState createState() => _ShowdialogState();
}

class _ShowdialogState extends State<Showdialog> {
  
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text("Hata"),
      content: Text(widget.message),
      actions: [
        TextButton(
           child: const Text("Tamam"),      
           onPressed: () {
             Navigator.of(context).pop();
           },
           )
      ],
    );
  }
}
/* void ShowDialog(String? message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Hata"),
            content: Text(message ?? "Bilinmeyen bir hata oluştu"),
            actions: [
              TextButton(
                child: const Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  } */