import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_menu_provider.dart';
import 'menu_item_widgets.dart';

class DashboardMenu extends StatefulWidget {
  final bool isMobile;
  final VoidCallback? onItemSelected;
  
  const DashboardMenu({
    super.key,
    required this.isMobile,
    this.onItemSelected,
  });

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive width
        double menuWidth;
        if (widget.isMobile) {
          menuWidth = constraints.maxWidth * 0.85; // Mobile'da ekranın %85'i
          if (menuWidth > 300) menuWidth = 300; // Max 300px
        } else {
          menuWidth = 280; // Desktop/tablet'ta sabit
        }
        
        return Container(
          width: menuWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Consumer<DashboardMenuProvider>(
                  builder: (context, menuProvider, child) {
                    // Get all leaf items for search
                    List<String> allLeafItems = [];
                    Map<String, IconData> leafItemIcons = {};
                    
                    for (var module in menuProvider.menuItems) {
                      if (module.subItems != null) {
                        for (var subItem in module.subItems!) {
                          // Direct children
                          if (subItem.children != null) {
                            for (var child in subItem.children!) {
                              allLeafItems.add(child);
                              leafItemIcons[child] = subItem.icon;
                            }
                          }
                          // Nested sub items
                          if (subItem.subItems != null) {
                            for (var nestedSubItem in subItem.subItems!) {
                              if (nestedSubItem.children != null) {
                                for (var nestedChild in nestedSubItem.children!) {
                                  allLeafItems.add(nestedChild);
                                  leafItemIcons[nestedChild] = nestedSubItem.icon;
                                }
                              }
                            }
                          }
                        }
                      }
                    }

                    // Filter leaf items based on search query
                    final filteredLeafItems = _searchQuery.isEmpty
                        ? <String>[]
                        : allLeafItems.where((item) => 
                            item.toLowerCase().contains(_searchQuery)
                          ).toList();

                    // Filter menu items for normal display
                    final filteredMenuItems = _searchQuery.isEmpty
                        ? menuProvider.menuItems
                        : <dynamic>[];

                    return ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isMobile ? 12 : 16,
                      ),
                      children: [
                        if (_searchQuery.isEmpty) ...[
                          // Main Modules Category
                          _buildCategoryHeader('ANA MODÜLLER'),
                          const SizedBox(height: 8),
                          
                          ...filteredMenuItems
                              .where((item) => item.title != 'Finans Yönetimi')
                              .map((item) => MainMenuItem(
                                title: item.title,
                                icon: _getOutlinedIcon(item.icon),
                                isSelected: menuProvider.isModuleSelected(item.title),
                                hasSubItems: item.subItems != null,
                                isExpanded: menuProvider.isModuleExpanded(item.title),
                                isMobile: widget.isMobile,
                                onTap: () => menuProvider.toggleModule(item.title),
                                subItems: item.subItems,
                                onItemSelected: widget.onItemSelected,
                                onSubItemTap: (title, icon) => {}, // Empty function - no tabs
                              )),
                          
                          const SizedBox(height: 32),
                          
                          // Finance Category
                          _buildCategoryHeader('FİNANS & MUHASEBE'),
                          const SizedBox(height: 8),
                          
                          ...filteredMenuItems
                              .where((item) => item.title == 'Finans Yönetimi')
                              .map((item) => MainMenuItem(
                                title: item.title,
                                icon: _getOutlinedIcon(item.icon),
                                isSelected: menuProvider.isModuleSelected(item.title),
                                hasSubItems: item.subItems != null,
                                isExpanded: menuProvider.isModuleExpanded(item.title),
                                isMobile: widget.isMobile,
                                onTap: () => menuProvider.toggleModule(item.title),
                                subItems: item.subItems,
                                onItemSelected: widget.onItemSelected,
                                onSubItemTap: (title, icon) => {}, // Empty function - no tabs
                              )),
                        ] else ...[
                          // Search Results - Only Leaf Items
                          _buildCategoryHeader('ARAMA SONUÇLARI'),
                          const SizedBox(height: 8),
                          
                          if (filteredLeafItems.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Arama sonucu bulunamadı',
                                style: TextStyle(
                                  fontSize: widget.isMobile ? 13 : 14,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          else
                            ...filteredLeafItems.map((leafItem) => 
                              _buildSearchResultItem(
                                leafItem, 
                                leafItemIcons[leafItem] ?? Icons.description,
                                menuProvider,
                              )
                            ),
                        ],
                        
                        SizedBox(height: widget.isMobile ? 20 : 24),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.isMobile ? 6 : 8,
        bottom: 4,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: widget.isMobile ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade400,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  IconData _getOutlinedIcon(IconData icon) {
    // Convert filled icons to outlined versions
    if (icon == Icons.inventory) return Icons.inventory_2_outlined;
    if (icon == Icons.point_of_sale) return Icons.point_of_sale_outlined;
    if (icon == Icons.shopping_cart) return Icons.shopping_cart_outlined;
    if (icon == Icons.account_balance) return Icons.account_balance_outlined;
    return icon;
  }

  Widget _buildSearchResultItem(String leafItem, IconData icon, DashboardMenuProvider menuProvider) {
    return InkWell(
      onTap: () {
        // Select item and sync sidebar
        menuProvider.selectChildItemWithSidebarSync(leafItem);
        widget.onItemSelected?.call();
        
        // Clear search after selection
        _searchController.clear();
        setState(() {
          _searchQuery = '';
        });
      },
      borderRadius: BorderRadius.circular(4),
      hoverColor: const Color(0xFFE3F2FD),
      splashColor: const Color(0xFFBBDEFB),
      child: Container(
        height: widget.isMobile ? 32 : 36,
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isMobile ? 12 : 16,
          vertical: widget.isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: menuProvider.isChildItemSelected(leafItem)
            ? const Color(0xFF2196F3).withValues(alpha: 0.2)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Document icon
            Icon(
              Icons.work_outline,
              size: widget.isMobile ? 14 : 16,
              color: menuProvider.isChildItemSelected(leafItem)
                ? const Color(0xFF1976D2)
                : const Color(0xFF607D8B),
            ),
            SizedBox(width: widget.isMobile ? 8 : 12),
            
            // Item title
            Expanded(
              child: Text(
                leafItem,
                style: TextStyle(
                  fontSize: widget.isMobile ? 13 : 14,
                  fontWeight: FontWeight.normal,
                  color: menuProvider.isChildItemSelected(leafItem)
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