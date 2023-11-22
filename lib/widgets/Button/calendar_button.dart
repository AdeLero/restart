import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarButton extends StatefulWidget {
  final DateTime? selectedDay;
  final Function(DateTime?) onDateSelected;

  CalendarButton({
    Key? key,
    this.selectedDay,
    required this.onDateSelected,
}) : super(key: key);

  @override
  State<CalendarButton> createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        TableCalendar(
          firstDay: DateTime(1990),
          focusedDay: DateTime.now(),
          lastDay: DateTime(2200),
          selectedDayPredicate:  (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _selectedDay = focusedDay;
              widget.onDateSelected(_selectedDay);
            });
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          headerVisible: true,
          sixWeekMonthsEnforced: true,
          rowHeight: 45,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.black
            ),
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextFormatter: (date, locale) {
              final month = DateFormat.MMM().format(date); // Get the month abbreviation (e.g., Oct)
              final year = DateFormat.y().format(date); // Get the year (e.g., 2023)
              return '$month $year';
            }
          ),
        ),
      ],
    );
  }
}
