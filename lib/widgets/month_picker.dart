import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPicker extends StatefulWidget {
  final Function(DateTime) onMonthSelected;
  final DateTime selectedMonth;
  const MonthPicker({Key? key, required this.onMonthSelected, required this.selectedMonth,}) : super (key: key);

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  DateTime today = DateTime.now();

  void _navigateToPreviousMonth() {
    setState(() {
      today = DateTime(today.year, today.month -1);
      widget.onMonthSelected(today);
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      today = DateTime(today.year, today.month +1);
      widget.onMonthSelected(today);
    });
  }

  @override
  Widget build(BuildContext context) {
    final todayDate = '${DateFormat.MMM().format(today)} ${today.year}';
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _navigateToPreviousMonth,
            icon: Icon(
              CupertinoIcons.left_chevron,
            ),
          ),
          Text(
            todayDate
          ),
          IconButton(
            onPressed: _navigateToNextMonth,
            icon: Icon(
              CupertinoIcons.right_chevron,
            ),
          ),
        ],
      ),
    );
  }
}
