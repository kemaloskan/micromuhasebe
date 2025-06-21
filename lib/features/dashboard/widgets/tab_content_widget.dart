import 'package:flutter/material.dart';
import '../dashboard_screen_new.dart';

class TabContentWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final ScreenType screenType;
  
  const TabContentWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Content Header
          Container(
            padding: EdgeInsets.all(_getPadding()),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(_getIconPadding()),
                  decoration: BoxDecoration(
                    color: const Color(0xFF696CFF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF696CFF),
                    size: _getHeaderIconSize(),
                  ),
                ),
                SizedBox(width: _getSpacing()),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: _getHeaderFontSize(),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF696CFF),
                        ),
                      ),
                      SizedBox(height: _getSmallSpacing()),
                      Text(
                        _getSubtitle(),
                        style: TextStyle(
                          fontSize: _getSubtitleFontSize(),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action buttons in header for full-screen mode
                _buildHeaderActions(),
              ],
            ),
          ),
          
          // Main Content Area
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_getPadding()),
      child: Column(
        children: [
          // Quick Actions Section
          _buildQuickActionsSection(),
          
          SizedBox(height: _getSpacing() * 2),
          
          // Data Table Section
          Expanded(
            child: _buildDataTableSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final actions = _getQuickActions();
    
    return Container(
      padding: EdgeInsets.all(_getPadding()),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İşlemler',
            style: TextStyle(
              fontSize: _getSubheaderFontSize(),
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: _getSpacing()),
          
          // Action buttons in responsive grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              if (screenType == ScreenType.mobile) {
                crossAxisCount = constraints.maxWidth > 400 ? 3 : 2;
              } else if (screenType == ScreenType.tablet) {
                crossAxisCount = 4;
              } else {
                crossAxisCount = 6;
              }
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: _getSmallSpacing(),
                  mainAxisSpacing: _getSmallSpacing(),
                ),
                itemCount: actions.length,
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return _buildActionButton(
                    title: action['title'],
                    icon: action['icon'],
                    color: action['color'],
                    onTap: () => _handleActionTap(action['title']),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(_getSmallSpacing()),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: _getActionIconSize(),
                color: color,
              ),
              SizedBox(width: _getSmallSpacing()),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: _getActionFontSize(),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTableSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Table header
          Container(
            padding: EdgeInsets.all(_getPadding()),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Son Kayıtlar',
                  style: TextStyle(
                    fontSize: _getSubheaderFontSize(),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  '${_getSampleData().length} kayıt',
                  style: TextStyle(
                    fontSize: _getActionFontSize(),
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Table content
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(_getPadding()),
              itemCount: _getSampleData().length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                final item = _getSampleData()[index];
                return _buildDataRow(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _getSmallSpacing(),
        horizontal: _getSmallSpacing(),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF696CFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item['icon'],
              size: 20,
              color: const Color(0xFF696CFF),
            ),
          ),
          SizedBox(width: _getSpacing()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    fontSize: _getActionFontSize(),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                if (item['subtitle'] != null) ...[
                  SizedBox(height: 2),
                  Text(
                    item['subtitle'],
                    style: TextStyle(
                      fontSize: _getActionFontSize() - 1,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item['value'] != null)
            Text(
              item['value'],
              style: TextStyle(
                fontSize: _getActionFontSize(),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF696CFF),
              ),
            ),
        ],
      ),
    );
  }

  // Content specific methods
  String _getSubtitle() {
    final Map<String, String> subtitles = {
      'Stok Giriş Fişi': 'Depo stok giriş işlemlerini yönetin',
      'Stok Çıkış Fişi': 'Depo stok çıkış işlemlerini yönetin',
      'Satış Faturası': 'Satış faturası oluşturun ve yönetin',
      'Alış Faturası': 'Satın alma faturalarını işleyin',
      'Tedarikçi Kartları': 'Tedarikçi bilgilerini yönetin',
      'Stok Kartları': 'Ürün ve stok bilgilerini düzenleyin',
    };
    return subtitles[title] ?? '$title işlemlerini buradan yönetebilirsiniz';
  }

  List<Map<String, dynamic>> _getQuickActions() {
    final Map<String, List<Map<String, dynamic>>> actionMap = {
      'Stok Giriş Fişi': [
        {'title': 'Yeni Giriş', 'icon': Icons.add, 'color': Colors.green},
        {'title': 'Toplu Giriş', 'icon': Icons.upload, 'color': Colors.blue},
        {'title': 'Şablon İndir', 'icon': Icons.download, 'color': Colors.orange},
      ],
      'Stok Çıkış Fişi': [
        {'title': 'Yeni Çıkış', 'icon': Icons.remove, 'color': Colors.red},
        {'title': 'Toplu Çıkış', 'icon': Icons.file_upload, 'color': Colors.purple},
        {'title': 'Rapor Al', 'icon': Icons.summarize, 'color': Colors.teal},
      ],
      'Satış Faturası': [
        {'title': 'Yeni Fatura', 'icon': Icons.add, 'color': Colors.green},
        {'title': 'Taslak', 'icon': Icons.drafts, 'color': Colors.orange},
        {'title': 'Gönderilmiş', 'icon': Icons.send, 'color': Colors.blue},
        {'title': 'Ödendi', 'icon': Icons.paid, 'color': Colors.green},
      ],
    };
    
    return actionMap[title] ?? [
      {'title': 'Yeni Ekle', 'icon': Icons.add, 'color': Colors.green},
      {'title': 'Düzenle', 'icon': Icons.edit, 'color': Colors.blue},
      {'title': 'Rapor', 'icon': Icons.summarize, 'color': Colors.orange},
    ];
  }

  List<Map<String, dynamic>> _getSampleData() {
    return List.generate(10, (index) => {
      'icon': icon,
      'title': '$title ${index + 1}',
      'subtitle': 'Açıklama ${index + 1}',
      'value': '${(index + 1) * 100} TL',
    });
  }

  void _handleActionTap(String actionTitle) {
    // TODO: Implement action handling
    debugPrint('Action tapped: $actionTitle for $title');
  }

  // Responsive helpers
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
        return 12;
      case ScreenType.tablet:
        return 16;
      case ScreenType.desktop:
        return 20;
    }
  }

  double _getSmallSpacing() {
    switch (screenType) {
      case ScreenType.mobile:
        return 8;
      case ScreenType.tablet:
        return 10;
      case ScreenType.desktop:
        return 12;
    }
  }

  double _getIconPadding() {
    switch (screenType) {
      case ScreenType.mobile:
        return 12;
      case ScreenType.tablet:
        return 14;
      case ScreenType.desktop:
        return 16;
    }
  }

  double _getHeaderIconSize() {
    switch (screenType) {
      case ScreenType.mobile:
        return 24;
      case ScreenType.tablet:
        return 28;
      case ScreenType.desktop:
        return 32;
    }
  }

  double _getActionIconSize() {
    switch (screenType) {
      case ScreenType.mobile:
        return 16;
      case ScreenType.tablet:
        return 18;
      case ScreenType.desktop:
        return 20;
    }
  }

  double _getHeaderFontSize() {
    switch (screenType) {
      case ScreenType.mobile:
        return 20;
      case ScreenType.tablet:
        return 24;
      case ScreenType.desktop:
        return 28;
    }
  }

  double _getSubheaderFontSize() {
    switch (screenType) {
      case ScreenType.mobile:
        return 16;
      case ScreenType.tablet:
        return 18;
      case ScreenType.desktop:
        return 20;
    }
  }

  double _getSubtitleFontSize() {
    switch (screenType) {
      case ScreenType.mobile:
        return 12;
      case ScreenType.tablet:
        return 14;
      case ScreenType.desktop:
        return 16;
    }
  }

  double _getActionFontSize() {
    switch (screenType) {
      case ScreenType.mobile:
        return 11;
      case ScreenType.tablet:
        return 12;
      case ScreenType.desktop:
        return 13;
    }
  }

  Widget _buildHeaderActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Refresh button
        IconButton(
          onPressed: () => _handleActionTap('Yenile'),
          icon: Icon(
            Icons.refresh,
            color: Colors.grey.shade600,
            size: _getActionIconSize() + 2,
          ),
          tooltip: 'Yenile',
        ),
        
        // Settings button
        IconButton(
          onPressed: () => _handleActionTap('Ayarlar'),
          icon: Icon(
            Icons.settings_outlined,
            color: Colors.grey.shade600,
            size: _getActionIconSize() + 2,
          ),
          tooltip: 'Ayarlar',
        ),
        
        // Export button
        IconButton(
          onPressed: () => _handleActionTap('Dışa Aktar'),
          icon: Icon(
            Icons.file_download_outlined,
            color: Colors.grey.shade600,
            size: _getActionIconSize() + 2,
          ),
          tooltip: 'Dışa Aktar',
        ),
      ],
    );
  }
} 