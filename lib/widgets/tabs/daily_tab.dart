import 'package:flutter/material.dart';
import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';
import 'package:restart/widgets/transaction_display.dart';

class DailyTab extends StatefulWidget {
  final DateTime selectedMonth;
  const DailyTab({Key? key, required this.selectedMonth}) : super(key: key);

  @override
  State<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpenses = 0;
    for (var transaction in allTransactions.value) {
      if (transaction.date.month == widget.selectedMonth.month &&
          transaction.date.year == widget.selectedMonth.year) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalExpenses += transaction.amount;
        }
      }
    }

    return ListView(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    child: Text('Income'),
                  ),
                  Container(
                    child: Text(
                      '\u20A6$totalIncome',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    child: Text('Expenses'),
                  ),
                  Container(
                    child: Text(
                      '\u20A6$totalExpenses',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    child: Text('Total'),
                  ),
                  Container(
                    child: Text(
                      '\u20A6${totalIncome - totalExpenses}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SingleChildScrollView(child: TransactionDisplay(selectedMonth: widget.selectedMonth)),
      ],
    );
  }
}

