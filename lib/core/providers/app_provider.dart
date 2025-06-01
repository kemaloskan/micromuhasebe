import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isMenuCollapsed = false;
  String _selectedModule = 'Dashboard';
  String? _selectedSubModule;
  String? _selectedItem;
  Set<String> _expandedModules = {};

  bool get isMenuCollapsed => _isMenuCollapsed;
  String get selectedModule => _selectedModule;
  String? get selectedSubModule => _selectedSubModule;
  String? get selectedItem => _selectedItem;
  Set<String> get expandedModules => _expandedModules;

  void init() {
    // Initialize default state
    _selectedModule = 'Dashboard';
    _selectedSubModule = null;
    _selectedItem = null;
    _expandedModules.clear();
    notifyListeners();
  }

  void toggleMenu() {
    _isMenuCollapsed = !_isMenuCollapsed;
    notifyListeners();
  }

  void selectModule(String module) {
    if (_selectedModule != module) {
      _selectedModule = module;
      _selectedSubModule = null;
      _selectedItem = null;
      
      // Toggle expansion for modules with sub-items
      if (module != 'Dashboard') {
        if (_expandedModules.contains(module)) {
          _expandedModules.remove(module);
        } else {
          _expandedModules.clear(); // Close other modules
          _expandedModules.add(module);
        }
      } else {
        _expandedModules.clear();
      }
      
      notifyListeners();
    }
  }

  void selectSubModule(String subModule) {
    _selectedSubModule = subModule;
    _selectedItem = null;
    notifyListeners();
  }

  void selectItem(String item) {
    _selectedItem = item;
    notifyListeners();
  }

  bool isModuleExpanded(String module) {
    return _expandedModules.contains(module);
  }

  void toggleModuleExpansion(String module) {
    if (_expandedModules.contains(module)) {
      _expandedModules.remove(module);
    } else {
      _expandedModules.add(module);
    }
    notifyListeners();
  }

  void collapseAllModules() {
    _expandedModules.clear();
    notifyListeners();
  }

  void expandModule(String module) {
    _expandedModules.add(module);
    notifyListeners();
  }

  void navigateToItem(String module, String? subModule, String? item) {
    _selectedModule = module;
    _selectedSubModule = subModule;
    _selectedItem = item;
    
    if (module != 'Dashboard' && !_expandedModules.contains(module)) {
      _expandedModules.add(module);
    }
    
    notifyListeners();
  }

  void resetNavigation() {
    _selectedModule = 'Dashboard';
    _selectedSubModule = null;
    _selectedItem = null;
    _expandedModules.clear();
    notifyListeners();
  }

  String getBreadcrumb() {
    if (_selectedModule == 'Dashboard') {
      return 'Dashboard';
    }
    
    String breadcrumb = _selectedModule;
    
    if (_selectedSubModule != null) {
      breadcrumb += ' > $_selectedSubModule';
    }
    
    if (_selectedItem != null) {
      breadcrumb += ' > $_selectedItem';
    }
    
    return breadcrumb;
  }
} 