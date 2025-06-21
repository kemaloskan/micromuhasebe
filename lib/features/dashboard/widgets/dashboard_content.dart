import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_menu_provider.dart';
import '../providers/tab_provider.dart';
import '../screens/dashboard_screen_new.dart';
import 'tab_content_widget.dart';

class DashboardContent extends StatelessWidget {
  final ScreenType screenType;
  
  const DashboardContent({
    super.key,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Consumer<DashboardMenuProvider>(
        builder: (context, menuProvider, child) {
          return _buildModuleContent(menuProvider);
        },
      ),
    );
  }

  Widget _buildModuleContent(DashboardMenuProvider menuProvider) {
    final selectedItem = menuProvider.getSelectedMenuItem();
    final selectedSubItem = menuProvider.getSelectedSubItem();
    
    return Padding(
      padding: EdgeInsets.all(_getPadding()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar ekle
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Panel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: _getSpacing()),
          // Horizontal Sub Menu List
          if (selectedItem?.subItems != null)
            _buildHorizontalSubMenu(selectedItem!, menuProvider),

          SizedBox(height: _getSpacing()),

          // Main Content Area
          if (selectedSubItem != null)
            Expanded(
              child: _buildMainContentArea(selectedSubItem, menuProvider),
            )
          else
            Expanded(
              child: _buildEmptyState(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app_outlined,
              size: screenType == ScreenType.mobile ? 48 : 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: screenType == ScreenType.mobile ? 12 : 16),
            Text(
              'Bir işlem kategorisi seçin',
              style: TextStyle(
                fontSize: screenType == ScreenType.mobile ? 16 : 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: screenType == ScreenType.mobile ? 6 : 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Yukarıdaki kategorilerden birini seçerek başlayın',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenType == ScreenType.mobile ? 12 : 14,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getPadding() {
    switch (screenType) {
      case ScreenType.mobile:
        return 16;
      case ScreenType.tablet:
        return 20;
      case ScreenType.desktop:
        return 24;
    }
  }

  double _getSpacing() {
    switch (screenType) {
      case ScreenType.mobile:
        return 16;
      case ScreenType.tablet:
        return 20;
      case ScreenType.desktop:
        return 24;
    }
  }

  Widget _buildBreadcrumb(DashboardMenuProvider menuProvider) {
    return Row(
      children: [
        Flexible(
          child: Text(
            menuProvider.selectedModule,
            style: TextStyle(
              fontSize: screenType == ScreenType.mobile ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (menuProvider.expandedSubItem != null) ...[
          SizedBox(width: screenType == ScreenType.mobile ? 8 : 12),
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
            size: screenType == ScreenType.mobile ? 20 : 24,
          ),
          SizedBox(width: screenType == ScreenType.mobile ? 8 : 12),
          Flexible(
            child: Text(
              menuProvider.expandedSubItem!,
              style: TextStyle(
                fontSize: screenType == ScreenType.mobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF696CFF),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHorizontalSubMenu(dynamic selectedItem, DashboardMenuProvider menuProvider) {
    return SizedBox(
      height: screenType == ScreenType.mobile ? 100 : 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: selectedItem.subItems!.length,
        separatorBuilder: (context, index) => SizedBox(
          width: screenType == ScreenType.mobile ? 12 : 16,
        ),
        itemBuilder: (context, index) {
          final subItem = selectedItem.subItems![index];
          final isSelected = menuProvider.isSubItemExpanded(subItem.title);
          
          return _buildSubMenuCard(subItem, isSelected, menuProvider);
        },
      ),
    );
  }

  Widget _buildSubMenuCard(dynamic subItem, bool isSelected, DashboardMenuProvider menuProvider) {
    final cardWidth = screenType == ScreenType.mobile ? 120.0 : 140.0;
    final iconSize = screenType == ScreenType.mobile ? 20.0 : 22.0;
    final fontSize = screenType == ScreenType.mobile ? 12.0 : 14.0;
    
    return InkWell(
      onTap: () => menuProvider.toggleSubItem(subItem.title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.all(screenType == ScreenType.mobile ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7E7FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? const Color(0xFF696CFF).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              subItem.icon,
              size: iconSize,
              color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade600,
            ),
            SizedBox(height: screenType == ScreenType.mobile ? 8 : 12),
            Text(
              subItem.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContentArea(dynamic selectedSubItem, DashboardMenuProvider menuProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Header
          Container(
            padding: EdgeInsets.all(screenType == ScreenType.mobile ? 12 : 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(
                  selectedSubItem.icon,
                  color: const Color(0xFF696CFF),
                  size: screenType == ScreenType.mobile ? 20 : 24,
                ),
                SizedBox(width: screenType == ScreenType.mobile ? 8 : 12),
                Expanded(
                  child: Text(
                    selectedSubItem.title,
                    style: TextStyle(
                      fontSize: screenType == ScreenType.mobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF696CFF),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // Content List
          Expanded(
            child: _buildContentGrid(selectedSubItem, menuProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildContentGrid(dynamic selectedSubItem, DashboardMenuProvider menuProvider) {
    // Kategoriler halinde organize et
    Map<String, List<String>> categorizedItems = {};
    
    // Direct children'ı "İşlemler" kategorisine ekle
    if (selectedSubItem.children != null) {
      categorizedItems['İşlemler'] = List.from(selectedSubItem.children!);
    }
    
    // Sub items'ların children'larını kategorilere ekle
    if (selectedSubItem.subItems != null) {
      for (var subItem in selectedSubItem.subItems!) {
        if (subItem.children != null) {
          categorizedItems[subItem.title] = List.from(subItem.children!);
        }
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid settings
        int crossAxisCount;
        double aspectRatio;
        double gridSpacing;
        double contentPadding;
        
        switch (screenType) {
          case ScreenType.mobile:
            // Mobile breakpoints
            if (constraints.maxWidth > 500) {
              crossAxisCount = 3;
              aspectRatio = 1.1;
            } else if (constraints.maxWidth > 350) {
              crossAxisCount = 2;
              aspectRatio = 1.0;
            } else {
              crossAxisCount = 2;
              aspectRatio = 0.9;
            }
            gridSpacing = 8;
            contentPadding = 12;
            break;
            
          case ScreenType.tablet:
            // Tablet breakpoints
            if (constraints.maxWidth > 900) {
              crossAxisCount = 6;
              aspectRatio = 1.2;
            } else if (constraints.maxWidth > 700) {
              crossAxisCount = 5;
              aspectRatio = 1.1;
            } else {
              crossAxisCount = 4;
              aspectRatio = 1.0;
            }
            gridSpacing = 10;
            contentPadding = 16;
            break;
            
          case ScreenType.desktop:
            // Desktop breakpoints
            if (constraints.maxWidth > 1400) {
              crossAxisCount = 9;
              aspectRatio = 1.3;
            } else if (constraints.maxWidth > 1100) {
              crossAxisCount = 7;
              aspectRatio = 1.4;
            } else if (constraints.maxWidth > 800) {
              crossAxisCount = 5;
              aspectRatio = 1.5;
            } else {
              crossAxisCount = 4;
              aspectRatio = 1.6;
            }
            gridSpacing = 6;
            contentPadding = 12;
            break;
        }

        return Padding(
          padding: EdgeInsets.all(contentPadding),
          child: ListView(
            children: categorizedItems.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori başlığı
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenType == ScreenType.mobile ? 12 : 8,
                      top: screenType == ScreenType.mobile ? 8 : 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: screenType == ScreenType.mobile ? 18 : 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF696CFF),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: screenType == ScreenType.mobile ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF696CFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenType == ScreenType.mobile ? 6 : 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF696CFF).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${entry.value.length}',
                            style: TextStyle(
                              fontSize: screenType == ScreenType.mobile ? 10 : 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF696CFF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Grid öğeleri
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: gridSpacing,
                      mainAxisSpacing: gridSpacing,
                    ),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final item = entry.value[index];
                      final isSelected = menuProvider.isChildItemSelected(item);
                      
                      return _buildGridItem(
                        title: item,
                        icon: _getIconForItem(item),
                        isSelected: isSelected,
                        onTap: () => _handleGridItemTap(context, item, menuProvider),
                      );
                    },
                  ),
                  
                  SizedBox(height: screenType == ScreenType.mobile ? 16 : 12),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildGridItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Responsive sizes
    double padding;
    double iconSize;
    double fontSize;
    double borderRadius;
    
    switch (screenType) {
      case ScreenType.mobile:
        padding = 8;
        iconSize = 24;
        fontSize = 12;
        borderRadius = 8;
        break;
      case ScreenType.tablet:
        padding = 6;
        iconSize = 26;
        fontSize = 11;
        borderRadius = 6;
        break;
      case ScreenType.desktop:
        padding = 6;
        iconSize = 28;
        fontSize = 11;
        borderRadius = 6;
        break;
    }
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7E7FF) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? const Color(0xFF696CFF).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isSelected ? 6 : 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon üstte
            Icon(
              icon,
              size: iconSize,
              color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade600,
            ),
            SizedBox(height: screenType == ScreenType.mobile ? 6 : 8),
            // Text altta
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForItem(String itemName) {
    // İtem adına göre uygun icon döndür
    final Map<String, IconData> iconMap = {
      // Stok işlemleri
      'Stok Giriş Fişi': Icons.input_outlined,
      'Stok Çıkış Fişi': Icons.output_outlined,
      'Sayım Fişi': Icons.inventory_outlined,
      'Depo Transfer': Icons.transfer_within_a_station_outlined,
      
      // Stok tanımları
      'Stok Kartları': Icons.badge_outlined,
      'Hızlı Stok Tanımı': Icons.speed_outlined,
      'Hizmet Tanımları': Icons.room_service_outlined,
      'Paket Tanımları': Icons.inventory_2_outlined,
      'Stok Birim Tanımları': Icons.straighten_outlined,
      'Fiyat Tanımları': Icons.local_offer_outlined,
      'Depo Tanımları': Icons.warehouse_outlined,
      'Depo Raf Tanımları': Icons.view_module_outlined,
      
      // Kategoriler ve gruplar
      'Stok Grup Tanımları': Icons.group_work_outlined,
      'Stok Kategori Tanımları': Icons.category_outlined,
      'Hizmet Grup Tanımları': Icons.groups_outlined,
      
      // Özellikler
      'E-Ticaret Özellik Tanımları': Icons.shopping_cart_outlined,
      'Stok Ek Özellik Tanımları': Icons.add_circle_outline,
      'Marka/Model Tanımları': Icons.branding_watermark_outlined,
      'Renk Tanımları': Icons.palette_outlined,
      'Beden Tanımları': Icons.straighten_outlined,
      
      // Raporlar
      'Stok Listesi': Icons.list_alt_outlined,
      'Stok Hareket Raporu': Icons.timeline_outlined,
      'Envanter Raporu': Icons.assessment_outlined,
      'Maliyet Raporu': Icons.monetization_on_outlined,
      'Kar/Zarar Analizi': Icons.analytics_outlined,
      
      // Satış
      'Satış Faturası': Icons.receipt_long_outlined,
      'İade Faturası': Icons.assignment_return_outlined,
      'Proforma Fatura': Icons.description_outlined,
      'Satış Siparişi': Icons.shopping_bag_outlined,
      'Satış Teklifi': Icons.request_quote_outlined,
      
      // Satın alma
      'Alış Faturası': Icons.receipt_outlined,
      'Satınalma Siparişi': Icons.shopping_cart_checkout_outlined,
      'Teklif Talebi': Icons.mail_outline,
      'Tedarikçi Teklifi': Icons.assignment_outlined,
      'Sipariş Onayı': Icons.check_circle_outline,
      'Mal Kabul': Icons.inventory_outlined,
      'Masraf Faturası': Icons.payment_outlined,
      'İthalat İşlemleri': Icons.public_outlined,
      'Kalite Kontrol': Icons.verified_outlined,
      
      // Tedarikçi
      'Tedarikçi Kartları': Icons.business_outlined,
      'Masraf Kartları': Icons.credit_card_outlined,
      'Alış Fiyat Listeleri': Icons.price_check_outlined,
      'Tedarikçi Grupları': Icons.corporate_fare_outlined,
      'Tedarikçi Değerlendirme': Icons.star_outline,
      'Kalite Standartları': Icons.verified_user_outlined,
      
      // Finans
      'Tahsilat Fişi': Icons.attach_money_outlined,
      'Ödeme Fişi': Icons.payment_outlined,
      'Virman Fişi': Icons.swap_horiz_outlined,
      'Mahsup Fişi': Icons.account_balance_outlined,
      'Çek/Senet İşlemleri': Icons.note_outlined,
      'Banka İşlemleri': Icons.account_balance_outlined,
      'Kredi Kartı İşlemleri': Icons.credit_card_outlined,
      'Kasa Tanımları': Icons.savings_outlined,
      'Banka Hesapları': Icons.account_balance_wallet_outlined,
    };
    
    return iconMap[itemName] ?? Icons.article_outlined;
  }

  void _handleGridItemTap(BuildContext context, String item, DashboardMenuProvider menuProvider) {
    // Sidebar'ı sync et
    menuProvider.selectChildItemWithSidebarSync(item);
    
    // Tab provider'ı al ve yeni tab aç
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    final icon = _getIconForItem(item);
    
    tabProvider.openTab(
      title: item,
      icon: icon,
      content: TabContentWidget(
        title: item,
        icon: icon,
        screenType: screenType,
      ),
    );
  }
} 