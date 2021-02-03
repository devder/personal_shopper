import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTx;

  TransactionList({this.userTransactions, this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return userTransactions.isNotEmpty
        ? ListView.builder(
            itemCount: userTransactions.length,
            //check constants file for previous Card used
            itemBuilder: (context, index) => Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: FittedBox(
                      child: Text(
                        '\$${userTransactions[index].amount.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                ),
                title: Text(
                  userTransactions[index].title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    DateFormat.yMMMEd().format(userTransactions[index].date),
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                trailing: MediaQuery.of(context).size.width > 460
                    ? FlatButton.icon(
                        onPressed: () => deleteTx(userTransactions[index].id),
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                        label: Text('delete'),
                      )
                    : IconButton(
                        onPressed: () => deleteTx(userTransactions[index].id),
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context).accentColor,
                        )),
              ),
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Text(
                  'no transactions added yet',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 19.0,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
  }
}
