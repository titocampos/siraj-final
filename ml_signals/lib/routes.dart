import 'package:flutter/material.dart';
import 'package:ml_signals/screens/checkout.dart';
import 'package:ml_signals/screens/home.dart';
import 'package:ml_signals/screens/initial.dart';
import 'package:ml_signals/screens/loading_credit.dart';
import 'package:ml_signals/screens/login.dart';
import 'package:ml_signals/screens/register.dart';
import 'package:ml_signals/screens/settings.dart';

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
      case "/loadingCredit":
        return MaterialPageRoute(builder: (_) => LoadingCredit());
    }
    return MaterialPageRoute(builder: (_) => Initial());
  }
}
