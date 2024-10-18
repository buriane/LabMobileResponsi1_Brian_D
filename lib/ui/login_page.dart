import 'package:flutter/material.dart';
import 'package:responsi/bloc/login_bloc.dart';
import 'package:responsi/helpers/user_info.dart';
import 'package:responsi/ui/pasien_page.dart';
import 'package:responsi/ui/registrasi_page.dart';
import 'package:responsi/widget/warning_dialog.dart';
import '../widget/success_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  final primaryGreen = const Color(0xFF4CAF50);
  final accentYellow = const Color(0xFFFFEB3B);
  final backgroundColor = const Color(0xFFF1F8E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sans-serif',
          ),
        ),
        backgroundColor: primaryGreen,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryGreen.withOpacity(0.3),
              backgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _emailTextField(),
                  const SizedBox(height: 20),
                  _passwordTextField(),
                  const SizedBox(height: 40),
                  _buttonLogin(),
                  const SizedBox(height: 30),
                  _menuRegistrasi(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        style: const TextStyle(fontFamily: 'Sans-serif'),
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(
            color: primaryGreen,
            fontFamily: 'Sans-serif',
          ),
          prefixIcon: Icon(Icons.email, color: primaryGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: TextInputType.emailAddress,
        controller: _emailTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email harus diisi';
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        style: const TextStyle(fontFamily: 'Sans-serif'),
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(
            color: primaryGreen,
            fontFamily: 'Sans-serif',
          ),
          prefixIcon: Icon(Icons.lock, color: primaryGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _passwordTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, accentYellow],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sans-serif',
            color: Colors.white,
          ),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token ?? "");
        await UserInfo().setUserID(int.tryParse(value.userID.toString()) ?? 0);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Login berhasil",
            okClick: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PasienPage(),
                ),
              );
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Login gagal, silahkan coba lagi",
          ),
        );
      }
    }, onError: (error) {
      print(error);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Login gagal, silahkan coba lagi",
        ),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: Text(
          "Belum punya akun? Registrasi",
          style: TextStyle(
            color: primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Sans-serif',
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}