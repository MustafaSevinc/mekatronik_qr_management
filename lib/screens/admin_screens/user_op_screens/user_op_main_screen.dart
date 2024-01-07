import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/user_op_screens/checklist_employee_screen.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/user_op_screens/register_screen.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/user_op_screens/user_list_screen.dart';
import 'package:mekatronik_qr_management/widgets/custom_icon_button.dart';

import '../../../utils/custom_colors.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomIconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                text: 'Ekle',
                iconData: Icons.person,
              ),
              const SizedBox(height: 50),
              CustomIconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserList()),
                  );
                },
                text: 'Listele',
                iconData: Icons.list,
              ),
              const SizedBox(height: 50),
              CustomIconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChecklistEmployee()),
                  );
                },
                text: 'Savunma',
                iconData: Icons.newspaper,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
