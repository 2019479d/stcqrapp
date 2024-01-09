import 'package:flutter/material.dart';

class AlertBoxWidget extends StatefulWidget {
  final String title;
  final Widget? content;
  final String buttonTitle;
  final VoidCallback? onPressed;
  final Widget? textButton2;

  const AlertBoxWidget({
    Key? key,
    required this.title,
    this.content,
    required this.buttonTitle,
    required this.onPressed,
    this.textButton2,
  }) : super(key: key);

  @override
  State<AlertBoxWidget> createState() => _AlertBoxWidgetState();
}

class _AlertBoxWidgetState extends State<AlertBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        // textAlign: widget.content == null ? TextAlign.center : TextAlign.left,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
      content: widget.content,
      actions: [
        TextButton(
            onPressed: widget.onPressed, child: Text(widget.buttonTitle)),
        widget.textButton2 ?? const SizedBox(),
      ],
    );
  }
}
