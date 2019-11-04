import 'package:flutter/material.dart';
import 'package:ml_signals/initial.dart';
import 'package:ml_signals/routes.dart';

void main(){
  runApp(MaterialApp(
    home: Initial(),
    theme: ThemeData(
      primaryColor: Colors.blueGrey[900],
      accentColor: Colors.blue[400]
    ),    
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
