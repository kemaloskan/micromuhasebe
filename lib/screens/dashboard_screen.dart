import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/app_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedModule = 'Stok Yönetimi';
  String? _selectedSubItem;
  String? _selectedChildItem;
  String? _lastSelectedChildItem; // Son seçili child item'ı hatırlamak için
  
  // Expanded durumlar için state'ler
  String _expandedModule = 'Stok Yönetimi';
  String? _expandedSubItem;
  String? _expandedChildItem;
  Set<String> _expandedGrandChildren = {}; // Grand children için set kullanacağım

  final List<MenuItem> _menuItems = [
    MenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
    ),
    MenuItem(
      title: 'Stok Yönetimi',
      icon: Icons.inventory,
      subItems: [
        SubMenuItem(
          title: 'İşlemler',
          icon: Icons.sync_alt,
          children: [
            'Stok Giriş Fişi',
            'Stok Çıkış Fişi',
            'Sayım Fişi',
            'Depo Transfer',
          ],
        ),
        SubMenuItem(
          title: 'Tanımlar',
          icon: Icons.settings,
          subItems: [
            SubMenuItem(
              title: 'Stok Tanımları',
              icon: Icons.inventory_2,
              children: [
                'Stok Kartları',
                'Hızlı Stok Tanımı',
                'Hizmet Tanımları',
                'Paket Tanımları'
              ],
            ),
            SubMenuItem(
              title: 'Depo',
              icon: Icons.warehouse,
              children: [
                'Stok Birim Tanımları',
                'Fiyat Tanımları',
                'Depo Tanımları',
                'Depo Raf Tanımları'
              ],
            ),
            SubMenuItem(
              title: 'Özellikler',
              icon: Icons.category,
              children: [
                'E-Ticaret Özellik Tanımları',
                'Stok Ek Özellik Tanımları',
                'Marka/Model Tanımları',
                'Renk Tanımları',
                'Beden Tanımları'
              ],
            ),
            SubMenuItem(
              title: 'Gruplar',
              icon: Icons.folder,
              children: [
                'Stok Grup Tanımları',
                'Stok Kategori Tanımları',
                'Hizmet Grup Tanımları'
              ],
            ),
          ],
        ),
        SubMenuItem(
          title: 'Raporlar',
          icon: Icons.assessment,
          children: [
            'Stok Listesi',
            'Stok Hareket Raporu',
            'Envanter Raporu',
            'Maliyet Raporu',
            'Kar/Zarar Analizi',
          ],
        ),
      ],
    ),
    MenuItem(
      title: 'Satış Yönetimi',
      icon: Icons.point_of_sale,
      subItems: [
        SubMenuItem(
          title: 'İşlemler',
          icon: Icons.receipt,
          children: [
            'Satış Faturası',
            'İade Faturası',
            'Proforma Fatura',
            'Satış Siparişi',
            'Satış Teklifi',
            'Toplu Faturalama',
            'Dövizli Satış',
            'E-Fatura',
            'E-Arşiv',
            'Sevk İrsaliyesi'
          ],
        ),
        SubMenuItem(
          title: 'Tanımlar',
          icon: Icons.settings,
          children: [
            'Müşteri Kartları',
            'Fiyat Listeleri',
            'Kampanya Tanımları',
            'Satış Elemanları',
            'Müşteri Grupları',
            'Teminat Tanımları',
            'Ödeme Planları',
            'Prim Tanımları',
            'Bölge Tanımları',
            'Rota Tanımları'
          ],
        ),
        SubMenuItem(
          title: 'Raporlar',
          icon: Icons.assessment,
          children: [
            'Satış Raporu',
            'Müşteri Bazlı Satış',
            'Ürün Bazlı Satış',
            'Tahsilat Raporu',
            'Satış Trend Analizi',
            'Satış Karlılık',
            'Satış Performans',
            'Hedef Gerçekleşme',
            'Müşteri Risk',
            'Vade Analizi'
          ],
        ),
      ],
    ),
    MenuItem(
      title: 'Satın Alma Yönetimi',
      icon: Icons.shopping_cart,
      subItems: [
        SubMenuItem(
          title: 'İşlemler',
          icon: Icons.receipt,
          children: [
            'Alış Faturası',
            'İade Faturası',
            'Satınalma Siparişi',
            'Teklif Talebi',
            'Tedarikçi Teklifi',
            'Sipariş Onayı',
            'Mal Kabul',
            'Masraf Faturası',
            'İthalat İşlemleri',
            'Kalite Kontrol'
          ],
        ),
        SubMenuItem(
          title: 'Tanımlar',
          icon: Icons.settings,
          children: [
            'Tedarikçi Kartları',
            'Masraf Kartları',
            'Alış Fiyat Listeleri',
            'Tedarikçi Grupları',
            'Tedarikçi Değerlendirme',
            'Kalite Standartları',
            'Sipariş Şablonları',
            'Onay Süreçleri',
            'Bütçe Tanımları',
            'Maliyet Merkezleri'
          ],
        ),
        SubMenuItem(
          title: 'Raporlar',
          icon: Icons.assessment,
          children: [
            'Alış Raporu',
            'Tedarikçi Bazlı Alış',
            'Ürün Bazlı Alış',
            'Ödeme Raporu',
            'Tedarikçi Performans',
            'Sipariş Takip',
            'Bütçe Analizi',
            'Maliyet Analizi',
            'Kalite Raporu',
            'Teslimat Performans'
          ],
        ),
      ],
    ),
    MenuItem(
      title: 'Finans Yönetimi',
      icon: Icons.account_balance,
      subItems: [
        SubMenuItem(
          title: 'İşlemler',
          icon: Icons.payments,
          children: [
            'Tahsilat Fişi',
            'Ödeme Fişi',
            'Virman Fişi',
            'Mahsup Fişi',
            'Çek/Senet İşlemleri',
            'Banka İşlemleri',
            'Kredi Kartı İşlemleri',
            'Taksit İşlemleri',
            'Döviz İşlemleri',
            'E-Mutabakat'
          ],
        ),
        SubMenuItem(
          title: 'Tanımlar',
          icon: Icons.settings,
          children: [
            'Kasa Tanımları',
            'Banka Hesapları',
            'Çek/Senet',
            'Kredi Kartları',
            'Taksit Planları',
            'Döviz Kurları',
            'Ödeme Türleri',
            'Finans Parametreleri',
            'Hesap Planı',
            'Masraf Merkezleri'
          ],
        ),
        SubMenuItem(
          title: 'Raporlar',
          icon: Icons.assessment,
          children: [
            'Kasa Raporu',
            'Banka Raporu',
            'Borç/Alacak',
            'Vade Analizi',
            'Nakit Akış',
            'Çek/Senet Portföy',
            'Risk Raporu',
            'Kredi Kartı Ekstresi',
            'Mutabakat Raporu',
            'Finansal Tablolar'
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Row(
              children: [
                _buildMainMenu(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Webfinans ERP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF696CFF),
            ),
          ),
          const Spacer(),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Row(
                children: [
                  // User info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        authProvider.userName ?? 'Kullanıcı',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF566A7F),
                        ),
                      ),
                      Text(
                        authProvider.getRoleDisplayName(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA5A3AE),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  
                  // User avatar and menu
                  PopupMenuButton<String>(
                    icon: CircleAvatar(
                      backgroundColor: const Color(0xFF696CFF),
                      radius: 20,
                      child: Text(
                        authProvider.getUserInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'profile',
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: 12),
                            Text('Profil (${authProvider.userEmail})'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined),
                            SizedBox(width: 12),
                            Text('Ayarlar'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Çıkış', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'logout') {
                        await _handleLogout();
                      } else if (value == 'profile') {
                        // Handle profile action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil sayfası henüz mevcut değil')),
                        );
                      } else if (value == 'settings') {
                        // Handle settings action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ayarlar sayfası henüz mevcut değil')),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Oturumunuzu sonlandırmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Başarıyla çıkış yapıldı'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Widget _buildMainMenu() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık kısmı
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Text(
              'ERP Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Ana Modüller kategorisi
                _buildCategoryHeader('ANA MODÜLLER'),
                const SizedBox(height: 8),
                
                _buildMenuItem(
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  isSelected: _selectedModule == 'Dashboard',
                  onTap: () => setState(() {
                    _selectedModule = 'Dashboard';
                    _selectedSubItem = null;
                    _selectedChildItem = null;
                    _lastSelectedChildItem = null;
                    // Dashboard'a tıklandığında expanded durumları da temizle
                    _expandedModule = '';
                    _expandedSubItem = null;
                    _expandedChildItem = null;
                  }),
                ),
                
                _buildMenuItem(
                  title: 'Stok Yönetimi',
                  icon: Icons.inventory_2_outlined,
                  isSelected: _selectedModule == 'Stok Yönetimi',
                  hasSubItems: true,
                  isExpanded: _expandedModule == 'Stok Yönetimi',
                  onTap: () => setState(() {
                    if (_expandedModule == 'Stok Yönetimi') {
                      _expandedModule = '';
                      _expandedSubItem = null;
                      // Menü kapanırken seçimleri koruma
                    } else {
                      // Ana modül değişiminde TÜM alt seçimleri temizle
                      _selectedSubItem = null;
                      _selectedChildItem = null;
                      _lastSelectedChildItem = null;
                      _expandedSubItem = null;
                      _expandedChildItem = null;
                      
                      _expandedModule = 'Stok Yönetimi';
                      _selectedModule = 'Stok Yönetimi';
                    }
                  }),
                  subItems: _menuItems.firstWhere((item) => item.title == 'Stok Yönetimi').subItems,
                ),
                
                _buildMenuItem(
                  title: 'Satış Yönetimi',
                  icon: Icons.point_of_sale_outlined,
                  isSelected: _selectedModule == 'Satış Yönetimi',
                  hasSubItems: true,
                  isExpanded: _expandedModule == 'Satış Yönetimi',
                  onTap: () => setState(() {
                    if (_expandedModule == 'Satış Yönetimi') {
                      _expandedModule = '';
                      _expandedSubItem = null;
                      // Menü kapanırken seçimleri koruma
                    } else {
                      // Ana modül değişiminde TÜM alt seçimleri temizle
                      _selectedSubItem = null;
                      _selectedChildItem = null;
                      _lastSelectedChildItem = null;
                      _expandedSubItem = null;
                      _expandedChildItem = null;
                      
                      _expandedModule = 'Satış Yönetimi';
                      _selectedModule = 'Satış Yönetimi';
                    }
                  }),
                  subItems: _menuItems.firstWhere((item) => item.title == 'Satış Yönetimi').subItems,
                ),
                
                _buildMenuItem(
                  title: 'Satın Alma Yönetimi',
                  icon: Icons.shopping_cart_outlined,
                  isSelected: _selectedModule == 'Satın Alma Yönetimi',
                  hasSubItems: true,
                  isExpanded: _expandedModule == 'Satın Alma Yönetimi',
                  onTap: () => setState(() {
                    if (_expandedModule == 'Satın Alma Yönetimi') {
                      _expandedModule = '';
                      _expandedSubItem = null;
                      // Menü kapanırken seçimleri koruma
                    } else {
                      // Ana modül değişiminde TÜM alt seçimleri temizle
                      _selectedSubItem = null;
                      _selectedChildItem = null;
                      _lastSelectedChildItem = null;
                      _expandedSubItem = null;
                      _expandedChildItem = null;
                      
                      _expandedModule = 'Satın Alma Yönetimi';
                      _selectedModule = 'Satın Alma Yönetimi';
                    }
                  }),
                  subItems: _menuItems.firstWhere((item) => item.title == 'Satın Alma Yönetimi').subItems,
                ),
                
                const SizedBox(height: 32),
                
                // Finans kategorisi
                _buildCategoryHeader('FİNANS & MUHASEBE'),
                const SizedBox(height: 8),
                
                _buildMenuItem(
                  title: 'Finans Yönetimi',
                  icon: Icons.account_balance_outlined,
                  isSelected: _selectedModule == 'Finans Yönetimi',
                  hasSubItems: true,
                  isExpanded: _expandedModule == 'Finans Yönetimi',
                  onTap: () => setState(() {
                    if (_expandedModule == 'Finans Yönetimi') {
                      _expandedModule = '';
                      _expandedSubItem = null;
                      // Menü kapanırken seçimleri koruma
                    } else {
                      // Ana modül değişiminde TÜM alt seçimleri temizle
                      _selectedSubItem = null;
                      _selectedChildItem = null;
                      _lastSelectedChildItem = null;
                      _expandedSubItem = null;
                      _expandedChildItem = null;
                      
                      _expandedModule = 'Finans Yönetimi';
                      _selectedModule = 'Finans Yönetimi';
                    }
                  }),
                  subItems: _menuItems.firstWhere((item) => item.title == 'Finans Yönetimi').subItems,
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade400,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    bool hasSubItems = false,
    bool isExpanded = false,
    List<SubMenuItem>? subItems,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected 
                ? (hasSubItems ? const Color(0xFFF8F9FA) : const Color(0xFFE7E7FF))
                : isExpanded 
                  ? const Color(0xFFF8F9FA)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade600,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade700,
                    ),
                  ),
                ),
                if (hasSubItems)
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 14,
                    color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade400,
                  ),
              ],
            ),
          ),
        ),
        
        // Alt menüler
        if (isExpanded && subItems != null)
          Column(
            children: subItems.map((subItem) {
              final isSubSelected = _selectedSubItem == subItem.title;
              final isSubExpanded = _expandedSubItem == subItem.title;
              return Column(
                children: [
                  _buildSubMenuItem(
                    title: subItem.title,
                    icon: subItem.icon,
                    isSelected: isSubSelected,
                    hasChildren: subItem.children != null || subItem.subItems != null,
                    isExpanded: isSubExpanded,
                    onTap: () => setState(() {
                      // Toggle logic ile basit temizleme
                      if (_expandedSubItem == subItem.title) {
                        _expandedSubItem = null;
                        _expandedChildItem = null;
                      } else {
                        // Alt menü değişiminde child seçimlerini temizle
                        _selectedChildItem = null;
                        _lastSelectedChildItem = null;
                        _expandedChildItem = null;
                        
                        _selectedSubItem = subItem.title;
                        _expandedSubItem = subItem.title;
                      }
                    }),
                  ),
                  
                  // Alt alt menüler
                  if (isSubExpanded && subItem.children != null)
                    Column(
                      children: subItem.children!.map((child) {
                        final isChildSelected = _selectedChildItem == child;
                        return _buildLeafMenuItem(
                          title: child,
                          isSelected: isChildSelected,
                          leftPadding: 36.0,
                          hasChildren: false,
                          isExpanded: _expandedGrandChildren.contains(child),
                          onTap: () => setState(() {
                            _selectedChildItem = child;
                            _lastSelectedChildItem = child;
                          }),
                        );
                      }).toList(),
                    ),
                    
                  if (isSubExpanded && subItem.subItems != null)
                    Column(
                      children: subItem.subItems!.map((childSubItem) {
                        final isChildSubSelected = _selectedChildItem == childSubItem.title;
                        final hasSelectedChild = childSubItem.children?.any((child) => _selectedChildItem == child) ?? false;
                        final isChildSubExpanded = _expandedChildItem == childSubItem.title || hasSelectedChild;
                        return Column(
                          children: [
                            _buildLeafMenuItem(
                              title: childSubItem.title,
                              isSelected: isChildSubSelected,
                              leftPadding: 36.0,
                              hasChildren: childSubItem.children != null,
                              isExpanded: isChildSubExpanded,
                              onTap: () => setState(() {
                                // Child sub item toggle logic
                                if (childSubItem.children != null && childSubItem.children!.isNotEmpty) {
                                  // Eğer children varsa toggle yap
                                  if (_expandedChildItem == childSubItem.title) {
                                    _expandedChildItem = null;
                                  } else {
                                    _expandedChildItem = childSubItem.title;
                                    _selectedChildItem = childSubItem.title;
                                    _lastSelectedChildItem = childSubItem.title;
                                  }
                                } else {
                                  // Children yoksa sadece seç
                                  _selectedChildItem = childSubItem.title;
                                  _lastSelectedChildItem = childSubItem.title;
                                }
                              }),
                            ),
                            if (isChildSubExpanded && childSubItem.children != null)
                              Column(
                                children: childSubItem.children!.map((grandChild) {
                                  final isGrandChildSelected = _selectedChildItem == grandChild;
                                  return _buildLeafMenuItem(
                                    title: grandChild,
                                    isSelected: isGrandChildSelected,
                                    leftPadding: 48.0,
                                    isSmall: true,
                                    onTap: () => setState(() {
                                      _selectedChildItem = grandChild;
                                      _lastSelectedChildItem = grandChild;
                                    }),
                                  );
                                }).toList(),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required bool hasChildren,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.only(left: 24, right: 12),
        decoration: BoxDecoration(
          color: isSelected
            ? (hasChildren ? const Color(0xFFEDEEF0) : const Color(0xFFE7E7FF))
            : isExpanded
              ? const Color(0xFFF8F9FA)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade600,
                ),
              ),
            ),
            if (hasChildren)
              Icon(
                isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                size: 14,
                color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeafMenuItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isSmall = false,
    double leftPadding = 0,
    bool hasChildren = false,
    bool isExpanded = false,
  }) {
    // Check both _selectedChildItem and _lastSelectedChildItem for isSelected
    final actuallySelected = isSelected || (_selectedChildItem == title) || (_lastSelectedChildItem == title);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: isSmall ? 32 : 36,
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.only(left: leftPadding, right: 12),
        decoration: BoxDecoration(
          color: actuallySelected 
            ? (hasChildren ? const Color(0xFFEDEEF0) : const Color(0xFFE7E7FF))
            : isExpanded
              ? const Color(0xFFF8F9FA)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: actuallySelected ? const Color(0xFF696CFF) : Colors.grey.shade400,
                  width: 1.5,
                ),
                shape: BoxShape.circle,
                boxShadow: actuallySelected ? [
                  BoxShadow(
                    color: const Color(0xFF696CFF).withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: actuallySelected ? const Color(0xFF696CFF) : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isSmall ? 12 : 13,
                  fontWeight: actuallySelected ? FontWeight.w500 : FontWeight.w400,
                  color: actuallySelected ? const Color(0xFF696CFF) : Colors.grey.shade600,
                ),
              ),
            ),
            if (hasChildren)
              Icon(
                isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                size: 14,
                color: actuallySelected ? const Color(0xFF696CFF) : Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    // Dashboard seçili ise özel dashboard görünümü göster
    if (_selectedModule == 'Dashboard') {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard_outlined,
                size: 64,
                color: Color(0xFF696CFF),
              ),
              SizedBox(height: 16),
              Text(
                'Webfinans ERP Dashboard',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF696CFF),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Bir modül seçin',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final selectedItem = _menuItems.firstWhere(
      (item) => item.title == _selectedModule,
      orElse: () => _menuItems.first, // Fallback olarak ilk item'ı döndür
    );
    
    // Seçili alt menüyü bul
    final selectedSubItem = selectedItem.subItems?.firstWhere(
      (subItem) => subItem.title == _selectedSubItem,
      orElse: () => selectedItem.subItems!.first,
    );
    
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık kısmı
          Row(
            children: [
              Text(
                selectedItem.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_selectedSubItem != null) ...[
                const SizedBox(width: 12),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
                const SizedBox(width: 12),
                Text(
                  _selectedSubItem!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF696CFF),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // Yatay alt menü listesi
          if (selectedItem.subItems != null)
            Container(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: selectedItem.subItems!.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final subItem = selectedItem.subItems![index];
                  final isSelected = _selectedSubItem == subItem.title;
                  return InkWell(
                    onTap: () => setState(() {
                      // Toggle logic ile basit temizleme
                      if (_expandedSubItem == subItem.title) {
                        _expandedSubItem = null;
                        _expandedChildItem = null;
                      } else {
                        // Alt menü değişiminde child seçimlerini temizle
                        _selectedChildItem = null;
                        _lastSelectedChildItem = null;
                        _expandedChildItem = null;
                        
                        _selectedSubItem = subItem.title;
                        _expandedSubItem = subItem.title;
                      }
                    }),
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE7E7FF) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            subItem.icon,
                            size: 32,
                            color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade700,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subItem.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 24),

          // Alt menü içeriği
          if (selectedSubItem != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alt menü başlığı
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Row(
                        children: [
                          Icon(selectedSubItem.icon, color: const Color(0xFF696CFF)),
                          const SizedBox(width: 12),
                          Text(
                            selectedSubItem.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF696CFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sadece en alt seviye öğeler - liste formatında
                    Expanded(
                      child: _buildSimpleItemList(selectedSubItem),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleItemList(SubMenuItem selectedSubItem) {
    List<Widget> itemWidgets = [];
    
    // İlk seviye - direkt children varsa
    if (selectedSubItem.children != null) {
      itemWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'İşlemler',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      );
      
      for (var child in selectedSubItem.children!) {
        final isSelected = (_selectedChildItem == child) || (_lastSelectedChildItem == child);
        itemWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: InkWell(
              onTap: () => setState(() {
                _selectedChildItem = child;
                _lastSelectedChildItem = child;
              }),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE7E7FF) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        child,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade800,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

      if (selectedSubItem.subItems != null) {
        itemWidgets.add(const SizedBox(height: 16));
      }
    }
    
    // İkinci seviye - subItems varsa
    if (selectedSubItem.subItems != null) {
      for (var subItem in selectedSubItem.subItems!) {
        // SubItem başlığı
        itemWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Text(
              subItem.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        );
        
        // SubItem'ın children'ları
        if (subItem.children != null) {
          for (var child in subItem.children!) {
            final isSelected = (_selectedChildItem == child) || (_lastSelectedChildItem == child);
            itemWidgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 16),
                child: InkWell(
                  onTap: () => setState(() {
                    _selectedChildItem = child;
                    _lastSelectedChildItem = child;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE7E7FF) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 6,
                          color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade400,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            child,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? const Color(0xFF696CFF) : Colors.grey.shade800,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
        }
      }
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: itemWidgets,
    );
  }
}

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