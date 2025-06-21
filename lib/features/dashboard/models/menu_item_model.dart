import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final List<SubMenuItem>? subItems;

  MenuItem({
    required this.title,
    required this.icon,
    this.subItems,
  });
}

class SubMenuItem {
  final String title;
  final IconData icon;
  final List<String>? children;
  final List<SubMenuItem>? subItems;

  SubMenuItem({
    required this.title,
    required this.icon,
    this.children,
    this.subItems,
  });
}

class MenuState {
  final String selectedModule;
  final String? selectedSubItem;
  final String? selectedChildItem;
  final String? lastSelectedChildItem;
  final String expandedModule;
  final String? expandedSubItem;
  final String? expandedChildItem;
  final Set<String> expandedGrandChildren;

  const MenuState({
    required this.selectedModule,
    this.selectedSubItem,
    this.selectedChildItem,
    this.lastSelectedChildItem,
    required this.expandedModule,
    this.expandedSubItem,
    this.expandedChildItem,
    required this.expandedGrandChildren,
  });

  MenuState copyWith({
    String? selectedModule,
    String? selectedSubItem,
    String? selectedChildItem,
    String? lastSelectedChildItem,
    String? expandedModule,
    String? expandedSubItem,
    String? expandedChildItem,
    Set<String>? expandedGrandChildren,
  }) {
    return MenuState(
      selectedModule: selectedModule ?? this.selectedModule,
      selectedSubItem: selectedSubItem,
      selectedChildItem: selectedChildItem,
      lastSelectedChildItem: lastSelectedChildItem,
      expandedModule: expandedModule ?? this.expandedModule,
      expandedSubItem: expandedSubItem,
      expandedChildItem: expandedChildItem,
      expandedGrandChildren: expandedGrandChildren ?? this.expandedGrandChildren,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MenuState &&
      other.selectedModule == selectedModule &&
      other.selectedSubItem == selectedSubItem &&
      other.selectedChildItem == selectedChildItem &&
      other.lastSelectedChildItem == lastSelectedChildItem &&
      other.expandedModule == expandedModule &&
      other.expandedSubItem == expandedSubItem &&
      other.expandedChildItem == expandedChildItem &&
      other.expandedGrandChildren == expandedGrandChildren;
  }

  @override
  int get hashCode {
    return selectedModule.hashCode ^
      selectedSubItem.hashCode ^
      selectedChildItem.hashCode ^
      lastSelectedChildItem.hashCode ^
      expandedModule.hashCode ^
      expandedSubItem.hashCode ^
      expandedChildItem.hashCode ^
      expandedGrandChildren.hashCode;
  }
} 