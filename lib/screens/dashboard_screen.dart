import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedModule = 'Stok Yönetimi';
  String? _selectedSubItem;

  final List<MenuItem> _menuItems = [
    MenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
    ),
    MenuItem(
      title: 'Stok Yönetimi',
      icon: Icons.inventory,
      subItems: [
        SubMenuItem(title: 'Stok Kartları', icon: Icons.article),
        SubMenuItem(title: 'Stok Hareketleri', icon: Icons.sync_alt),
        SubMenuItem(title: 'Stok Sayım', icon: Icons.calculate),
        SubMenuItem(title: 'Depo Yönetimi', icon: Icons.warehouse),
        SubMenuItem(title: 'Stok Raporları', icon: Icons.assessment),
      ],
    ),
    MenuItem(
      title: 'Satış Yönetimi',
      icon: Icons.point_of_sale,
      subItems: [
        SubMenuItem(title: 'Satış Faturası', icon: Icons.receipt),
        SubMenuItem(title: 'Satış İade', icon: Icons.assignment_return),
        SubMenuItem(title: 'Müşteriler', icon: Icons.people),
        SubMenuItem(title: 'Satış Raporları', icon: Icons.assessment),
      ],
    ),
    MenuItem(
      title: 'Satın Alma Yönetimi',
      icon: Icons.shopping_cart,
      subItems: [
        SubMenuItem(title: 'Satınalma Faturası', icon: Icons.receipt),
        SubMenuItem(title: 'Satınalma İade', icon: Icons.assignment_return),
        SubMenuItem(title: 'Tedarikçiler', icon: Icons.business),
        SubMenuItem(title: 'Satınalma Raporları', icon: Icons.assessment),
      ],
    ),
    MenuItem(
      title: 'Finans Yönetimi',
      icon: Icons.account_balance,
      subItems: [
        SubMenuItem(title: 'Kasa İşlemleri', icon: Icons.payments),
        SubMenuItem(title: 'Banka İşlemleri', icon: Icons.account_balance),
        SubMenuItem(title: 'Çek/Senet', icon: Icons.description),
        SubMenuItem(title: 'Finans Raporları', icon: Icons.assessment),
      ],
    ),
    MenuItem(
      title: 'Raporlar',
      icon: Icons.assessment,
      subItems: [
        SubMenuItem(title: 'Genel Raporlar', icon: Icons.bar_chart),
        SubMenuItem(title: 'Finansal Raporlar', icon: Icons.attach_money),
        SubMenuItem(title: 'Stok Raporları', icon: Icons.inventory),
        SubMenuItem(title: 'Satış Raporları', icon: Icons.point_of_sale),
      ],
    ),
    MenuItem(
      title: 'Ayarlar',
      icon: Icons.settings,
      subItems: [
        SubMenuItem(title: 'Kullanıcılar', icon: Icons.people),
        SubMenuItem(title: 'Şirket Bilgileri', icon: Icons.business),
        SubMenuItem(title: 'Parametreler', icon: Icons.tune),
        SubMenuItem(title: 'Yetkilendirme', icon: Icons.security),
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
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            'Webfinans ERP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Şirket: 2023 - TEST',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildMainMenu() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          final isSelected = _selectedModule == item.title;
          
          return Column(
            children: [
              InkWell(
                onTap: () => setState(() {
                  _selectedModule = item.title;
                  _selectedSubItem = null;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: isSelected ? Colors.blue : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.blue : Colors.grey.shade800,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (item.subItems != null)
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                    ],
                  ),
                ),
              ),
              if (isSelected && item.subItems != null)
                ...item.subItems!.map((subItem) => InkWell(
                  onTap: () => setState(() => _selectedSubItem = subItem.title),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: _selectedSubItem == subItem.title
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: _selectedSubItem == subItem.title
                              ? Colors.blue.shade300
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          subItem.icon,
                          size: 18,
                          color: _selectedSubItem == subItem.title
                              ? Colors.blue.shade700
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            subItem.title,
                            style: TextStyle(
                              fontSize: 13,
                              color: _selectedSubItem == subItem.title
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    final selectedItem = _menuItems.firstWhere((item) => item.title == _selectedModule);
    
    if (selectedItem.title == 'Dashboard') {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedItem.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          if (selectedItem.subItems != null) ...[
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: selectedItem.subItems!.map((subItem) => InkWell(
                  onTap: () => setState(() => _selectedSubItem = subItem.title),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedSubItem == subItem.title
                            ? Colors.blue
                            : Colors.grey.shade200,
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _selectedSubItem == subItem.title
                                ? Colors.blue.shade50
                                : Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            subItem.icon,
                            size: 32,
                            color: _selectedSubItem == subItem.title
                                ? Colors.blue
                                : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          subItem.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedSubItem == subItem.title
                                ? Colors.blue
                                : Colors.grey.shade800,
                            fontWeight: _selectedSubItem == subItem.title
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
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

  SubMenuItem({
    required this.title,
    required this.icon,
  });
} 