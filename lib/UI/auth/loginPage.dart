// ignore_for_file: file_names, prefer_const_declarations

import 'package:app_wisata/UI/constanta.dart';
import 'package:app_wisata/UI/widget/navbar2.dart';
import 'package:app_wisata/models/errMsg.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_login/flutter_login.dart';

const users = {
  'sas@gmail.com': '12345',
  'sa@gmail.com': 'hunter',
};

// ignore: must_be_immutable, use_key_in_widget_constructors
class LoginScreen extends StatelessWidget {
  static var routeName = "login";
  late ErrorMSG res;
  // ignore: prefer_const_constructors
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    //print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      var params = {
        'email': data.name,
        'password': data.password,
        'device_name': 'flutterMobile'
      };
      res = await ApiStatic.sigIn(params);
      if (res.success != true) {
        return res.message;
      }
      return '';
    });
  }

  Future<String> _recoverPassword(String name) {
    // ignore: avoid_print
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = const BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );
    return FlutterLogin(
      // logo: 'assets/logo_wisata.png',
      // onLogin: _authUser,
      // title: 'APP',
      // // onSignup: _authUser,
      // onSubmitAnimationCompleted: () {
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => const Navbar(),
      //   ));
      // },
      // onRecoverPassword: _recoverPassword,
      title: 'WISATApps',
      logo: const AssetImage('assets/logo_wisata.png'),
      onLogin: _authUser,
      // ignore: null_check_always_fails
      onSignup: (_) => Future(null!),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Navbar2(),
        ));
      },
      // onRecoverPassword: (_) => Future(null),
      theme: LoginTheme(
        primaryColor: Constants.primaryColor,
        accentColor: Constants.secondaryColor,
        errorColor: Colors.deepOrange,
        titleStyle: const TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Quicksand',
            letterSpacing: 4,
            fontSize: 36,
            fontWeight: FontWeight.bold),
        bodyStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        textFieldStyle: const TextStyle(
          color: Constants.fontColor,
          shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
        ),
        buttonStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.yellow,
        ),
        cardTheme: CardTheme(
          color: Colors.yellow.shade100,
          elevation: 5,
          margin: const EdgeInsets.only(top: 25),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(80.0)),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.purple.withOpacity(.1),
          contentPadding: EdgeInsets.zero,
          errorStyle: const TextStyle(
            // backgroundColor: Colors.orange,
            color: Colors.red,
          ),
          labelStyle: const TextStyle(fontSize: 14),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade700, width: 4),
            borderRadius: inputBorder,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
            borderRadius: inputBorder,
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 7),
            borderRadius: inputBorder,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 8),
            borderRadius: inputBorder,
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 5),
            borderRadius: inputBorder,
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.purple,
          backgroundColor: Constants.primaryColor,
          highlightColor: Colors.lightGreen,
          elevation: 9.0,
          highlightElevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          // shape: CircleBorder(side: BorderSide(color: Colors.green)),
          // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
        ),
      ),
      onRecoverPassword: _recoverPassword,
    );
  }
}
