import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';
import '../providers/sidebar_provider.dart';

// Main Sidebar Widget
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1200;
    final isExpanded = isMobile ? true : context.watch<SidebarProvider>().isExpanded;
    final width = isExpanded ? 260 : 70;

    return Container(
      width: width.toDouble(),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildHeader(context, isExpanded),
          const SizedBox(height: 16),
          Expanded(child: _buildMenu(context, isExpanded)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isExpanded) {
    final sidebarProvider = context.watch<SidebarProvider>();
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: isExpanded ? 8 : 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Icon(Icons.ac_unit, color: Colors.white, size: 14),
          ),
          if (isExpanded) ...[
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'sneat',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ] else ...[
            const Spacer(),
          ],
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, bool isExpanded) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: isExpanded ? 8 : 4),
      itemCount: context.watch<MenuProvider>().menuItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final menuItem = context.watch<MenuProvider>().menuItems[index];
        return _buildMenuItem(context, menuItem, isExpanded);
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item, bool isExpanded) {
    switch (item.type) {
      case MenuItemType.header:
        return _buildHeaderItem(context, item.title, isExpanded);
      case MenuItemType.link:
        return _buildLinkItem(context, item, isExpanded);
      case MenuItemType.collapsible:
        return _buildCollapsibleItem(context, item, isExpanded);
    }
  }

  Widget _buildHeaderItem(BuildContext context, String title, bool isExpanded) {
    if (!isExpanded) return const Divider(height: 24);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, MenuItem item, bool isExpanded) {
    final provider = context.watch<MenuProvider>();
    final isSelected = provider.selectedItem == item.title;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Material(
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () {
            print('Tıklama: ${item.title}');
            provider.selectItem(item.title);
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: isExpanded ? 8 : 4),
            child: isExpanded
                ? Row(
                    children: [
                      Icon(item.icon, size: 18, color: _getIconColor(theme, isSelected)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _getIconColor(theme, isSelected),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Icon(item.icon, size: 18, color: _getIconColor(theme, isSelected)),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsibleItem(BuildContext context, MenuItem item, bool isExpanded) {
    final menuProvider = context.watch<MenuProvider>();
    final isModuleExpanded = menuProvider.isModuleExpanded(item.title);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: () {
                print('Collapsible tıklama: ${item.title}');
                menuProvider.toggleModule(item.title);
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: isExpanded ? 8 : 4),
                child: isExpanded
                    ? Row(
                        children: [
                          Icon(item.icon, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.8)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(item.icon, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.8)),
                      ),
              ),
            ),
          ),
        ),
        if (isExpanded && isModuleExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 2),
            child: Column(
              children: item.subItems!.map((subItem) => _buildSubItem(context, subItem)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSubItem(BuildContext context, SubMenuItem subItem) {
    final provider = context.watch<MenuProvider>();
    final isSelected = provider.selectedItem == subItem.title;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Material(
        color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () {
            print('Sub item tıklama: ${subItem.title}');
            provider.selectItem(subItem.title);
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    subItem.title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconColor(ThemeData theme, bool isSelected) {
    return isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface.withOpacity(0.8);
  }
} 