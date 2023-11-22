import 'package:flutter/material.dart';
  import 'package:restart/widgets/tabs/calendar_tab.dart';
import 'package:restart/widgets/tabs/daily_tab.dart';
import 'package:restart/widgets/tabs/monthly_tab.dart';
import 'package:restart/widgets/tabs/note_tab.dart';
import 'package:restart/widgets/tabs/summary_tab.dart';

class TabSelector extends StatefulWidget {
  final DateTime selectedMonth;
  const TabSelector({Key? key, required this.selectedMonth,}) : super(key: key);

  @override
  State<TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<TabSelector>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabsList = [
      DailyTab(selectedMonth: widget.selectedMonth),
      CalendarTab(selectedMonth: widget.selectedMonth),
      MonthlyTab(selectedMonth: widget.selectedMonth),
      SummaryTab(selectedMonth: widget.selectedMonth),
      NoteTab(),
    ];
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Daily'),
            Tab(text: 'Calendar'),
            Tab(text: 'Monthly'),
            Tab(text: 'Summary'),
            Tab(text: 'Note'),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelPadding: EdgeInsets.all(5),
          indicatorColor: Colors.redAccent,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabsList,
          ),
        ),
      ],
    );

  }
}
