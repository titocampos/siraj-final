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
          item.serie,
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
        Item(asset: "ETHEUR", serie: "ETH/EUR"),
        Item(asset: "ETHUSD", serie: "ETH/USD"),
        Item(asset: "BTCEUR", serie: "BTC/EUR"),
        Item(asset: "BTCUSD", serie: "BTC/USD")
      ];
    } else if (widget.tabType == TabType.forex) {
      return [
        Item(asset: "AUDUSD", serie: "AUD/USD"),
        Item(asset: "NZDUSD", serie: "NZD/USD"),
        Item(asset: "EURGBP", serie: "EUR/GBP"),
        Item(asset: "EURUSD", serie: "EUR/USD"),
        Item(asset: "GBPJPY", serie: "GBP/JPY"),
        Item(asset: "GBPUSD", serie: "GBP/USD"),
        Item(asset: "USDJPY", serie: "USD/JPY"),
        Item(asset: "USDCAD", serie: "USD/CAD"),
        Item(asset: "USDCHF", serie: "USD/CHF")
      ];
    } else if (widget.tabType == TabType.metals) {
      return [
        Item(asset: "XAUUSD", serie: "XAU/USD"),
        Item(asset: "XAGUSD", serie: "XAG/USD")
      ];
    } else {
      return [
        Item(asset: "AAPL", serie: "AAPL"),
        Item(asset: "WTRH", serie: "WTRH"),
        Item(asset: "GOOG", serie: "GOOG"),
        Item(asset: "FB", serie: "FB"),
        Item(asset: "BA", serie: "BA"),
        Item(asset: "TSLA", serie: "TSLA"),
        Item(asset: "MSFT", serie: "MSFT"),
        Item(asset: "AMZN", serie: "AMZN"),
        Item(asset: "PYPL", serie: "PYPL"),
        Item(asset: "SCHW", serie: "SCHW"),
        Item(asset: "MO", serie: "MO"),
        Item(asset: "SDC", serie: "SDC"),
        Item(asset: "COST", serie: "COST"),
        Item(asset: "PEP", serie: "PEP"),
        Item(asset: "MTCH", serie: "MTCH"),
        Item(asset: "OSTK", serie: "OSTK"),
        Item(asset: "TWOU", serie: "TWOU"),
        Item(asset: "VRAY", serie: "VRAY"),
        Item(asset: "AMTD", serie: "AMTD"),
        Item(asset: "ETFC", serie: "ETFC"),
        Item(asset: "HPQ", serie: "HPQ"),
        Item(asset: "WTRH", serie: "WTRH")
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
