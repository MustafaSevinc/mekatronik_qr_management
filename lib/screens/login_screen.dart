import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/home_screen.dart';
import 'package:mekatronik_qr_management/services/auth_service.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import '../../utils/custom_colors.dart';
import '../../widgets/custom_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(46),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/mekatroniklogo.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration:
                        const InputDecoration(labelText: 'Kullanıcı Adı'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: CustomElevatedButton(
                  onPressed: () => _login(context),
                  buttonText: 'Giriş Yap',
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(height: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    UserCredential? credential = await AuthService.signInWithEmailAndPassword(
      "${_usernameController.text}@mail.com",
      _passwordController.text,
    );
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
