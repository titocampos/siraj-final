import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> with SingleTickerProviderStateMixin {
  List<String> menuItens = ["Settings", "Logout"];

  String _userId = "";

  Future _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await auth.currentUser();

    setState(() {
      _userId = currentUser.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _chooseMenuItem(String item) {
    switch (item) {
      case "Settings":
        Navigator.pushNamed(context, "/settings");
        break;
      case "Logout":
        _logout();
        break;
    }
  }

  _logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/initial");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('M/L Signals'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _chooseMenuItem,
            itemBuilder: (context) {
              return menuItens.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blueGrey[600]),
        child: Center(
          child: Text("Checkout"),
        ),
      ),
    );
  }
}
