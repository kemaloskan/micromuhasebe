import 'package:flutter/material.dart';

enum MenuItemType { header, link, collapsible }

class MenuItem {
  final String title;
  final IconData? icon;
  final MenuItemType type;
  final int? badgeCount;
  final List<SubMenuItem>? subItems;

  MenuItem({
    required this.title,
    this.icon,
    this.type = MenuItemType.collapsible,
    this.badgeCount,
    this.subItems,
  });
}

class SubMenuItem {
  final String title;
  final IconData? icon;
  final List<String>? children;
  final List<SubMenuItem>? subItems;

  SubMenuItem({
    required this.title,
    this.icon,
    this.children,
    this.subItems,
  });
} 