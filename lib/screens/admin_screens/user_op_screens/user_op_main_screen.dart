import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/user_op_screens/checklist_employee_screen.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/user_op_screens/register_screen.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/user_op_screens/user_list_screen.dart';

import '../../../utils/custom_colors.dart';
import '../../../widgets/custom_elevated_button.dart';

class UserOpMainScreen extends StatefulWidget {
  const UserOpMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserOpMainScreenState();
}

class _UserOpMainScreenState extends State<UserOpMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.textButtonColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
          ),
          CustomElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            buttonText: 'Kaydet',
          ),
          const SizedBox(height: 50),
          CustomElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserList()),
              );
            },
            buttonText: 'Listele',
          ),
          const SizedBox(height: 50),
          CustomElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChecklistEmployee()),
              );
            },
            buttonText: 'Savunma',
          ),
        ],
      ),
    );
  }
}
