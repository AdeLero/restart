import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restart/models/account_model.dart';
import 'package:restart/models/category_model.dart';
import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';
import 'package:restart/models/transactionfield_model.dart';
import 'package:restart/widgets/Button/account_button.dart';
import 'package:restart/widgets/Button/calendar_button.dart';
import 'package:restart/widgets/Button/category_button.dart';
import 'package:restart/widgets/transaction_type_selector.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<TextEditingController> textControllers = [];
  TextEditingController _accountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  late DateTime? selectedDay = DateTime.now();
  double? doubleValue;
  TransactionType? selectedType;
  final List<Transaction> transactions = allTransactions.value;

  List<Category> categories = [
    ...Category.expenseCategories,
    ...Category.incomeCategories,
  ];

  @override
  void initState() {
    super.initState();
    textControllers = List.generate(
        transactionFields.length, (index) => TextEditingController());
    _accountController = textControllers[
        transactionFields.indexWhere((field) => field.label == "Account")];
    _amountController = textControllers[
        transactionFields.indexWhere((field) => field.label == "Amount")];
    _categoryController = textControllers[
        transactionFields.indexWhere((field) => field.label == "Category")];
    _dateController = textControllers[
        transactionFields.indexWhere((field) => field.label == "Date")];

    selectedType = TransactionType.types[1];

    if (selectedDay == null) {
      selectedDay == DateTime.now();
      _dateController.text = DateFormat('dd/MM/yyyy (E)').format(selectedDay!);
    } else {
      _dateController.text = DateFormat('dd/MM/yyyy (E)').format(selectedDay!);
    }
  }

  void _showAccountBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AccountButton(
            accounts: Account.accounts,
            onAccountSelected: (String label) {
              setState(() {
                _accountController.text = label;
              });
            },
          );
        });
  }

  void _showCalendarBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CalendarButton(
              selectedDay: selectedDay,
              onDateSelected: (newDate) {
                if (newDate != null) {
                  setState(() {
                    selectedDay = newDate;
                    _dateController.text =
                        DateFormat('dd/MM/yyyy (E)').format(newDate);
                  });
                }
                Navigator.pop(context);
              });
        });
  }

  void _showExpenseCategoryBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CategoryButton(
              categories: Category.expenseCategories,
              onCategorySelected: (String label) {
                setState(() {
                  _categoryController.text = label;
                });
              });
        });
  }

  void _showIncomeCategoryBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CategoryButton(
              categories: Category.incomeCategories,
              onCategorySelected: (String label) {
                setState(() {
                  _categoryController.text = label;
                });
              });
        });
  }

  void _addTransaction() {
    final selectedCategoryLabel = _categoryController.text;
    IconData? selectedCategoryIcon;
    final selectedCategory = categories.firstWhere(
      (category) {
        if (category.label == selectedCategoryLabel) {
          selectedCategoryIcon = category.icon;
          return true;
        }
        return false;
      },
      orElse: () =>
          Category(label: selectedCategoryLabel, icon: Icons.category),
    );
    final newTransaction = Transaction(
        date: DateFormat('dd/MM/yyyy (E)').parse(_dateController.text),
        type: selectedType!,
        amount: double.parse(_amountController.text),
        selectedCategory:
            Category(label: selectedCategoryLabel, icon: selectedCategoryIcon),
        selectedAccount: Account(label: _accountController.text));

    allTransactions.value.add(newTransaction);

    allTransactions.value = List.from(allTransactions.value);

    _dateController.clear();
    _amountController.clear();
    _categoryController.clear();
    _accountController.clear();
    selectedType = null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          selectedType!.label,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.left_chevron),
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.star),
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: transactionFields.map((field) {
                  if (field.type == 'date') {
                    return Row(
                      children: [
                        Container(
                          width: 60,
                          child: Text(field.label),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            child: TextField(
                              onTap: () {
                                _showCalendarBottomSheet();
                              },
                              controller: _dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: selectedType!.color ?? Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (field.type == 'number') {
                    return Row(
                      children: [
                        Container(
                          width: 60,
                          child: Text(field.label),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: selectedType?.color ?? Colors.black,
                                ),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              try {
                                field.value = double.parse(value);
                              } catch (e) {
                                field.value = null;
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (field.type == 'text' &&
                      ((selectedType == "Transfer" &&
                              (field.label == "From" ||
                                  field.label == "To" ||
                                  field.label == "Note")) ||
                          ((selectedType != "Transfer" ||
                                  (field.label != "Account" &&
                                      field.label != "Category")) &&
                              (selectedType != "Transfer" &&
                                  (field.label != "From" &&
                                      field.label != "To"))))) {
                    return Row(
                      children: [
                        Container(
                          width: 60,
                          child: Text(
                            field.label,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            child: TextField(
                                onTap: () {
                                  if (field.label == "Account" ||
                                      field.label == "From" ||
                                      field.label == "To") {
                                    _showAccountBottomSheet();
                                  }
                                  if (field.label == "Category" &&
                                      selectedType?.label == "Expense") {
                                    _showExpenseCategoryBottomSheet();
                                  }
                                  if (field.label == "Category" &&
                                      selectedType?.label == "Income") {
                                    _showIncomeCategoryBottomSheet();
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          selectedType?.color ?? Colors.black,
                                    ),
                                  ),
                                ),
                                readOnly: field.label == "Account" ||
                                    field.label == "Category" ||
                                    field.label == "From" ||
                                    field.label == "To",
                                controller: textControllers[
                                    transactionFields.indexOf(field)],
                                onChanged: (value) {
                                  setState(() {
                                    field.value = value;
                                  });
                                }),
                          ),
                        ),
                      ],
                    );
                  } else if (field.type == 'selector') {
                    return TransactionTypeSelector(
                        types: TransactionType.types,
                        onTap: (type) {
                          setState(() {
                            selectedType = type;
                          });
                        });
                  }
                  return SizedBox
                      .shrink(); // Return an empty widget for unsupported field types.
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 237,
                        child: ElevatedButton(
                          onPressed: () {
                            _addTransaction();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(selectedType?.color),
                            elevation: MaterialStateProperty.all(0),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(0),
                            side: MaterialStateProperty.all(
                                BorderSide(color: Colors.black))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
