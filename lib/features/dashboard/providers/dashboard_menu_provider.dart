import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import 'menu_data_provider.dart';

class DashboardMenuProvider extends ChangeNotifier {
  String _selectedModule = '';
  String _expandedModule = '';
  String? _expandedSubItem;
  String? _expandedNestedSubItem;
  String? _selectedChildItem;
  
  List<MenuItem> _menuItems = [];

  String get selectedModule => _selectedModule;
  String get expandedModule => _expandedModule;
  String? get expandedSubItem => _expandedSubItem;
  String? get expandedNestedSubItem => _expandedNestedSubItem;
  String? get selectedChildItem => _selectedChildItem;
  List<MenuItem> get menuItems => _menuItems;

  DashboardMenuProvider() {
    _menuItems = MenuDataProvider.getMenuItems();
  }

  // Modül seç (üst tab'lardan)
  void selectModule(String moduleTitle) {
    _selectedModule = moduleTitle;
    _expandedModule = moduleTitle;
    _expandedSubItem = null;
    _expandedNestedSubItem = null;
    _selectedChildItem = null;
    notifyListeners();
  }

  // Ana modül toggle
  void toggleModule(String moduleTitle) {
    if (_expandedModule == moduleTitle) {
      // Açık - kapat
      _expandedModule = '';
      _expandedSubItem = null;
      _expandedNestedSubItem = null;
    } else {
      // Kapalı - aç
      _selectedModule = moduleTitle;
      _expandedModule = moduleTitle;
      _expandedSubItem = null;
      _expandedNestedSubItem = null;
    }
    _selectedChildItem = null;
    notifyListeners();
  }

  // Sub item toggle
  void toggleSubItem(String subItemTitle) {
    if (_expandedSubItem == subItemTitle) {
      // Açık - kapat
      _expandedSubItem = null;
      _expandedNestedSubItem = null;
    } else {
      // Kapalı - aç
      _expandedSubItem = subItemTitle;
      _expandedNestedSubItem = null;
    }
    notifyListeners();
  }

  // Nested sub item toggle
  void toggleNestedSubItem(String nestedSubItemTitle) {
    if (_expandedNestedSubItem == nestedSubItemTitle) {
      // Açık - kapat
      _expandedNestedSubItem = null;
    } else {
      // Kapalı - aç
      _expandedNestedSubItem = nestedSubItemTitle;
    }
    notifyListeners();
  }

  // Child item seç
  void selectChildItem(String childTitle) {
    _selectedChildItem = childTitle;
    
    // Hangi modül ve sub item'a ait olduğunu bul ve sidebar'ı aç
    for (var module in _menuItems) {
      if (module.subItems != null) {
        for (var subItem in module.subItems!) {
          // Direct children'da ara
          if (subItem.children != null && subItem.children!.contains(childTitle)) {
            _selectedModule = module.title;
            _expandedModule = module.title;
            _expandedSubItem = subItem.title;
            _expandedNestedSubItem = null;
            notifyListeners();
            return;
          }
          
          // Nested sub items'da ara
          if (subItem.subItems != null) {
            for (var nestedSubItem in subItem.subItems!) {
              if (nestedSubItem.children != null && nestedSubItem.children!.contains(childTitle)) {
                _selectedModule = module.title;
                _expandedModule = module.title;
                _expandedSubItem = subItem.title;
                _expandedNestedSubItem = nestedSubItem.title;
                notifyListeners();
                return;
              }
            }
          }
        }
      }
    }
    notifyListeners();
  }

  void selectChildItemWithSidebarSync(String childTitle) {
    selectChildItem(childTitle);
  }

  // Helper methods
  MenuItem? getSelectedMenuItem() {
    final items = _menuItems.where((item) => item.title == _selectedModule);
    return items.isEmpty ? null : items.first;
  }

  SubMenuItem? getSelectedSubItem() {
    final selectedItem = getSelectedMenuItem();
    if (selectedItem?.subItems == null || _expandedSubItem == null) {
      return null;
    }
    
    final subItems = selectedItem!.subItems!
        .where((subItem) => subItem.title == _expandedSubItem);
    return subItems.isEmpty ? null : subItems.first;
  }

  // State checkers
  bool isModuleSelected(String moduleTitle) => _expandedModule == moduleTitle;
  bool isModuleExpanded(String moduleTitle) => _expandedModule == moduleTitle;
  bool isSubItemSelected(String subItemTitle) => _expandedSubItem == subItemTitle;
  bool isSubItemExpanded(String subItemTitle) => _expandedSubItem == subItemTitle;
  bool isNestedSubItemExpanded(String nestedSubItemTitle) => _expandedNestedSubItem == nestedSubItemTitle;
  bool isChildItemSelected(String childTitle) => _selectedChildItem == childTitle;
} 