import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ml_signals/services/networking.dart';
import 'package:ml_signals/utilities/constants.dart';

class LoadingCredit extends StatefulWidget {
  @override
  _LoadingCreditState createState() => _LoadingCreditState();
}

class _LoadingCreditState extends State<LoadingCredit> {
  Future getUserCredit() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await auth.currentUser();

    currentUser.getIdToken().then((res) async {
      String token = res.token.toString();
      String body = json.encode({'userID': token});

      NetworkHelper helper = NetworkHelper(getUrl("/v1/query"), "post",
          headers: {"Content-Type": "application/json"}, body: body);
 
          var credit = await helper.getData(); 

          if (credit == null || credit['credit'] == 0 ){
            Navigator.pushNamedAndRemoveUntil(context, "/checkout", (_) => false);
          }
          else{
            Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
          }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserCredit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100.0,
      )),
    );
  }
}
