import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixWidget;
  final void Function()? onTap;
  final bool obscureText;
  final String hintText;
  final int? maxLines;
  final int? maxLength;

  const TextFieldWidget({
    Key? key,
    this.controller,
    this.keyboardType,
    this.suffixWidget,
    this.onTap,
    this.obscureText = false,
    this.hintText = '',
    this.maxLines,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: false,
      onTap: onTap,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.normal,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black.withOpacity(0.65),
            ),
        suffix: suffixWidget,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1, color: Colors.brown),
        ),
      ),
    );
  }
}
