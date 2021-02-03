import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.pop(context);
  }

  void _presentDatePicker() => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime.now())
          .then((pickedDate) {
        if (pickedDate == null) return;
        setState(() {
          _selectedDate = pickedDate;
        });
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // CupertinoTextField(
            //   placeholder: 'Title',
            // ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Title'),
              // onChanged: (val) => titleInput = val,
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) => amountInput = val,
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDate == null
                      ? 'no date chosen'
                      : 'Selected Date: ${DateFormat.yMd().format(_selectedDate)}'),
                  Platform.isIOS
                      ? CupertinoButton(
                          child: Text('Choose date',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: _presentDatePicker)
                      : FlatButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Choose date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          textColor: Theme.of(context).primaryColor)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Platform.isIOS
                  ? CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      child: Text('Add Transaction'),
                      onPressed: _submitData)
                  : RaisedButton(
                      onPressed: _submitData,
                      textColor: Theme.of(context).buttonColor,
                      child: Text('Add Transaction'),
                      color: Theme.of(context).primaryColor,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
