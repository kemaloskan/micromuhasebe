import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item_model.dart';
import '../providers/dashboard_menu_provider.dart';

class MainMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool hasSubItems;
  final bool isExpanded;
  final List<SubMenuItem>? subItems;
  final bool isMobile;
  final VoidCallback? onItemSelected;
  final Function(String title, IconData icon)? onSubItemTap;

  const MainMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.hasSubItems = false,
    this.isExpanded = false,
    this.subItems,
    required this.isMobile,
    this.onItemSelected,
    this.onSubItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<DashboardMenuProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            // Always call toggle for all modules
            menuProvider.toggleModule(title);
          },
          borderRadius: BorderRadius.circular(4),
          hoverColor: const Color(0xFFE3F2FD),
          splashColor: const Color(0xFFBBDEFB),
          child: Container(
            height: isMobile ? 24 : 28,
            margin: EdgeInsets.symmetric(vertical: 1),
            padding: EdgeInsets.only(
              left: isMobile ? 4 : 6,
              right: isMobile ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: isExpanded 
                ? const Color(0xFF2196F3).withValues(alpha: 0.1)
                : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                // Tree connection lines
                SizedBox(
                  width: 16,
                  height: isMobile ? 24 : 28,
                  child: CustomPaint(
                    painter: TreeLinePainter(
                      hasSubItems: hasSubItems,
                      isExpanded: isExpanded,
                      isLast: false, // You can make this dynamic if needed
                      level: 0,
                    ),
                    child: Center(
                      child: hasSubItems 
                        ? Icon(
                            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                            size: 16,
                            color: Colors.grey.shade600,
                          )
                        : null,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                
                // Module/Category Icon
                Icon(
                  _getModuleIcon(title, hasSubItems, isExpanded),
                  size: isMobile ? 14 : 16,
                  color: _getModuleIconColor(title, hasSubItems, isExpanded),
                ),
                SizedBox(width: isMobile ? 6 : 8),
                
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.normal,
                      color: isExpanded 
                        ? const Color(0xFF1976D2)
                        : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (isExpanded && subItems != null)
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 16 : 20),
            child: Column(
              children: subItems!.map((subItem) {
                final isSubSelected = Provider.of<DashboardMenuProvider>(context).isSubItemSelected(subItem.title);
                final isSubExpanded = Provider.of<DashboardMenuProvider>(context).isSubItemExpanded(subItem.title);
                
                return Column(
                  children: [
                    SubMenuItemWidget(
                      subItem: subItem,
                      isSelected: isSubSelected,
                      isExpanded: isSubExpanded,
                      isMobile: isMobile,
                      onTap: () {
                        // Direct call to provider like the old working version
                        if (isSubExpanded) {
                          Provider.of<DashboardMenuProvider>(context, listen: false).toggleSubItem(subItem.title);
                        }
                      },
                      onItemSelected: onItemSelected,
                      onSubItemTap: onSubItemTap,
                    ),
                    
                    // Children
                    if (isSubExpanded && subItem.children != null)
                      Padding(
                        padding: EdgeInsets.only(left: isMobile ? 16 : 20),
                        child: Column(
                          children: subItem.children!.map((child) {
                            final isChildSelected = Provider.of<DashboardMenuProvider>(context).isChildItemSelected(child);
                            return LeafMenuItemWidget(
                              title: child,
                              isSelected: isChildSelected,
                              leftPadding: 0,
                              isMobile: isMobile,
                              onTap: () {
                                Provider.of<DashboardMenuProvider>(context).selectChildItem(child);
                                // No tab opening - just selection
                                onItemSelected?.call();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      
                    // Nested Sub Items (for categories like Tanımlar)
                    if (isSubExpanded && subItem.subItems != null)
                      Padding(
                        padding: EdgeInsets.only(left: isMobile ? 16 : 20),
                        child: Column(
                          children: subItem.subItems!.map((nestedSubItem) {
                            final isNestedExpanded = Provider.of<DashboardMenuProvider>(context).isNestedSubItemExpanded(nestedSubItem.title);
                            
                            return Column(
                              children: [
                                NestedSubMenuItemWidget(
                                  nestedSubItem: nestedSubItem,
                                  isExpanded: isNestedExpanded,
                                  isMobile: isMobile,
                                ),
                                
                                if (isNestedExpanded && nestedSubItem.children != null)
                                  Padding(
                                    padding: EdgeInsets.only(left: isMobile ? 16 : 20),
                                    child: Column(
                                      children: nestedSubItem.children!.map((nestedChild) {
                                        final isNestedChildSelected = Provider.of<DashboardMenuProvider>(context).isChildItemSelected(nestedChild);
                                        return LeafMenuItemWidget(
                                          title: nestedChild,
                                          isSelected: isNestedChildSelected,
                                          leftPadding: 0,
                                          isSmall: true,
                                          isMobile: isMobile,
                                          onTap: () {
                                            Provider.of<DashboardMenuProvider>(context).selectChildItem(nestedChild);
                                            // No tab opening - just selection
                                            onItemSelected?.call();
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class SubMenuItemWidget extends StatelessWidget {
  final SubMenuItem subItem;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool isMobile;
  final VoidCallback? onItemSelected;
  final Function(String title, IconData icon)? onSubItemTap;

  const SubMenuItemWidget({
    super.key,
    required this.subItem,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
    required this.isMobile,
    this.onItemSelected,
    this.onSubItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<DashboardMenuProvider>(context);
    final hasChildren = subItem.children != null || subItem.subItems != null;

    return InkWell(
      onTap: () {
        // Direct call to provider like the old working version
        if (hasChildren) {
          Provider.of<DashboardMenuProvider>(context, listen: false).toggleSubItem(subItem.title);
        }
      },
      borderRadius: BorderRadius.circular(4),
      hoverColor: const Color(0xFFE3F2FD),
      splashColor: const Color(0xFFBBDEFB),
      child: Container(
        height: isMobile ? 20 : 24,
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.only(
          left: isMobile ? 4 : 6,
          right: isMobile ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: isExpanded 
            ? const Color(0xFF2196F3).withValues(alpha: 0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Tree connection lines
            SizedBox(
              width: 16,
              height: isMobile ? 24 : 28,
              child: CustomPaint(
                painter: TreeLinePainter(
                  hasSubItems: hasChildren,
                  isExpanded: isExpanded,
                  isLast: false, // You can make this dynamic if needed
                  level: 1,
                ),
                child: Center(
                  child: hasChildren 
                    ? Icon(
                        isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                        size: 16,
                        color: Colors.grey.shade600,
                      )
                    : Icon(
                        Icons.circle,
                        size: 4,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
            ),
            SizedBox(width: 4),
            
            // Module/Category Icon
            Icon(
              _getModuleIcon(subItem.title, hasChildren, isExpanded),
              size: isMobile ? 12 : 14,
              color: _getModuleIconColor(subItem.title, hasChildren, isExpanded),
            ),
            SizedBox(width: isMobile ? 6 : 8),
            
            Expanded(
              child: Text(
                subItem.title,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.normal,
                  color: isExpanded 
                    ? const Color(0xFF1976D2)
                    : Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeafMenuItemWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSmall;
  final double leftPadding;
  final bool hasChildren;
  final bool isExpanded;
  final bool isMobile;

  const LeafMenuItemWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.isSmall = false,
    this.leftPadding = 0,
    this.hasChildren = false,
    this.isExpanded = false,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<DashboardMenuProvider>(context);

    return InkWell(
      onTap: () {
        // Simple selection
        menuProvider.selectChildItem(title);
        onTap();
      },
      borderRadius: BorderRadius.circular(4),
      hoverColor: const Color(0xFFE3F2FD),
      splashColor: const Color(0xFFBBDEFB),
      child: Container(
        height: isSmall 
            ? (isMobile ? 18 : 20) 
            : (isMobile ? 20 : 24),
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.only(
          left: leftPadding + (isMobile ? 4 : 6),
          right: isMobile ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF2196F3).withValues(alpha: 0.2)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Tree connection lines for leaf items
            SizedBox(
              width: 16,
              height: isSmall ? (isMobile ? 18 : 20) : (isMobile ? 20 : 24),
              child: CustomPaint(
                painter: TreeLinePainter(
                  hasSubItems: false,
                  isExpanded: false,
                  isLast: false,
                  level: isSmall ? 3 : 2,
                ),
              ),
            ),
            SizedBox(width: 4),
            
            // Document icon
            Icon(
              Icons.work_outline,
              size: isMobile ? 10 : 12,
              color: isSelected 
                ? const Color(0xFF1976D2)
                : const Color(0xFF607D8B),
            ),
            SizedBox(width: isMobile ? 6 : 8),
            
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isSmall 
                      ? (isMobile ? 10 : 11) 
                      : (isMobile ? 11 : 12),
                  fontWeight: FontWeight.normal,
                  color: isSelected 
                    ? const Color(0xFF1976D2)
                    : Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NestedSubMenuItemWidget extends StatelessWidget {
  final SubMenuItem nestedSubItem;
  final bool isExpanded;
  final bool isMobile;

  const NestedSubMenuItemWidget({
    super.key,
    required this.nestedSubItem,
    required this.isExpanded,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Direct call to provider like the old working version
        Provider.of<DashboardMenuProvider>(context, listen: false).toggleNestedSubItem(nestedSubItem.title);
      },
      borderRadius: BorderRadius.circular(4),
      hoverColor: const Color(0xFFE3F2FD),
      splashColor: const Color(0xFFBBDEFB),
      child: Container(
        height: isMobile ? 20 : 24,
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.only(
          left: isMobile ? 4 : 6,
          right: isMobile ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: isExpanded 
            ? const Color(0xFF2196F3).withValues(alpha: 0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Tree connection lines for nested items
            SizedBox(
              width: 16,
              height: isMobile ? 20 : 24,
              child: CustomPaint(
                painter: TreeLinePainter(
                  hasSubItems: nestedSubItem.children != null || nestedSubItem.subItems != null,
                  isExpanded: isExpanded,
                  isLast: false,
                  level: 2,
                ),
                child: Center(
                  child: Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 4),
            
            // Module/Category Icon
            Icon(
              _getModuleIcon(nestedSubItem.title, nestedSubItem.children != null || nestedSubItem.subItems != null, isExpanded),
              size: isMobile ? 12 : 14,
              color: _getModuleIconColor(nestedSubItem.title, nestedSubItem.children != null || nestedSubItem.subItems != null, isExpanded),
            ),
            SizedBox(width: isMobile ? 6 : 8),
            
            Expanded(
              child: Text(
                nestedSubItem.title,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.normal,
                  color: isExpanded 
                    ? const Color(0xFF1976D2)
                    : Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _getModuleIcon(String title, bool hasSubItems, bool isExpanded) {
  // Ana modüller için özel ikonlar
  if (title == 'Stok Yönetimi') {
    return hasSubItems ? (isExpanded ? Icons.inventory_2 : Icons.inventory_outlined) : Icons.inventory;
  }
  if (title == 'Satış Yönetimi') {
    return hasSubItems ? (isExpanded ? Icons.point_of_sale : Icons.point_of_sale_outlined) : Icons.point_of_sale;
  }
  if (title == 'Satın Alma Yönetimi') {
    return hasSubItems ? (isExpanded ? Icons.shopping_cart : Icons.shopping_cart_outlined) : Icons.shopping_cart;
  }
  if (title == 'Finans Yönetimi') {
    return hasSubItems ? (isExpanded ? Icons.account_balance : Icons.account_balance_outlined) : Icons.account_balance;
  }
  
  // Alt kategoriler için özel ikonlar
  if (title == 'İşlemler') {
    return hasSubItems ? (isExpanded ? Icons.sync_alt : Icons.swap_horiz_outlined) : Icons.receipt_long;
  }
  if (title == 'Tanımlar') {
    return hasSubItems ? (isExpanded ? Icons.settings : Icons.settings_outlined) : Icons.settings;
  }
  if (title == 'Raporlar') {
    return hasSubItems ? (isExpanded ? Icons.assessment : Icons.assessment_outlined) : Icons.analytics;
  }
  
  // Diğer kategoriler
  if (title.contains('Tanım') || title.contains('Kart')) {
    return hasSubItems ? (isExpanded ? Icons.badge : Icons.badge_outlined) : Icons.article;
  }
  if (title.contains('Grup') || title.contains('Kategori')) {
    return hasSubItems ? (isExpanded ? Icons.category : Icons.category_outlined) : Icons.label;
  }
  if (title.contains('Özellik')) {
    return hasSubItems ? (isExpanded ? Icons.tune : Icons.tune_outlined) : Icons.settings_suggest;
  }
  
  // Varsayılan ikonlar
  if (hasSubItems) {
    return isExpanded ? Icons.folder_open : Icons.folder_outlined;
  } else {
    return Icons.article_outlined;
  }
}

Color _getModuleIconColor(String title, bool hasSubItems, bool isExpanded) {
  // Ana modüller için renkli ikonlar
  if (title == 'Stok Yönetimi') {
    return const Color(0xFF4CAF50); // Yeşil
  }
  if (title == 'Satış Yönetimi') {
    return const Color(0xFF2196F3); // Mavi
  }
  if (title == 'Satın Alma Yönetimi') {
    return const Color(0xFFFF9800); // Turuncu
  }
  if (title == 'Finans Yönetimi') {
    return const Color(0xFF9C27B0); // Mor
  }
  
  // Alt kategoriler için tema renkleri
  if (title == 'İşlemler') {
    return const Color(0xFF1976D2);
  }
  if (title == 'Tanımlar') {
    return const Color(0xFF757575);
  }
  if (title == 'Raporlar') {
    return const Color(0xFFE91E63);
  }
  
  // Varsayılan renkler
  if (hasSubItems) {
    return isExpanded ? Colors.orange.shade600 : Colors.amber.shade700;
  } else {
    return const Color(0xFF607D8B); // Blue grey
  }
}

// Tree line painter for connecting menu items
class TreeLinePainter extends CustomPainter {
  final bool hasSubItems;
  final bool isExpanded;
  final bool isLast;
  final int level;

  TreeLinePainter({
    required this.hasSubItems,
    required this.isExpanded,
    required this.isLast,
    required this.level,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw vertical line (connecting to parent)
    if (level > 0) {
      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX, isLast ? centerY : size.height),
        paint,
      );

      // Draw horizontal line to the item
      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(size.width - 2, centerY),
        paint,
      );
    }

    // Draw vertical line down to children if expanded
    if (hasSubItems && isExpanded && level == 0) {
      canvas.drawLine(
        Offset(centerX, centerY + 8),
        Offset(centerX, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
} 