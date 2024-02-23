import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Account Grid'),
        ),
        body: AccountGrid(),
      ),
    );
  }
}

class AccountEntry {
  String accountNumber;
  double debit;
  double credit;
  double saldo;

  AccountEntry({this.accountNumber = '', this.debit = 0.0, this.credit = 0.0, this.saldo = 0.0});
}

class AccountGrid extends StatefulWidget {
  @override
  _AccountGridState createState() => _AccountGridState();
}

class _AccountGridState extends State<AccountGrid> {
  List<AccountEntry> accountEntries = List.generate(
    10,
    (index) => AccountEntry(
      accountNumber: 'Account ${index + 1}',
      debit: 0.0,
      credit: 0.0,
      saldo: Random().nextDouble() * 1000, // Random saldo for demonstration
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: accountEntries.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => showAccountPicker(context, index),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(accountEntries[index].accountNumber),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        accountEntries[index].debit = double.tryParse(value) ?? 0.0;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Debit'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        accountEntries[index].credit = double.tryParse(value) ?? 0.0;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Credit'),
                  ),
                ),
                Expanded(
                  child: Text(accountEntries[index].saldo.toStringAsFixed(2)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAccountPicker(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Account'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 5, // Number of dummy accounts
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text('Account ${i + 1}'),
                  onTap: () {
                    setState(() {
                      accountEntries[index].accountNumber = 'Account ${i + 1}';
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
