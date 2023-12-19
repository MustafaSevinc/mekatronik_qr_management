import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/home_screen.dart';
import 'package:mekatronik_qr_management/services/auth_service.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import '../../utils/custom_colors.dart';
import '../../widgets/custom_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() async {
    String? userId = SharedPref.getString(Constants.uidKey);
    if (userId != null) {
      _navigateToHomeScreen();
    }
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String logoImage = "assets/img/mekatroniklogo.png";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,
        title: const Text('Giriş Yap'),
      ),
      backgroundColor: CustomColors.textButtonColor,
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildImageContainer(logoImage, height),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                onPressed: _login,
                buttonText: 'Giriş Yap',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    UserCredential? credential = await AuthService.signInWithEmailAndPassword(
      "${_usernameController.text}@mail.com",
      _passwordController.text,
    );

    if (credential == null) {
      _showSnackBar('Giriş Yapılamadı');
      return;
    }

    SharedPref.setString(Constants.uidKey, credential.user!.uid);
    _navigateToHomeScreen();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Container _buildImageContainer(String logoImage, double height) {
    return Container(
      height: height * .13,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(logoImage),
        ),
      ),
    );
  }
}
