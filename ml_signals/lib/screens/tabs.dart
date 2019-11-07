import 'package:flutter/material.dart';
import 'package:ml_signals/models/item.dart';
import 'package:ml_signals/screens/detail_page.dart';

enum TabType { cripto, forex, metals, stock }

class MyTab extends StatefulWidget {
  final TabType tabType;

  MyTab(this.tabType);

  @override
  _MyTabState createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> {
  List<String> tabs = ["Cripto", "Forex", "Metals", "Stock"];

  List items;

  @override
  void initState() {
    items = getItems();
    print(items.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(items[index]);
        },
      ),
    );
  }

  Card makeCard(Item item) => Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.blueGrey[600]),
          child: makeListTile(item),
        ),
      );

  ListTile makeListTile(Item item) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          item.name,
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white70, size: 30.0),
        onTap: () {
          navigate(context, item);
        },
      );

  List getItems() {
    if (widget.tabType == TabType.cripto) {
      return [
        Item(asset: "ETHEUR", serie: "ETH/EUR", name: "ETH/EUR"),
        Item(asset: "ETHUSD", serie: "ETH/USD", name: "ETH/USD"),
        Item(asset: "BTCEUR", serie: "BTC/EUR", name: "BTC/EUR"),
        Item(asset: "BTCUSD", serie: "BTC/USD", name: "BTC/USD")
      ];
    } else if (widget.tabType == TabType.forex) {
      return [
        Item(asset: "AUDUSD", serie: "AUD/USD", name: "AUD/USD"),
        Item(asset: "NZDUSD", serie: "NZD/USD", name: "NZD/USD"),
        Item(asset: "EURGBP", serie: "EUR/GBP", name: "EUR/GBP"),
        Item(asset: "EURUSD", serie: "EUR/USD", name: "EUR/USD"),
        Item(asset: "GBPJPY", serie: "GBP/JPY", name: "GBP/JPY"),
        Item(asset: "GBPUSD", serie: "GBP/USD", name: "GBP/USD"),
        Item(asset: "USDJPY", serie: "USD/JPY", name: "USD/JPY"),
        Item(asset: "USDCAD", serie: "USD/CAD", name: "USD/CAD"),
        Item(asset: "USDCHF", serie: "USD/CHF", name: "USD/CHF")
      ];
    } else if (widget.tabType == TabType.metals) {
      return [
        Item(asset: "XAUUSD", serie: "XAU/USD", name: "XAU/USD"),
        Item(asset: "XAGUSD", serie: "XAG/USD", name: "XAG/USD")
      ];
    } else {
      return [
        Item(asset: "AAPL", serie: "AAPL", name: "AAPL"),
        Item(asset: "WTRH", serie: "WTRH", name: "WTRH"),
        Item(asset: "GOOG", serie: "GOOG", name: "GOOG"),
        Item(asset: "FB", serie: "FB", name: "FB"),
        Item(asset: "BA", serie: "BA", name: "BA"),
        Item(asset: "TSLA", serie: "TSLA", name: "TSLA"),
        Item(asset: "MSFT", serie: "MSFT", name: "MSFT"),
        Item(asset: "AMZN", serie: "AMZN", name: "AMZN"),
        Item(asset: "PYPL", serie: "PYPL", name: "PYPL"),
        Item(asset: "SCHW", serie: "SCHW", name: "SCHW"),
        Item(asset: "MO", serie: "MO", name: "MO"),
        Item(asset: "SDC", serie: "SDC", name: "SDC"),
        Item(asset: "COST", serie: "COST", name: "COST"),
        Item(asset: "PEP", serie: "PEP", name: "PEP"),
        Item(asset: "MTCH", serie: "MTCH", name: "MTCH"),
        Item(asset: "OSTK", serie: "OSTK", name: "OSTK"),
        Item(asset: "TWOU", serie: "TWOU", name: "TWOU"),
        Item(asset: "VRAY", serie: "VRAY", name: "VRAY"),
        Item(asset: "AMTD", serie: "AMTD", name: "AMTD"),
        Item(asset: "ETFC", serie: "ETFC", name: "ETFC"),
        Item(asset: "HPQ", serie: "HPQ", name: "HPQ"),
        Item(asset: "WTRH", serie: "WTRH", name: "WTRH")
      ];
    }
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

  void navigate(context, Item item) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
            item: item, tabName: tabs[widget.tabType.index].toLowerCase()),
      ),
    );
  }
}
