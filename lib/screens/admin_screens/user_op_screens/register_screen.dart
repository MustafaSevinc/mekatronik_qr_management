import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/services/auth_service.dart';
import 'package:mekatronik_qr_management/widgets/custom_elevated_button.dart';
import 'package:mekatronik_qr_management/widgets/popup.dart';
import '../../../utils/custom_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isButtonPressed = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.textButtonColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.appBarColor,
        title: const Text('Mekatronik'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'TC Kimlik No'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir kimlik numarası girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'İsim'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir isim girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(labelText: 'Soyisim'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir soyisim girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir şifre girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon No'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir telefon numarası girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      _emailController.text = "empty@mail.com";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                CustomElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isButtonPressed = true;
                      });
                      User? user =
                          await AuthService.registerWithEmailAndPassword(
                        _idController.text,
                        _emailController.text,
                        _passwordController.text,
                        _nameController.text,
                        _surnameController.text,
                        _phoneController.text,
                      );
                      if (user != null) {
                        Navigator.pop(context);
                        popUp(context, "Kayıt başarılı",
                            "Kullanıcı başarıyla kaydedildi");
                        // User registered successfully
                      } else {
                        popUp(context, "Kayıt Başarısız",
                            "Kullanıcı Kaydı Zaten Var veya Bilgileri Hatalı Girdiniz");
                      }
                      setState(() {
                        isButtonPressed = false;
                      });
                    }
                  },
                  buttonText: 'Kullanıcıyı Kaydet',
                  child: isButtonPressed
                      ? const CircularProgressIndicator()
                      : null,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
