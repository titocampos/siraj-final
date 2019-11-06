import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ml_signals/models/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Controllers
  TextEditingController _controllerEmail = TextEditingController(text: "");
  TextEditingController _controllerPass = TextEditingController(text: "");
  String _errorMsg = "";

  String _emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return "Enter a valid email.";
    else
      return "";
  }

  _validateFields() async {
    String email = _controllerEmail.text;
    String pass = _controllerPass.text;

    if (_emailValidator(email).isEmpty) {
      if (pass.isNotEmpty && pass.length >= 6) {
        setState(() {
          _errorMsg = "";
        });

        User user = User();
        user.email = email;
        user.password = pass;

        _loginUser(user);
      } else {
        setState(() {
          _errorMsg = "The password must be 6 characters long or more.";
        });
      }
    } else {
      setState(() {
        _errorMsg = _emailValidator(email);
      });
    }
  }

  _loginUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, "/home");
    }).catchError((error) {
      print("error app: " + error.toString());
      setState(() {
        _errorMsg =
            "Error authenticating user, check email and password and try again!";
      });
    });
  }

  Future _loggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (await auth.currentUser() != null) {
      Navigator.pushReplacementNamed(context, "/checkout");
    }
  }

  @override
  void initState() {
    _loggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
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
                    width: 325,
                    height: 130,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerPass,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validateFields();
                      }),
                ),
                Center(
                  child: Text(
                    _errorMsg,
                    style: TextStyle(color: Colors.yellow[700], fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
