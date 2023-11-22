import 'package:flutter/material.dart';
import 'package:restart/models/transaction_type_model.dart';

class TransactionTypeSelector extends StatefulWidget {
  final List<TransactionType> types;
  final Function(TransactionType) onTap;
  const TransactionTypeSelector(
      {Key? key, required this.types, required this.onTap})
      : super(key: key);

  @override
  _TransactionTypeSelectorState createState() =>
      _TransactionTypeSelectorState();
}

class _TransactionTypeSelectorState extends State<TransactionTypeSelector> {
  int selectedTypeIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.types.length, (index) {
          final type = widget.types[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTypeIndex = index;
              });
              widget.onTap(widget.types[selectedTypeIndex]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 27.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selectedTypeIndex == index ? type.color! : Colors.grey,
                ),
              ),
              child: Text(
                type.label,
                style: TextStyle(
                  color: selectedTypeIndex == index ? type.color! : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
