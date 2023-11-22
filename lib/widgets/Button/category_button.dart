import 'package:flutter/material.dart';
import 'package:restart/models/category_model.dart';


class CategoryButton extends StatelessWidget {
  final List<Category> categories;
  final Function(String) onCategorySelected;

  CategoryButton({required this.categories, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return buildCategoryTable(context);
  }

  Widget buildCategoryTable(BuildContext context) {
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
                  'Category',
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
    int cellCount = categories.length;

    int rowCount = (cellCount / 3).ceil();

    for (int i = 0; i < rowCount; i++) {
      List<Widget> rowChildren = [];

      for (int j = 0; j < 3; j++) {
        int index = i * 3 + j;
        if (index < cellCount) {
          final category = categories[index];
          rowChildren.add(buildCategoryCell(context, category));
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


  Widget buildCategoryCell(BuildContext context, Category category) {
    return TableCell(
      child: GestureDetector(
        onTap: () {
          print('Selected Category: ${category.label}');
          Navigator.of(context).pop();
          onCategorySelected(category.label);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Row(
            children: [
              Icon(
                category.icon,
                size: 24,
              ),
              SizedBox(width: 4),
              Text(
                category.label,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
