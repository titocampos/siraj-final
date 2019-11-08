import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flarts/flart.dart';
import 'package:flarts/flart_axis.dart';
import 'package:flarts/flart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ml_signals/models/item.dart';
import 'package:ml_signals/services/networking.dart';
import 'package:ml_signals/utilities/constants.dart';
import 'package:intl/intl.dart';

class StockQuote {
  final DateTime timestamp;
  final double price;
  StockQuote(this.timestamp, this.price);
}

class DetailPage extends StatefulWidget {
  final Item item;
  final String tabName;

  DetailPage({this.item, this.tabName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String userId;
  bool loading;
  int sentiment = -2;
  double negativiness = 0;
  double positiviness = 0;
  Map graphData;
  List<dynamic> tweets;
  List<StockQuote> myQuotes = List();

  Future getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await auth.currentUser();

    currentUser.getIdToken().then((res) async {
      String token = res.token.toString();
      String body = json.encode(
        {
          "userID": token,
          "_class": widget.tabName,
          "_asset": widget.item.asset,
          "_serie": widget.item.serie
        },
      );

      NetworkHelper helper = NetworkHelper(getUrl("/v1/data"), "post",
          headers: {"Content-Type": "application/json"}, body: body);

      var result = await helper.getData();

      if (result == null || result['ok'] == false) {
        if (result == null) {
          print("deu erro");
        } else {
          print(result['error']);
        }
        graphData = json.decode('{"2019-10-09": 0}');
      } else {
        graphData = result["data"]["graphData"];
        sentiment = result["data"]["sentiment"];
        tweets = result["data"]["tweets"];
      }

      getQuotes();
      setState(() {
        loading = false;

        if (sentiment < 0) {
          negativiness = 120.0 - (sentiment.abs() * 40);
          positiviness = 120.0;
        } else {
          negativiness = 120.0;
          positiviness = 120.0 - (sentiment * 40);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('M/L Signals'),
      ),
      body: loading
          ? Center(
              child: SpinKitDoubleBounce(
                color: Colors.white,
                size: 100.0,
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      child: LayoutBuilder(
                        builder: (context, constraints) => Flart(
                          constraints.biggest,
                          [
                            FlartData<StockQuote, DateTime, double>(
                              myQuotes,
                              customColor: Colors.green,
                              rangeFn: (quote, i) => quote.price,
                              domainFn: (quote, i) => quote.timestamp,
                              domainAxisId: 'dates',
                              rangeAxis: FlartAxis(
                                Axis.vertical,
                                myQuoteData.minRange,
                                myQuoteData.maxRange,
                                side: Side.left,
                                labelConfig: AxisLabelConfig(
                                  frequency: AxisLabelFrequency.perGridline,
                                  text: AxisLabelTextSource
                                      .interpolateFromDataType,
                                ),
                                numGridlines: 10,
                              ),
                            ),
                          ],
                          sharedAxes: [
                            FlartAxis(
                              Axis.horizontal,
                              myQuoteData.minDomain,
                              myQuoteData.maxDomain,
                              id: 'dates',
                              labelConfig: AxisLabelConfig(
                                frequency: AxisLabelFrequency.none,
                              ),
                              numGridlines: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "• " + widget.item.serie,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Tweeter Sentiment",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Negativeness",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Positiveness",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.grey,
                          height: 20,
                          width: 120,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(negativiness, 0, 0, 0),
                            child: Container(
                              color: Colors.red[400],
                              height: 20,
                              width: 10,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          height: 20,
                          width: 120,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, positiviness, 0),
                            child: Container(
                              color: Colors.blue[600],
                              height: 20,
                              width: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    child: _myListView(context),
                  ),
                ),
              ],
            ),
    );
  }

  void getQuotes() {
    myQuotes.clear();
    double d;
    for (var key in graphData.keys) {
      try {
        d = graphData[key];
        myQuotes.add(StockQuote(DateTime.parse(key), d));
      } catch (error) {
        continue;
      }
    }
    if (myQuotes.length == 0) {
      myQuotes.add(StockQuote(DateTime.parse("2019-04-10"), 0));
      myQuotes.add(StockQuote(DateTime.parse("2019-04-10"), 1));
    }
  }

  String formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      itemCount: tweets.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.blueGrey[600],
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  tweets[index]["created_at"].toString().substring(4, 19),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tweets[index]["text"],
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  FlartData get myQuoteData => FlartData<StockQuote, DateTime, double>(
        myQuotes,
        rangeFn: (quote, i) => quote.price,
        domainFn: (quote, i) => quote.timestamp,
      );
}
