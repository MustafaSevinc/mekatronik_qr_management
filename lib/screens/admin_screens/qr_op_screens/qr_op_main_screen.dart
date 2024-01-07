import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/qr_op_screens/qr_scanner_screen.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';
import 'package:mekatronik_qr_management/widgets/custom_icon_button.dart';

class QROpMainScreen extends StatelessWidget {
  const QROpMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appBarBodyColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildButton(context, "giris"),
              const SizedBox(height: 50.0),
              _buildButton(context, "cikis"),
              const SizedBox(height: 50.0),
              _buildButton(context, "yemek"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String buttonText) {
    return CustomIconButton(
      text: buttonText,
      iconData: Icons.qr_code_scanner,
      onPressed: () {
        _onButtonPressed(context, buttonText);
      },
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
