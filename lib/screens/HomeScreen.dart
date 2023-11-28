import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:restart/screens/add_screen.dart';
import 'package:restart/stat_page_tab.dart';
import 'package:restart/widgets/Button/calendar_button.dart';
import 'package:restart/widgets/month_picker.dart';
import 'package:restart/widgets/tab_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final todayDate = '${DateFormat.Md().format(today)}';
    final weekDate = getWeekDate();
    final yearDate = '${today.year}';
    var size =MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Transaction',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.star,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : null,
      body: <Widget>[
        Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: MonthPicker(
                  onMonthSelected: updateSelectedMonth,
                  selectedMonth: today,
                ),
              ),
              Expanded(
                  child: Container(
                      color: Colors.white,
                      child: TabSelector(
                        selectedMonth: today,
                      ))),
            ],
          ),
        ),
        SafeArea(
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
                                                  color: Colors.black
                                                      .withOpacity(0.3),
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
              SizedBox(
                width:size.width,height: size.height*0.45,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: Colors.redAccent,
                        unselectedLabelColor: Colors.grey.shade500,
                        labelColor: Colors.black,
                         tabs: [
                           Tab( text: 'Income'),
                           Tab( text: 'Expense'),
                         ],
                      ),
                      TabBarView(
                          children: [
                            Center(child: Text('Income')),
                            Center(child: Text('Expense')),
                          ],
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
        AccountTab(),
        Container(
          child: Text('data'),
        ),
      ][_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddScreen()),
                );
              },
            )
          : null,
      bottomNavigationBar: NavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: Colors.redAccent,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedIndex: _currentIndex,
          destinations: [
            NavigationDestination(
              label: todayDate,
              icon: Icon(
                Icons.calendar_today_rounded,
              ),
            ),
            NavigationDestination(
              label: 'Stats',
              icon: Icon(
                Icons.insert_chart_outlined,
              ),
            ),
            NavigationDestination(
              label: 'Accounts',
              icon: Icon(
                Icons.money,
              ),
            ),
            NavigationDestination(
              label: 'More',
              icon: Icon(
                Icons.more_horiz,
              ),
            ),
          ]),
    );
  }
}

//TODO
