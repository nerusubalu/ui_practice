import 'package:flutter/material.dart';

// TextField textField(label,controller){
//   return
// }

var borderStyle = OutlineInputBorder(borderRadius: BorderRadius.circular(30));
var style = ElevatedButton.styleFrom(
    minimumSize: Size(160, 60),
    padding: EdgeInsets.all(12),
    elevation: 15,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))));

class textField extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const textField({super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 32,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
