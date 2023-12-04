import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';
import 'package:restart/utility_functions/transaction_daily_utils.dart';

class TransactionDisplay extends StatefulWidget {
  final DateTime selectedMonth;
  const TransactionDisplay({Key? key, required this.selectedMonth})
      : super(key: key);

  @override
  State<TransactionDisplay> createState() => _TransactionDisplayState();
}

class _TransactionDisplayState extends State<TransactionDisplay> {
  late List<Transaction> transactions;

  @override
  void initState() {
    super.initState();
    transactions = fetchTransactionsForSelectedMonth();
  }

  @override
  void didUpdateWidget(TransactionDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth !=widget.selectedMonth) {
      setState(() {
        transactions = fetchTransactionsForSelectedMonth();
      });
    }
  }

  List<Transaction> fetchTransactionsForSelectedMonth() {
    return allTransactions.value.where((transaction) {
      return transaction.date.month == widget.selectedMonth.month &&
          transaction.date.year == widget.selectedMonth.year;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Transaction>> groupedTransactions =
        groupTransactionsByDay(transactions);

    return ValueListenableBuilder(
      valueListenable: allTransactions,
      builder: (context, transactions, child) {
        return SingleChildScrollView(
          child: Column(
            children: groupedTransactions.keys.map((DateTime day) {
              List<Transaction> dayTransactions = groupedTransactions[day]!;

              double totalIncome = 0;
              double totalExpenses = 0;

              for (var transaction in dayTransactions) {
                if (transaction.type == TransactionType.income) {
                  totalIncome += transaction.amount;
                } else if (transaction.type == TransactionType.expense) {
                  totalExpenses += transaction.amount;
                }
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  day.day.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  child: Text(
                                    DateFormat.E().format(day),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '\u20A6$totalIncome', // Display total income
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  '\u20A6$totalExpenses', // Display total expenses
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: Expanded(
                      child: ValueListenableBuilder<List<Transaction>>(
                        valueListenable: allTransactions,
                        builder: (context, transactions, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dayTransactions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 100.0,
                                          child: Row(
                                            children: [
                                              Icon(
                                                dayTransactions[index]
                                                    .selectedCategory
                                                    ?.icon,
                                                size: 15.0,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  '${dayTransactions[index].selectedCategory.label}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${dayTransactions[index].selectedAccount.label}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\u20A6${dayTransactions[index].amount}',
                                      style: TextStyle(
                                        color: dayTransactions[index].type?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    color: Colors.grey,
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
