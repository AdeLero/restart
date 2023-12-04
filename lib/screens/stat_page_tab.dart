import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:restart/models/transaction_model.dart';
import 'package:restart/models/transaction_type_model.dart';
import 'package:restart/widgets/Button/calendar_button.dart';
import 'package:restart/widgets/month_picker.dart';

class StatTab extends StatefulWidget {
  const StatTab({super.key});

  @override
  State<StatTab> createState() => _StatTabState();
}

class _StatTabState extends State<StatTab> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _date2Controller = TextEditingController();
  int _formatIndex = 1;
  List<String> formats = [
    'Weekly',
    'Monthly',
    'Annually',
    'Period',
    'List',
    'Trend',
  ];

  int _tabIndex = 0;
  final List<String> tabs = [
    'Stats',
    'Budget',
    'Note',
  ];

  String selectedFormatText = 'M';

  DateTime today = DateTime.now();
  final int daysInAWeek = 7;

  void _navigateToNextWeek() {
    setState(() {
      today = today.add(Duration(days: daysInAWeek));
    });
  }

  void _navigateToPreviousWeek() {
    setState(() {
      today = today.subtract(Duration(days: daysInAWeek));
    });
  }

  void _navigateToPreviousYear() {
    setState(() {
      today = DateTime(today.year - 1);
    });
  }

  void _navigateToNextYear() {
    setState(() {
      today = DateTime(today.year + 1);
    });
  }

  void _showCalendarBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CalendarButton(
              selectedDay: today,
              onDateSelected: (newDate) {
                if (newDate != null) {
                  setState(() {
                    today = newDate;
                    _dateController.text =
                        DateFormat('dd/MM/yyyy').format(newDate);
                  });
                }
                Navigator.pop(context);
              });
        });
  }

  void _showCalendar2BottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CalendarButton(
              selectedDay: today,
              onDateSelected: (newDate) {
                if (newDate != null) {
                  setState(() {
                    today = newDate;
                    _date2Controller.text =
                        DateFormat('dd/MM/yyyy').format(newDate);
                  });
                }
                Navigator.pop(context);
              });
        });
  }

  String getWeekDate() {
    int daysUntilEndOfWeek = DateTime.saturday - today.weekday;
    DateTime todayWeek = today.add(Duration(days: daysUntilEndOfWeek + 1));
    DateTime startOfWeek =
        todayWeek.subtract(Duration(days: todayWeek.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: daysInAWeek - 1));

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateFormat formatte = DateFormat('dd/MM');
    final String formattedStart = formatte.format(startOfWeek);
    final String formattedEnd = formatter.format(endOfWeek);

    return '$formattedStart ~ $formattedEnd';
  }

  void updateSelectedMonth(DateTime newMonth) {
    setState(() {
      today = newMonth;
    });
  }

  void _showFormatBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(formats.length, (index) {
                        final isSelected = _formatIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _formatIndex = index;
                              switch (formats[index]) {
                                case 'Weekly':
                                  selectedFormatText = 'W';
                                  break;
                                case 'Annually':
                                  selectedFormatText = 'Y';
                                  break;
                                case 'Period':
                                  selectedFormatText = 'P';
                                  break;
                                default:
                                  selectedFormatText = 'M';
                              }
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formats[index].toString(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.redAccent
                                        : Colors.black,
                                  ),
                                ),
                                Icon(
                                  isSelected ? Icons.check : null,
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Map<String, double> incomeCategoryPercentages = {};
  Map<String, double> expenseCategoryPercentages = {};

  Map<String, double> incomeCategoryAmounts = {};
  Map<String, double> expenseCategoryAmounts = {};

  void calculateCategoryPercentages() {
    incomeCategoryPercentages.clear();
    expenseCategoryPercentages.clear();
    incomeCategoryAmounts.clear();
    expenseCategoryAmounts.clear();

    if (allTransactions.value.isEmpty) {
      return;
    }

    List<Transaction> expenseTransactions = allTransactions.value
        .where((transaction) => transaction.type == TransactionType.expense)
        .toList();

    List<Transaction> incomeTransactions = allTransactions.value
        .where((transaction) => transaction.type == TransactionType.income)
        .toList();

    calculatePercentage(expenseTransactions, expenseCategoryPercentages);
    calculatePercentage(incomeTransactions, incomeCategoryPercentages);
  }

  void calculatePercentage(
      List<Transaction> transactions, Map<String, double> categoryPercentages) {
    Map<String, double> categoryAmounts = {};

    if (allTransactions.value.isEmpty) {
      return;
    }

    for (Transaction transaction in transactions) {
      String categoryLabel = transaction.selectedCategory.label;
      double amount = transaction.amount;
      categoryAmounts.update(categoryLabel, (value) => value + amount,
          ifAbsent: () => amount);
    }
    double totalAmountSpent = categoryAmounts.values.reduce((a, b) => a + b);

    if (totalAmountSpent <= 0) {
      return;
    }

    categoryAmounts.forEach((categoryLabel, amount) {
      double percentage = (amount / totalAmountSpent) * 100;
      categoryPercentages[categoryLabel] = percentage;
    });
  }

  void calculateCategoryAmounts() {
    incomeCategoryAmounts.clear();
    expenseCategoryAmounts.clear();

    if (allTransactions.value.isEmpty) {
      return;
    }

    for (Transaction transaction in allTransactions.value) {
      String categoryLabel = transaction.selectedCategory.label;
      double amount = transaction.amount;

      if (transaction.type == TransactionType.income) {
        incomeCategoryAmounts.update(categoryLabel, (value) => value + amount,
            ifAbsent: () => amount);
      } else if (transaction.type == TransactionType.expense) {
        expenseCategoryAmounts.update(categoryLabel, (value) => value + amount,
            ifAbsent: () => amount);
      }
    }
  }

  List<Color> customColors = [
    Colors.redAccent,
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.orangeAccent,
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
    Colors.lightBlue,
    Colors.blue,
    Colors.purple,
    Colors.pinkAccent,
    Colors.pink.shade900,
  ];

  @override
  Widget build(BuildContext context) {
    calculateCategoryPercentages();
    calculateCategoryAmounts();
    final weekDate = getWeekDate();
    final yearDate = '${today.year}';
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: List.generate(
                      tabs.length,
                      (index) {
                        final isSelected = _tabIndex == index;
                        final tab = tabs[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _tabIndex = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: isSelected
                                ? BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  )
                                : BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                            child: Text(
                              tab.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.red
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showFormatBottomSheet();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(selectedFormatText),
                        ),
                        Icon(Icons.arrow_drop_down_sharp)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_formatIndex == 1)
            MonthPicker(
              onMonthSelected: updateSelectedMonth,
              selectedMonth: today,
            ),
          if (_formatIndex == 0)
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _navigateToPreviousWeek,
                    icon: Icon(
                      CupertinoIcons.left_chevron,
                    ),
                  ),
                  Text(weekDate),
                  IconButton(
                    onPressed: _navigateToNextWeek,
                    icon: Icon(
                      CupertinoIcons.right_chevron,
                    ),
                  ),
                ],
              ),
            ),
          if (_formatIndex == 2)
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _navigateToPreviousYear,
                    icon: Icon(
                      CupertinoIcons.left_chevron,
                    ),
                  ),
                  Text(yearDate),
                  IconButton(
                    onPressed: _navigateToNextYear,
                    icon: Icon(
                      CupertinoIcons.right_chevron,
                    ),
                  ),
                ],
              ),
            ),
          if (_formatIndex == 3)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(_date2Controller.text),
                      IconButton(
                        onPressed: () {
                          _showCalendar2BottomSheet();
                        },
                        icon: Icon(
                          Icons.calendar_month_sharp,
                        ),
                      ),
                    ],
                  ),
                  Text('~'),
                  Row(
                    children: [
                      Text(_dateController.text),
                      IconButton(
                        onPressed: () {
                          _showCalendarBottomSheet();
                        },
                        icon: Icon(
                          Icons.calendar_month_sharp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      indicatorColor: Colors.redAccent,
                      unselectedLabelColor: Colors.grey.shade500,
                      labelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Income'),
                        Tab(text: 'Expense'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.60,
                    child: TabBarView(
                      children: [
                        Container(
                          child: incomeCategoryPercentages.isNotEmpty
                              ? SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      child: PieChart(
                            dataMap: incomeCategoryPercentages,
                            chartRadius:
                            MediaQuery.of(context).size.width / 2.7,
                            chartType: ChartType.disc,
                            chartValuesOptions: ChartValuesOptions(
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 1,
                              chartValueBackgroundColor: Colors.transparent,
                            ),
                                        colorList: customColors,
                                        legendOptions: LegendOptions(
                                          showLegends: false,
                                        ),
                          ),
                                      color: Colors.white,
                                      padding: EdgeInsets.all(20),
                                    ),
                                    SizedBox(height: 20),

                                    Column(
                                      children: incomeCategoryPercentages.entries.map((entry) {
                                        String categoryLabel = entry.key;
                                        double percentage = entry.value;
                                        double totalAmountSpent = incomeCategoryAmounts[categoryLabel] ?? 0.0;

                                        Color categoryColor = customColors[incomeCategoryPercentages.keys.toList().indexOf(categoryLabel)];

                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                              child: Text(
                                                '${percentage.toStringAsFixed(0)}%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: categoryColor,
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              ),
                                              Text(categoryLabel),
                                              Text('\u20A6 $totalAmountSpent'),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              )
                              : Center(child: Text('No data available')),
                        ),
                        Container(
                          child: expenseCategoryPercentages.isNotEmpty
                              ? SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  child: PieChart(
                                    dataMap: expenseCategoryPercentages,
                                    chartRadius:
                                    MediaQuery.of(context).size.width / 2.7,
                                    chartType: ChartType.disc,
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 1,
                                      chartValueBackgroundColor: Colors.transparent,
                                    ),
                                    colorList: customColors,
                                    legendOptions: LegendOptions(
                                      showLegends: false,
                                    ),
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(20),
                                ),
                                SizedBox(height: 20),

                                Column(
                                  children: expenseCategoryPercentages.entries.map((entry) {
                                    String categoryLabel = entry.key;
                                    double percentage = entry.value;
                                    double totalAmountSpent = expenseCategoryAmounts[categoryLabel] ?? 0.0;

                                    Color categoryColor = customColors[expenseCategoryPercentages.keys.toList().indexOf(categoryLabel)];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              '${percentage.toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: categoryColor,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          Text(categoryLabel),
                                          Text('\u20A6 $totalAmountSpent'),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          )
                              : Center(child: Text('No data available')),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
