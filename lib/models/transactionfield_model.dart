import 'dart:ui';

import 'package:flutter/material.dart';

class TransactionField {
  String label;
  String? type;
  dynamic value;

  TransactionField(this.label, this.type, this.value);
}

List<TransactionField> transactionFields = [
  TransactionField("Type", "selector", "income"),
  TransactionField("Date", "date", DateTime.now()),
  TransactionField("Amount", "number", 0),
  TransactionField("Category", "text", ""),
  TransactionField("Account", "text", ""),
  TransactionField("From", "text", ""),
  TransactionField("To", "text", ""),
  TransactionField("Note", "text", ""),
];


