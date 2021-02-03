import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:personal_shopper/widgets/chart.dart';
import 'widgets/transaction_list.dart';
import 'widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'dart:io';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
// SystemChrome.setPreferredOrientations([
// DeviceOrientation.portraitDown,
// DeviceOrientation.portraitDown,
// DeviceOrientation.landscapeLeft,
// DeviceOrientation.landscapeRight
// ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Shopper',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.green,
        accentColor: Colors.brown,
        fontFamily: 'Quicksand',
        // textTheme: ThemeData.light().textTheme.copyWith(
        //     headline5: TextStyle(
        //         fontFamily: 'Open Sans',
        //         fontSize: 18,
        //         fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        date: DateTime(2021, 1, 19),
        title: 'New Shoes',
        amount: 39.69,
        id: 't1'),
    Transaction(
        date: DateTime(2021, 1, 18), title: 'PS5', amount: 599.99, id: 't2')
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        title: title, amount: amount, date: date, id: '${DateTime.now()})');

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        // context: ctx, builder: (_) => NewTransaction(_addNewTransaction));
        context: context,
        builder: (_) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: NewTransaction(_addNewTransaction),
              ),
            ));
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool _isLandscape = mediaQuery.orientation == Orientation.landscape;
    //put in a final so i can use the height factor
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              "Personal Shopper",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.animation),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
            title: Text(
              "Personal Shopper",
            ),
          );

    final Widget txListWidget = Container(
      height: (mediaQuery.size.height -
              appbar.preferredSize.height -
              mediaQuery.padding.top) *
          0.65,
      child: TransactionList(
        userTransactions: _userTransactions,
        deleteTx: _deleteTransaction,
      ),
    );

    final Widget chartWidget = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            (_isLandscape ? 0.75 : 0.25),
        child: Chart(_recentTransactions));

    final pageBody = SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (_isLandscape)
          Container(
            height: (mediaQuery.size.height -
                    appbar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Show Chart",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          ),
        if (!_isLandscape) chartWidget,
        if (!_isLandscape) txListWidget,
        if (_isLandscape) _showChart ? chartWidget : txListWidget
      ],
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: appbar, child: pageBody)
        : Scaffold(
            appBar: appbar,
            body: pageBody,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
  }
}
