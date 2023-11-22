import 'package:restart/models/transaction_model.dart';

Map<DateTime, List<Transaction>> groupTransactionsByDay(List<Transaction> transactions) {
  transactions.sort((a, b) => a.date.compareTo(b.date));

  Map<DateTime, List<Transaction>> result = {};
  for (Transaction transaction in transactions) {
    DateTime day = transaction.date;
    if (result.containsKey(day)) {
      result[day]!.add(transaction);
    } else {
      result[day] = [transaction];
    }
  }
  return result;
}
