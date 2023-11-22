import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final String label;
  final IconData? icon;

  Category({
    required this.label,
    this.icon,
  });



  static List<Category> expenseCategories = [
    Category(label: 'Food', icon: Icons.fastfood),
    Category(label: 'Social Life', icon: Icons.people_outline_sharp),
    Category(label: 'Pets', icon: Icons.pets),
    Category(label: 'Transportation', icon: Icons.directions_car),
    Category(label: 'Culture', icon: Icons.filter_frames),
    Category(label: 'Household', icon: Icons.chair_alt),
    Category(label: 'Apparel', icon: Icons.shopping_bag_rounded),
    Category(label: 'Beauty', icon: Icons.shop_2_sharp),
    Category(label: 'Education', icon: Icons.laptop_chromebook),
    Category(label: 'Add'),
  ];

  static List<Category> incomeCategories = [
    Category(label: 'Allowance', icon: Icons.emoji_emotions_rounded),
    Category(label: 'Salary', icon: Icons.shopping_bag),
    Category(label: 'Petty Cash', icon: Icons.money_rounded),
    Category(label: 'Bonus', icon: FontAwesomeIcons.medal),
    Category(label: 'Others'),
    Category(label: 'Add'),

  ];
}
List<Category> categories = [
  ...Category.expenseCategories,
  ...Category.incomeCategories,
];