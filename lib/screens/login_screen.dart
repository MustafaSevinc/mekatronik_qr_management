import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/home_screen.dart';
import 'package:mekatronik_qr_management/services/auth_service.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import '../../utils/custom_colors.dart';
import '../../widgets/custom_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoggingIn = false;

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<bool> _checkCurrentUser() async {
    String? userId = SharedPref.getString(Constants.uidKey);
    String? userName = SharedPref.getString(Constants.userName);
    String? userPassword = SharedPref.getString(Constants.userPassword);

    return (userId != null && userName != null && userPassword != null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.data == true) {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return _buildLoginScreen(context);
        }
      },
    );
  }

  Scaffold _buildLoginScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.textButtonColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  Constants.logo,
                  fit: BoxFit.fitWidth,
                  height: 150.0,
                ),
                const SizedBox(height: 80.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  onPressed: () => _login(context),
                  buttonText: 'Giriş Yap',
                  child:
                      _isLoggingIn ? const CircularProgressIndicator() : null,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    setState(() {
      _isLoggingIn = true;
    });

    UserCredential? credential = await AuthService.signInWithEmailAndPassword(
      "${_usernameController.text}@mail.com",
      _passwordController.text,
    );
    setState(() {
      _isLoggingIn = false;
    });

    if (credential == null) {
      _showSnackBar(context, 'Giriş Yapılamadı');
      return;
    }
    SharedPref.setString(Constants.uidKey, credential.user!.uid);
    SharedPref.setString(Constants.userName, _usernameController.text);
    SharedPref.setString(Constants.userPassword, _passwordController.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
