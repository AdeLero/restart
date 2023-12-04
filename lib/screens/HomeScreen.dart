import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:restart/screens/add_screen.dart';
import 'package:restart/screens/account_page_tab.dart';
import 'package:restart/screens/stat_page_tab.dart';
import 'package:restart/widgets/month_picker.dart';
import 'package:restart/widgets/tab_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> formats = [
    'Weekly',
    'Monthly',
    'Annually',
    'Period',
    'List',
    'Trend',
  ];

  final List<String> tabs = [
    'Stats',
    'Budget',
    'Note',
  ];
  int _currentIndex = 0;

  String selectedFormatText = 'M';

  DateTime today = DateTime.now();
  final int daysInAWeek = 7;








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


  @override
  Widget build(BuildContext context) {
    final todayDate = '${DateFormat.Md().format(today)}';
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
        StatTab(),
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
