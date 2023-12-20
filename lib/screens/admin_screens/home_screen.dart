import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/export_screens/export_xml.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/qr_op_screens/qr_op_main_screen.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/user_op_screens/user_op_main_screen.dart';
import 'package:mekatronik_qr_management/screens/login_screen.dart';
import 'package:mekatronik_qr_management/services/auth_service.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';
import 'package:mekatronik_qr_management/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const UserOpMainScreen();
      case 1:
        return const QROpMainScreen();
      case 2:
        return const ExportXmlScreen();
      default:
        return const QROpMainScreen();
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: CustomColors.appBarColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _onLogoutPressed,
      ),
      title: const Text('Mekatronik'),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onLogoutPressed() async {
    SharedPref.clear();
    await AuthService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
