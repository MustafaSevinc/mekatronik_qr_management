import 'package:flutter/material.dart';
import '../utils/custom_colors.dart';

/// A custom button widget with elevated style.
///
/// This button can be used to display text or a child widget inside an elevated button.
class CustomElevatedButton extends StatelessWidget {
  /// Function to be called when the button is pressed.
  final VoidCallback onPressed;

  /// Text to display inside the button.
  final String buttonText;

  /// Text color of the button.
  final Color textColor;

  /// A widget to be displayed inside the button instead of text.
  final Widget? child;

  /// Creates a [CustomElevatedButton] with the given [onPressed] and [buttonText].
  /// Optionally, a [textColor] and [child] can be provided.
  const CustomElevatedButton({
    super.key, // Corrected key parameter
    required this.onPressed,
    required this.buttonText,
    this.textColor = CustomColors.textButtonColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(CustomColors.appBarColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: child ??
          Text(
            buttonText,
            style: TextStyle(
              color: textColor,
            ),
          ),
    );
  }
}
