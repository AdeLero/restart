import 'package:flutter/cupertino.dart';
import 'package:restart/models/transaction_type_model.dart';
import 'account_model.dart';
import 'category_model.dart';

class Transaction {
  DateTime date;
  TransactionType type;
  double amount;
  Category selectedCategory;
  Account selectedAccount;
  String? note;
  String? description;

  Transaction({
    required this.date,
    required this.type,
    required this.amount,
    required this.selectedCategory,
    required this.selectedAccount,
    this.note,
    this.description,
  });
}

ValueNotifier<List<Transaction>> allTransactions =
    ValueNotifier<List<Transaction>>([]);
