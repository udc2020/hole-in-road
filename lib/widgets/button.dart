import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      this.primary = Colors.pink,
      required this.onPressed,
      this.text,
      this.children})
      : super(key: key);


  final Color? primary;
  final void Function()? onPressed;
  final String? text;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: primary, minimumSize: const Size(200, 50)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children!,
      ),
    );
  }
}
