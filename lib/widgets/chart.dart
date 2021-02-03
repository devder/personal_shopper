import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_shopper/models/transaction.dart';
import 'package:personal_shopper/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSumForDay = 0.0;

      for (var tx in recentTransactions) {
        if (tx.date.day == weekDay.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year) {
          totalSumForDay += tx.amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay), 'amount': totalSumForDay};
    });
  }

  double get totalSpending {
    return _groupedTransactionValues.fold(
        0.0, (previousValue, tx) => previousValue + tx['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20.0),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _groupedTransactionValues.reversed
              .map((e) => Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: ChatBar(
                      label: e['day'],
                      spendingAmount: e['amount'],
                      spendingPercentage: totalSpending == 0.0
                          ? 0.0
                          : (e['amount'] as double) / totalSpending,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
