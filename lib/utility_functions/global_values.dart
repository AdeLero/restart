import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';

double totalIncome = 0;
double totalExpenses = 0;

void updateTotals(List<Transaction> transactions) {
  totalIncome = 0;
  totalExpenses = 0;
  for (var transaction in transactions) {
    if (transaction.type == TransactionType.income) {
      totalIncome += transaction.amount;
    } else if (transaction.type == TransactionType.expense) {
      totalExpenses += transaction.amount;
    }
  }
}
