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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    String? userId = SharedPref.getString(Constants.uidKey);

    if (userId != null) {
      _navigateToHomeScreen();
    }
  }

  void _navigateToHomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
        image: AssetImage('assets/images/mekatroniklogo.png'),
      fit: BoxFit.fitWidth,
    )
    ),
      child: Scaffold(
        appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,
        title: const Text('Giriş Yap'),
    ),
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
              )
          ),
        ),),
    Expanded(
      flex: 1,
    child: Container(
    child: TextFormField(
    controller: _usernameController,
    decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
    ),
    ),),
    Expanded(
      flex: 1,
    child: Container(
    child: TextFormField(
    controller: _passwordController,
    decoration: const InputDecoration(labelText: 'Şifre'),
    obscureText: true,
    ),
    ),),
    SizedBox(
      height: 10,
    ),
    Expanded(
      flex: 1,
    child: Container(
    child: CustomElevatedButton(
    onPressed: _login,
    buttonText: 'Giriş Yap',
    ),
    ),
    ),
      Expanded(
        flex: 1,
        child: Container(
          child: SizedBox(
            height: 20,
          ),
        ),),
    ],),),),),);
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
}
