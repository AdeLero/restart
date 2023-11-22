class Account {
  final String label;

  Account({required this.label});

  static List<Account> accounts = [
    Account(label: 'Cash'),
    Account(label: 'Bank Accounts'),
    Account(label: 'Card'),
    Account(label: 'Add'),
  ];
}