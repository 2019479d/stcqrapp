import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final String label;
  const LabelWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
      alignment: Alignment.topLeft,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
