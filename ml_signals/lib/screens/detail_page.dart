import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ml_signals/models/item.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class DetailPage extends StatefulWidget {
  final Item item;
  final String tabName;

  DetailPage({this.item, this.tabName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String userId;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('M/L Signals'),
      ),
      body: Column(
        children: <Widget>[
          SpinKitDoubleBounce(
            color: Colors.white,
            size: 100.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 30,
            height: 25.0,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
