import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  List<MenuItem> _menuItems = [
    MenuItem(
      title: 'Dashboards',
      icon: Icons.dashboard_outlined,
      type: MenuItemType.link,
      badgeCount: 5,
    ),
    MenuItem(
      title: 'APPS & PAGES',
      type: MenuItemType.header,
    ),
    MenuItem(
      title: 'eCommerce',
      icon: Icons.shopping_cart_outlined,
      type: MenuItemType.collapsible,
      subItems: [
        SubMenuItem(title: 'Tümü'),
        SubMenuItem(title: 'Ürünler'),
        SubMenuItem(title: 'Siparişler'),
      ],
    ),
    MenuItem(
      title: 'Lojistik',
      icon: Icons.local_shipping_outlined,
      type: MenuItemType.link,
    ),
    MenuItem(
      title: 'Akademi',
      icon: Icons.school_outlined,
      type: MenuItemType.link,
    ),
  ];

  List<MenuItem> get menuItems => _menuItems;

  String? _selectedItem = 'Dashboards';
  String? get selectedItem => _selectedItem;

  final Set<String> _expandedModules = {};
  final Set<String> _expandedSubItems = {};

  bool isModuleExpanded(String title) => _expandedModules.contains(title);
  bool isSubItemExpanded(String title) => _expandedSubItems.contains(title);

  void toggleModule(String title) {
    if (_expandedModules.contains(title)) {
      _expandedModules.remove(title);
    } else {
      _expandedModules.add(title);
    }
    notifyListeners();
  }

  void toggleSubItem(String title) {
    if (_expandedSubItems.contains(title)) {
      _expandedSubItems.remove(title);
    } else {
      _expandedSubItems.add(title);
    }
    notifyListeners();
  }

  void selectItem(String title) {
    _selectedItem = title;
    notifyListeners();
  }
} 