import 'package:flutter/material.dart';

class TransactionType{
  final String label;
  final Color? color;

  TransactionType({
    required this.label,
    this.color
});

  static List<TransactionType> types = [
    TransactionType(label: 'Income', color: Colors.blueAccent),
    TransactionType(label: 'Expense', color: Colors.redAccent),
    TransactionType(label: 'Transfer', color: Colors.black87),
  ];

  static TransactionType get income =>
      types.firstWhere((type) => type.label == 'Income');
  static TransactionType get expense =>
      types.firstWhere((type) => type.label == 'Expense');
}
