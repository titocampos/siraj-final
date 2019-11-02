import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ml_signals/models/user.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Controllers
  TextEditingController _controllerName = TextEditingController(text: "");
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
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String pass = _controllerPass.text;

    if (name.isNotEmpty) {
      if (_emailValidator(email).isEmpty) {
        if (pass.isNotEmpty && pass.length >= 6) {
          setState(() {
            _errorMsg = "";
          });

          User user = User();
          user.name = name;
          user.email = email;
          user.password = pass;

          _registerUser(user);
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
    } else {
      setState(() {
        _errorMsg = "Enter a valid name.";
      });
    }
  }

  _registerUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((firebaseUser) {
      Firestore db = Firestore.instance;
      db
          .collection("users")
          .document(firebaseUser.user.uid)
          .setData(user.toMap());

      Navigator.pushNamedAndRemoveUntil(context, "/checkout", (_)=>false);
    }).catchError((error) {
      print("error app: " + error.toString());
      setState(() {
        _errorMsg = "Error registering user, check fields and try again!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                    "images/user.png",
                      width: 180,
                      height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerName,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
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
                        "Register",
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
