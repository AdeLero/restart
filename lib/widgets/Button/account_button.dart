import 'package:flutter/material.dart';
import '../../models/account_model.dart';


class AccountButton extends StatelessWidget {
  final List<Account> accounts;
  final Function(String) onAccountSelected;

  const AccountButton({super.key, required this.accounts, required this.onAccountSelected});

  @override
  Widget build(BuildContext context) {
    return buildAccountTable(context);
  }

  Widget buildAccountTable(BuildContext context) {
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
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {},
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
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: buildTableRows(context),
        ),
      ],
    );
  }

  List<TableRow> buildTableRows(BuildContext context) {
    List<TableRow> rows = [];
    int cellCount = accounts.length;

    int rowCount = (cellCount / 3).ceil();

    for (int i = 0; i < rowCount; i++) {
      List<Widget> rowChildren = [];

      for (int j = 0; j < 3; j++) {
        int index = i * 3 + j;
        if (index < cellCount) {
          final category = accounts[index];
          rowChildren.add(buildAccountCell(context, category));
        } else {
          rowChildren.add(Container());
        }
      }

      rows.add(TableRow(
        children: rowChildren,
      ));
    }

    return rows;
  }

  Widget buildAccountCell(BuildContext context, Account account) {
    return TableCell(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          onAccountSelected(account.label);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Text(
            account.label,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }


}
