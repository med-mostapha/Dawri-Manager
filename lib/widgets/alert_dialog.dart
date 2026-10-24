import 'package:flutter/material.dart';

Future<void> showDeleteDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Future<void> Function() onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
            onPressed: () async {
              Navigator.of(context).pop();
              await onConfirm();
            },
          ),
        ],
      );
    },
  );
}
