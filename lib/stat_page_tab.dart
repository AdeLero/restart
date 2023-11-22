import 'package:flutter/material.dart';

class StatTab extends StatefulWidget {
  const StatTab({super.key});

  @override
  State<StatTab> createState() => _StatTabState();
}

class _StatTabState extends State<StatTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Income'),
                Tab(text: 'Expense'),
              ],
            ),
          ],
        ),
    );
  }
}
