import 'package:flutter/material.dart';
import 'package:ml_signals/checkout.dart';
import 'package:ml_signals/home.dart';
import 'package:ml_signals/initial.dart';
import 'package:ml_signals/login.dart';
import 'package:ml_signals/register.dart';
import 'package:ml_signals/settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Initial());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/register":
        return MaterialPageRoute(builder: (_) => Register());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/settings":
        return MaterialPageRoute(builder: (_) => Settings());
      case "/checkout":
        return MaterialPageRoute(builder: (_) => Checkout());
    }
    return MaterialPageRoute(builder: (_) => Initial());
  }
}
