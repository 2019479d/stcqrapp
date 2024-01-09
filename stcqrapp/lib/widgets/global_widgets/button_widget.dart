import 'package:flutter/material.dart';
import 'package:stcqrapp/configs/custom_colors.dart';

class ButtonWidget extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final bool? boxShadow;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  const ButtonWidget({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.backgroundColor,
    this.boxShadow = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 5,
        minimumSize: Size(widget.width, widget.height),
        backgroundColor: widget.backgroundColor ?? CustomColors.brownColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
      child: widget.child,
    );
  }
}
