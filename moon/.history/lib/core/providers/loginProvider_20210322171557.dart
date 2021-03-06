import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mytest/core/database/database_helper.dart';
import 'package:mytest/views/pages/home.dart';
import 'package:mytest/views/widgets/dialogs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final loginFormKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var allUsers, user;

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    allUsers = json.decode(pref.getString("users"));
    notifyListeners();
  }

  void _query(context) async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: HomePage(
              email: emailController.text,
            )));
    allUsers = allRows;
  }

  login(context) async {
    final List<Map<String, Object>> allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
    allUsers = allRows.first;
    if (loginFormKey.currentState.validate()) {
      for (int i = 0; i < allUsers.length; i++) {
        if (allUsers["user$i"]["email"] == emailController.text) {
          user = allUsers["user$i"];
        }
      }
      if (user != null) {
        if (user["email"] == emailController.text &&
            user["password"] == passwordController.text) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: HomePage(
                    email: emailController.text,
                  )));
        } else {
          Dialogs d = new Dialogs();
          d.wrong(
              "Wrong cereditials!\nplease enter a correct username and password then try again",
              context);
        }
      } else {
        Dialogs d = new Dialogs();
        d.wrong("Wrong cereditials!\nThis user doesn't exist", context);
      }
    }
  }
}
