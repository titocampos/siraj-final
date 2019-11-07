import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ml_signals/screens/tabs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String userId;

  List<String> menuItens = ["Settings", "Logout"];

  Future _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await auth.currentUser();
    setState(() {
      userId = currentUser.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('M/L Signals'),
        bottom: TabBar(
          indicatorWeight: 4,
          indicatorColor: Colors.blueGrey[600],
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "Cripto",
            ),
            Tab(
              text: "Forex",
            ),
            Tab(
              text: "Metals",
            ),
            Tab(
              text: "Stocks",
            ),
          ],
        ),
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
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          MyTab(TabType.cripto),
          MyTab(TabType.forex),
          MyTab(TabType.metals),
          MyTab(TabType.stock)
        ],
      ),

    );
  }
}
