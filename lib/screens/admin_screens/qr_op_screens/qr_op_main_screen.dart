import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/qr_op_screens/qr_scanner_screen.dart';

class QROpMainScreen extends StatelessWidget {
  const QROpMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, "Enter"),
            _buildButton(context, "Leave"),
            _buildButton(context, "Launch"),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String buttonText) {
    return ElevatedButton(
      onPressed: () {
        _onButtonPressed(context, buttonText);
      },
      child: Text(buttonText),
    );
  }

  void _onButtonPressed(BuildContext context, String buttonText) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(action: buttonText),
      ),
    );
  }
}
