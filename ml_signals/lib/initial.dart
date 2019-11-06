import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Initial extends StatefulWidget {
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

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
    Navigator.pushNamed(context, "/login");
  }

  void _register() {
    Navigator.pushNamed(context, "/register");
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void _signin() {
    signInWithGoogle().whenComplete(() {
      Navigator.pushReplacementNamed(context, "/checkout");
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
                      width: 325,
                      height: 130,
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
