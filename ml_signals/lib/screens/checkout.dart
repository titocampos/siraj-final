import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ml_signals/utilities/constants.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class _CheckoutState extends State<Checkout>
    with SingleTickerProviderStateMixin {
  List<String> menuItens = ["Settings", "Logout"];

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: STRIPE_KEY_PUB,
        merchantId: "Test",
        androidPayMode: 'test'));
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

  Widget myCard(String title, String subTitle, Color btnColor, Function f) {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: EdgeInsets.all(32),
            child: Container(
              width: 250,
              child: myButton("Pay with Card", Colors.white, btnColor, btnColor,
                  Colors.white, f),
            ),
          ),
        ],
      ),
    );
  }

  void _checkout1() async {
    showAlertDialog(context, "1000", "One-time payment", 1);
  }

  void _checkout2() {
    showAlertDialog(context, "10000", "Payment per 12 queries", 12);
  }

  void _checkout3() {
    showAlertDialog(context, "90000", "Payment per 120 queries", 120);
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = Theme.of(context).accentColor;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey[600],
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 16),
                  child: Text(
                    'Choose a Plan!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: myCard(
                    "One-time", "• 10 USD per query", accentColor, _checkout1),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: myCard("Standard", "• 100 USD per 12 queries",
                    accentColor, _checkout2),
              ),
              myCard("Premium", "• 900 USD per 120 queries", accentColor,
                  _checkout3),
            ],
          ),
        ),
      ),
    );
  }

  void makeCheckout(
      email, cardNunber, month, year, cvc, amount, description, queries) {
    final CreditCard card = CreditCard(
        number: cardNunber, expMonth: month, expYear: year, cvc: cvc);

    StripePayment.createTokenWithCard(card).then((token) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser currentUser = await auth.currentUser();

      currentUser.getIdToken().then((res) async {
        String tokenuUser = res.token.toString();
        String body = json.encode({
          "token": {"id": token.tokenId, "email": email},
          'userID': tokenuUser,
          "charge": {
            "amount": amount,
            "description": description,
            "currency": "usd",
            "queries": queries
          }
        });

        await http
            .post(getUrl("v1/charge"),
                headers: {"Content-Type": "application/json"}, body: body)
            .then((rsp) {
          if (rsp.statusCode == 200) {
            Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
          } else {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text('Received ${rsp.body}')));
          }
        });
      });
    }).catchError(setError);
  }

  Widget myButton(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      padding: EdgeInsets.fromLTRB(32, 12, 32, 12),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
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

  showAlertDialog(BuildContext context, amount, description, queries) {
    final Color accentColor = Theme.of(context).accentColor;
    final TextEditingController _emailController = TextEditingController();
    final MaskedTextController _cardNumberController =
        MaskedTextController(mask: '0000 0000 0000 0000');
    final TextEditingController _expiryDateController =
        MaskedTextController(mask: '00/00');
    final TextEditingController _cvvCodeController =
        MaskedTextController(mask: '0000');

    AlertDialog dialog = AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 500,
              padding: EdgeInsets.only(bottom: 6),
              child: TextFormField(
                autofocus: true,
                controller: _emailController,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(0),
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 6),
              child: TextFormField(
                autofocus: true,
                controller: _cardNumberController,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.credit_card),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(0),
                  border: OutlineInputBorder(),
                  hintText: 'xxxx xxxx xxxx xxxx',
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 16, right: 10),
                  width: 100,
                  child: TextFormField(
                    autofocus: true,
                    controller: _expiryDateController,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      hintText: 'MM/YY',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  width: 80,
                  child: TextFormField(
                    autofocus: true,
                    controller: _cvvCodeController,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 18),
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      hintText: 'CVV',
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 2),
              child: myButton("Confirm", Colors.white, accentColor, accentColor,
                  Colors.white, () async {
                try {
                  assert(_emailController.text.isNotEmpty);
                  List<String> data = _expiryDateController.text.split("/");
                  int month = int.parse(data[0]);
                  int year = int.parse(data[1]);
                  showLoadingDialog(context);

                  makeCheckout(
                      _emailController.text,
                      _cardNumberController.text,
                      month,
                      year,
                      _cvvCodeController.text,
                      amount,
                      description,
                      queries);
                } catch (error) {
                  _scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }
              }),
            ),
          ],
        ),
      ),
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  showLoadingDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}

class MaskedTextController extends TextEditingController {
  MaskedTextController({String text, this.mask, Map<String, RegExp> translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (this.beforeChange(previous, this.text)) {
        updateText(this.text);
        this.afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  String mask;

  Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text != null) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection =
        TextSelection.fromPosition(TextPosition(offset: (text ?? '').length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}
