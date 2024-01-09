import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkErrorDialog extends StatelessWidget {
  const NetworkErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: const Text('Network Error'),
        content: const Text('Please check your internet connection.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
