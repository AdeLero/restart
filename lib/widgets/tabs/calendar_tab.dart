import 'package:flutter/material.dart';
import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';
import 'package:restart/widgets/Button/daily_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTab extends StatefulWidget {
  final DateTime selectedMonth;
  const CalendarTab({super.key, required this.selectedMonth});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _showDailyBottomSheet(DateTime selectedDay) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return DailyBottomSheet(selectedDay: selectedDay);
        }
    );
  }


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

    return Container(
      color: Colors.grey[300],
      child: Column(
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
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            focusedDay: _focusedDay,
            lastDay: DateTime.utc(2040, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              _showDailyBottomSheet(selectedDay);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            headerVisible: false,
            sixWeekMonthsEnforced: true,
            calendarStyle: CalendarStyle(
              outsideDecoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              outsideTextStyle: TextStyle(color: Colors.grey),
              cellMargin: EdgeInsets.all(0.5),
              cellPadding: EdgeInsets.all(1.0),
              cellAlignment: Alignment.topLeft,
            ),
            calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, events) {
                  List<Transaction> dayTransactions = allTransactions.value.where((transaction) {
                    return transaction.date.year == date.year &&
                        transaction.date.month == date.month &&
                        transaction.date.day == date.day;
                  }).toList();

                  double totalIncome = 0;
                  double totalExpenses = 0;

                  for (var transaction in dayTransactions) {
                    if (transaction.type == TransactionType.income) {
                      totalIncome += transaction.amount;
                    } else if (transaction.type == TransactionType.expense) {
                      totalExpenses += transaction.amount;
                    }
                  }

                  double total = totalIncome - totalExpenses;
                  return Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date.day.toString(),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$totalIncome',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    '$totalExpenses',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  Text(
                                    '$total',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, date, events) {
                  List<Transaction> dayTransactions = allTransactions.value.where((transaction) {
                    return transaction.date.year == date.year &&
                        transaction.date.month == date.month &&
                        transaction.date.day == date.day;
                  }).toList();

                  double totalIncome = 0;
                  double totalExpenses = 0;

                  for (var transaction in dayTransactions) {
                    if (transaction.type == TransactionType.income) {
                      totalIncome += transaction.amount;
                    } else if (transaction.type == TransactionType.expense) {
                      totalExpenses += transaction.amount;
                    }
                  }

                  double total = totalIncome - totalExpenses;
                  return Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(1.0),
                              color: Colors.black,
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$totalIncome',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    '$totalExpenses',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  Text(
                                    '$total',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, date, events) {
                  List<Transaction> dayTransactions = allTransactions.value.where((transaction) {
                    return transaction.date.year == date.year &&
                        transaction.date.month == date.month &&
                        transaction.date.day == date.day;
                  }).toList();

                  double totalIncome = 0;
                  double totalExpenses = 0;

                  for (var transaction in dayTransactions) {
                    if (transaction.type == TransactionType.income) {
                      totalIncome += transaction.amount;
                    } else if (transaction.type == TransactionType.expense) {
                      totalExpenses += transaction.amount;
                    }
                  }

                  double total = totalIncome - totalExpenses;
                  return Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(1.0),
                              color: Colors.black,
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$totalIncome',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    '$totalExpenses',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  Text(
                                    '$total',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
