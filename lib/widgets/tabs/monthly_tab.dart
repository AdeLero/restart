import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';

class MonthlyTab extends StatefulWidget {
  final DateTime selectedMonth;
  const MonthlyTab({Key? key, required this.selectedMonth});

  @override
  State<MonthlyTab> createState() => _MonthlyTabState();
}

class _MonthlyTabState extends State<MonthlyTab> {
  int _expandedIndex = -1;
  bool _isExpanded = false;
  List<DateTime> availableMonths = [];

  @override
  void initState() {
    super.initState();
    availableMonths = getAvailableMonths();
  }

  List<DateTime> getAvailableMonths() {
    List<DateTime> months = [];
    DateTime now = DateTime.now();
    DateTime januaryOfCurrentYear = DateTime(now.year, 1, 1);
    DateTime currentMonth = DateTime(now.year, now.month, 1);

    for (DateTime month = currentMonth; month.isAfter(januaryOfCurrentYear); month = DateTime(month.year, month.month - 1)) {
      months.add(month);
    }
    return months;
  }



  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpenses = 0;
    for (var transaction in allTransactions.value) {
      if (transaction.date.year == widget.selectedMonth.year) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalExpenses += transaction.amount;
        }
      }
    }
    return Column(
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
                      '\u20A6$totalExpenses', // Display total expenses
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
                      '\u20A6${totalIncome - totalExpenses}', // Display total
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
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: availableMonths.length,
            itemBuilder: (BuildContext context, int index) {
              DateTime currentMonth = availableMonths[index];
              return buildMonthItem(currentMonth, index);
            },
          ),
        ),
      ],
    );
  }

  Widget buildMonthItem(DateTime month, int index) {
    double totalIncome = 0;
    double totalExpenses = 0;
    for (var transaction in allTransactions.value) {
      if (transaction.date.month == month.month &&
          transaction.date.year == month.year) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalExpenses += transaction.amount;
        }
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          _expandedIndex = (_expandedIndex == index) ? -1 : index;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat.MMM().format(month)}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '\u20A6$totalIncome',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(width: 50),
                        Text(
                          '\u20A6$totalExpenses',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('dd/MM').format(DateTime(month.year, month.month, 1))} ~ ${DateFormat('dd/MM').format(DateTime(month.year, month.month + 1, 0))}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '\u20A6${totalIncome - totalExpenses}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _expandedIndex == index ? buildWeeklyTransactions(month) : SizedBox.shrink(),
        ],
      ),
    );
  }
}

Widget buildWeeklyTransactions(DateTime month) {
  List<Widget> weeklyRows = [];
  int year = month.year;
  int monthNumber = month.month;
  DateTime firstDay = DateTime(year, monthNumber, 1);
  int daysInMonth = DateTime(year, monthNumber + 1, 0).day;

  int firstWeekday = firstDay.weekday;

  int currentDay = 1;

  while (currentDay <= daysInMonth) {
    DateTime startOfWeek = firstDay.add(Duration(days: 7 * ((currentDay - 1) ~/ 7)));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    if (endOfWeek.month != monthNumber) {
      endOfWeek = DateTime(year, monthNumber, daysInMonth);
    }

    double weeklyIncome = 0;
    double weeklyExpenses = 0;

    for (var transaction in allTransactions.value) {
      if (transaction.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          transaction.date.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        if (transaction.type == TransactionType.income) {
          weeklyIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          weeklyExpenses += transaction.amount;
        }
      }
    }

    weeklyRows.add(
      Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DateFormat('dd/MM').format(startOfWeek)} ~ ${DateFormat('dd/MM').format(endOfWeek)}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black),
            ),
            Row(
              children: [
                Text(
                  '\u20A6$weeklyIncome',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                SizedBox(width: 50),
                Text(
                  '\u20A6$weeklyExpenses',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    currentDay = endOfWeek.day + 1;
  }

  return Column(
    children: weeklyRows,
  );
}



// TODO revisit the build weekly rows