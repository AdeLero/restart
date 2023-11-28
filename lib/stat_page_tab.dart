import 'package:flutter/material.dart';
import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpenses = 0;
    for (var transaction in allTransactions.value) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalExpenses += transaction.amount;
        }
    }
    double totalCashIncome = 0;
    double totalCashExpenses = 0;
    for (var transaction in allTransactions.value) {
      if (transaction.selectedAccount.label == 'Cash') {
        if (transaction.type == TransactionType.income) {
          totalCashIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalCashExpenses += transaction.amount;
        }
      }
    }
    double totalBankIncome = 0;
    double totalBankExpenses = 0;
    for (var transaction in allTransactions.value) {
      if (transaction.selectedAccount.label == 'Bank Accounts') {
        if (transaction.type == TransactionType.income) {
          totalBankIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalBankExpenses += transaction.amount;
        }
      }
    }
    double totalCardIncome = 0;
    double totalCardExpenses = 0;
    for (var transaction in allTransactions.value) {
      if (transaction.selectedAccount.label == 'Card') {
        if (transaction.type == TransactionType.income) {
          totalCardIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          totalCardExpenses += transaction.amount;
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Accounts',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
            Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Asset'),
                    Text(
                      '$totalIncome',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Liabilities'),
                    Text(
                      '$totalExpenses',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Total'),
                    Text(
                      '${totalIncome - totalExpenses}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\u20A6 ${(totalCashIncome - totalCashExpenses).abs()}',
                      style: TextStyle(
                        color: (totalCashIncome - totalCashExpenses) >= 0
                            ? Colors.blueAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\u20A6 ${(totalCashIncome - totalCashExpenses).abs()}',
                      style: TextStyle(
                        color: (totalCashIncome - totalCashExpenses) >= 0
                            ? Colors.blueAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Accounts',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\u20A6 ${(totalBankIncome - totalBankExpenses).abs()}',
                      style: TextStyle(
                        color: (totalBankIncome - totalBankExpenses) >= 0
                            ? Colors.blueAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bank Accounts',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\u20A6 ${(totalBankIncome - totalBankExpenses).abs()}',
                      style: TextStyle(
                        color: (totalBankIncome - totalBankExpenses) >= 0
                            ? Colors.blueAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Balance Payable',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              '\u20A6 0.0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Column(
                          children: [
                            Text(
                              'Outst. Balance',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              '\u20A6 ${(totalCardIncome - totalCardExpenses).abs()}',
                              style: TextStyle(
                                color: (totalCardIncome - totalCardExpenses) >= 0
                                    ? Colors.blueAccent
                                    : Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                            Text(
                              '\u20A6 0.0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        SizedBox(width: 44),
                        Text(
                          '\u20A6 ${(totalCardIncome - totalCardExpenses).abs()}',
                          style: TextStyle(
                            color: (totalCardIncome - totalCardExpenses) >= 0
                                ? Colors.blueAccent
                                : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
