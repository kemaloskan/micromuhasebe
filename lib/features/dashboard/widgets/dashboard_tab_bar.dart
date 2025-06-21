import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../dashboard_screen_new.dart';
import '../../../core/constants/app_colors.dart';

class DashboardTabBar extends StatelessWidget {
  final ScreenType screenType;
  
  const DashboardTabBar({
    super.key,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TabProvider>(
      builder: (context, tabProvider, child) {
        if (!tabProvider.hasTabs) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.borderPrimary, width: 1),
              bottom: BorderSide(color: AppColors.borderPrimary, width: 1),
            ),
          ),
          padding: EdgeInsets.only(top: 5),
          child: Row(
            children: [
              // Scrollable tab list
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: tabProvider.tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tab = entry.value;
                      final isActive = index == tabProvider.activeTabIndex;
                      
                      return _buildChromeStyleTab(
                        tab: tab,
                        index: index,
                        isActive: isActive,
                        onTap: () => tabProvider.setActiveTab(index),
                        onClose: () => tabProvider.closeTab(index),
                        showCloseIcon: true,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChromeStyleTab({
    required TabItem tab,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
    required VoidCallback onClose,
    required bool showCloseIcon,
  }) {
    return _ChromeStyleTab(
      tab: tab,
      index: index,
      isActive: isActive,
      onTap: onTap,
      onClose: onClose,
      showCloseIcon: showCloseIcon,
      screenType: screenType,
    );
  }
}

class _ChromeStyleTab extends StatefulWidget {
  final TabItem tab;
  final int index;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final bool showCloseIcon;
  final ScreenType screenType;

  const _ChromeStyleTab({
    required this.tab,
    required this.index,
    required this.isActive,
    required this.onTap,
    required this.onClose,
    required this.showCloseIcon,
    required this.screenType,
  });

  @override
  State<_ChromeStyleTab> createState() => _ChromeStyleTabState();
}

class _ChromeStyleTabState extends State<_ChromeStyleTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: CustomPaint(
        painter: TabPainter(
          isActive: widget.isActive,
          isSelected: false,
          isHovered: _isHovered,
          activeColor: AppColors.primaryMain,
          selectedColor: AppColors.primaryMain.withValues(alpha: 0.1),
          inactiveColor: Colors.white,
          hoverColor: Colors.grey[50]!,
          borderColor: Colors.grey[300]!,
          selectedBorderColor: AppColors.primaryMain.withValues(alpha: 0.3),
        ),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          hitTestBehavior: HitTestBehavior.translucent,
          child: ClipPath(
            clipper: TabShapeClipper(),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: _getMinTabWidth(),
                    maxWidth: _getMaxTabWidth(),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: _getTabPadding(),
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon
                      Icon(
                        widget.tab.icon,
                        size: _getIconSize(),
                        color: _getIconColor(widget.isActive),
                      ),
                      SizedBox(width: _getIconTextSpacing()),
                      
                      // Title
                      Flexible(
                        child: Text(
                          widget.tab.title,
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight: FontWeight.w500,
                            color: _getTextColor(widget.isActive),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      if (widget.showCloseIcon) ...[
                        SizedBox(width: _getIconTextSpacing()),
                        
                        // Close button
                        InkWell(
                          onTap: widget.onClose,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.all(_getCloseButtonPadding()),
                            child: Icon(
                              Icons.close,
                              size: _getCloseIconSize(),
                              color: widget.onClose != null 
                                ? _getCloseButtonColor(widget.isActive) 
                                : _getCloseButtonColor(widget.isActive).withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  double _getPadding() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 6;
      case ScreenType.tablet:
        return 8;
      case ScreenType.desktop:
        return 10;
    }
  }

  double _getTabPadding() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 12;
      case ScreenType.tablet:
        return 16;
      case ScreenType.desktop:
        return 20;
    }
  }

  double _getMinTabWidth() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 100;
      case ScreenType.tablet:
        return 110;
      case ScreenType.desktop:
        return 120;
    }
  }

  double _getMaxTabWidth() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 160;
      case ScreenType.tablet:
        return 180;
      case ScreenType.desktop:
        return 200;
    }
  }

  double _getIconSize() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 14;
      case ScreenType.tablet:
        return 15;
      case ScreenType.desktop:
        return 16;
    }
  }

  double _getFontSize() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 11;
      case ScreenType.tablet:
        return 12;
      case ScreenType.desktop:
        return 13;
    }
  }

  double _getIconTextSpacing() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 4;
      case ScreenType.tablet:
        return 5;
      case ScreenType.desktop:
        return 6;
    }
  }

  double _getCloseButtonPadding() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 2;
      case ScreenType.tablet:
        return 3;
      case ScreenType.desktop:
        return 4;
    }
  }

  double _getCloseIconSize() {
    switch (widget.screenType) {
      case ScreenType.mobile:
        return 12;
      case ScreenType.tablet:
        return 13;
      case ScreenType.desktop:
        return 14;
    }
  }

  Color _getIconColor(bool isActive) {
    if (isActive) return Colors.white;
    return Colors.grey[600]!;
  }

  Color _getTextColor(bool isActive) {
    if (isActive) return Colors.white;
    return Colors.grey[700]!;
  }

  Color _getCloseButtonColor(bool isActive) {
    if (isActive) return Colors.white.withValues(alpha: 0.8);
    return AppColors.textTertiary;
  }
}

class TabPainter extends CustomPainter {
  final bool isActive;
  final bool isSelected;
  final bool isHovered;
  final Color activeColor;
  final Color selectedColor;
  final Color inactiveColor;
  final Color hoverColor;
  final Color borderColor;
  final Color selectedBorderColor;

  const TabPainter({
    required this.isActive,
    required this.isSelected,
    required this.isHovered,
    required this.activeColor,
    required this.selectedColor,
    required this.inactiveColor,
    required this.hoverColor,
    required this.borderColor,
    required this.selectedBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    
    // Düz trapez şekli (2px radius)
    const radius = 2.0;
    const skew = 8.0;
    
    // Sol alt köşeden başla
    path.moveTo(0, size.height);
    
    // Sol kenar (yukarı ve içe doğru eğik)
    path.lineTo(skew - radius, radius);
    
    // Sol üst köşe (2px radius)
    path.quadraticBezierTo(skew, 0, skew + radius, 0);
    
    // Üst kenar
    path.lineTo(size.width - skew - radius, 0);
    
    // Sağ üst köşe (2px radius)
    path.quadraticBezierTo(size.width - skew, 0, size.width - skew + radius, radius);
    
    // Sağ kenar (aşağı ve dışa doğru eğik)
    path.lineTo(size.width, size.height);
    
    // Alt kenar
    path.lineTo(0, size.height);
    
    path.close();

    // Fill color - aktif, seçili, hover veya normal state
    Color fillColor;
    if (isActive) {
      fillColor = activeColor;
    } else if (isSelected) {
      fillColor = selectedColor;
    } else if (isHovered) {
      fillColor = hoverColor;
    } else {
      fillColor = inactiveColor;
    }

    canvas.drawPath(path, Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill);

    // Normal border
    canvas.drawPath(path, Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    // Selected border (thicker blue border)
    if (isSelected && !isActive) {
      canvas.drawPath(path, Paint()
        ..color = selectedBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TabShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Düz trapez şekli (2px radius)
    const radius = 2.0;
    const skew = 8.0;
    
    // Sol alt köşeden başla
    path.moveTo(0, size.height);
    
    // Sol kenar (yukarı ve içe doğru eğik)
    path.lineTo(skew - radius, radius);
    
    // Sol üst köşe (2px radius)
    path.quadraticBezierTo(skew, 0, skew + radius, 0);
    
    // Üst kenar
    path.lineTo(size.width - skew - radius, 0);
    
    // Sağ üst köşe (2px radius)
    path.quadraticBezierTo(size.width - skew, 0, size.width - skew + radius, radius);
    
    // Sağ kenar (aşağı ve dışa doğru eğik)
    path.lineTo(size.width, size.height);
    
    // Alt kenar
    path.lineTo(0, size.height);
    
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
} 