import 'package:flutter/material.dart';

Future<void> popUp(BuildContext context, String header, String metin) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(header),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(metin),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Devam Et'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
