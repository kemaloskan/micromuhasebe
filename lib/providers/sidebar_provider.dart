import 'package:flutter/material.dart';

class SidebarProvider extends ChangeNotifier {
  bool _isPinned = true;
  bool _isHovering = false;

  bool get isPinned => _isPinned;
  bool get isHovering => _isHovering;

  bool get isExpanded => _isPinned || _isHovering;

  void togglePin() {
    _isPinned = !_isPinned;
    if (!_isPinned) {
      _isHovering = false;
    }
    notifyListeners();
  }

  void onHoverEntered() {
    if (!_isHovering) {
      _isHovering = true;
      notifyListeners();
    }
  }

  void onHoverExited() {
    if (_isHovering) {
      _isHovering = false;
      notifyListeners();
    }
  }
} 