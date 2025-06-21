import 'package:flutter/material.dart';

class TabItem {
  final String id;
  final String title;
  final IconData icon;
  final Widget content;
  final DateTime createdAt;
  final bool isMainTab;

  TabItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.content,
    DateTime? createdAt,
    this.isMainTab = false,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TabProvider extends ChangeNotifier {
  final List<TabItem> _tabs = [];
  int _activeTabIndex = 0;

  TabProvider() {
    // Initialize with empty tabs - no default dashboard tab
  }

  List<TabItem> get tabs => List.unmodifiable(_tabs);
  int get activeTabIndex => _activeTabIndex;
  TabItem? get activeTab => _tabs.isNotEmpty ? _tabs[_activeTabIndex] : null;
  bool get hasTabs => _tabs.isNotEmpty;

  void openTab({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    final id = _generateTabId(title);
    
    // Aynı tab zaten açık mı kontrol et
    final existingIndex = _tabs.indexWhere((tab) => tab.id == id);
    if (existingIndex != -1) {
      // Varolan tab'a geç
      _activeTabIndex = existingIndex;
      notifyListeners();
      return;
    }

    // Yeni tab oluştur
    final newTab = TabItem(
      id: id,
      title: title,
      icon: icon,
      content: content,
      isMainTab: false,
    );

    _tabs.add(newTab);
    _activeTabIndex = _tabs.length - 1;
    notifyListeners();
  }

  void closeTab(int index) {
    if (index < 0 || index >= _tabs.length) return;

    _tabs.removeAt(index);
    
    // Aktif tab ayarlaması
    if (_tabs.isEmpty) {
      _activeTabIndex = 0;
    } else if (_activeTabIndex >= _tabs.length) {
      _activeTabIndex = _tabs.length - 1;
    } else if (index < _activeTabIndex) {
      _activeTabIndex--;
    }
    
    notifyListeners();
  }

  void setActiveTab(int index) {
    if (index >= 0 && index < _tabs.length) {
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  void closeAllTabs() {
    _tabs.clear();
    _activeTabIndex = 0;
    notifyListeners();
  }

  String _generateTabId(String title) {
    return title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }

  // Tab operations
  void addTab(TabItem newTab) {
    // Check if tab already exists
    final existingIndex = _tabs.indexWhere((tab) => tab.id == newTab.id);
    if (existingIndex != -1) {
      setActiveTab(existingIndex);
      return;
    }
    
    // Add new tab
    _tabs.add(newTab);
    _activeTabIndex = _tabs.length - 1;
    notifyListeners();
  }
} 