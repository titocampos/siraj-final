import 'package:flutter/material.dart';

class Initial extends StatefulWidget {
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  Widget myButton(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
      ),
      onPressed: () {
        function();
      },
    );
  }

  void _login() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  void _register() {
    Navigator.pushReplacementNamed(context, "/register");
  }

  void _signin() {}

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.blueGrey[600]),
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "images/signal.png",
                      width: 260,
                      height: 104,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 6),
                    child: myButton("LOGIN IN", Colors.white, primaryColor,
                        primaryColor, Colors.white, _login),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 6),
                    child: myButton("CREATE ACCOUNT", Colors.white,
                        primaryColor, primaryColor, Colors.white, _register),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 6),
                    child: myButton(
                      "SIGN IN WITH GOOGLE",
                      Colors.white,
                      primaryColor,
                      primaryColor,
                      Colors.white,
                      _signin,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
