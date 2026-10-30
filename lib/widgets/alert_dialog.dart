import 'package:flutter/material.dart';
import 'package:tournament_organizer/generated/l10n.dart';

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
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(S.of(context).delete),
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
