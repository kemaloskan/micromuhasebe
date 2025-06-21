import 'package:flutter/material.dart';
import '../dashboard_screen_new.dart';
import 'dashboard_menu.dart';
import 'dashboard_content.dart';

class MainDashboardLayout extends StatelessWidget {
  final ScreenType screenType;
  final GlobalKey<ScaffoldState> scaffoldKey;
  
  const MainDashboardLayout({
    super.key,
    required this.screenType,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = screenType == ScreenType.desktop;

    return Row(
      children: [
        // Desktop için sidebar
        if (isDesktop) DashboardMenu(
          isMobile: false,
          onItemSelected: () {},
        ),
        
        // Ana content area
        Expanded(
          child: DashboardContent(
            screenType: screenType,
          ),
        ),
      ],
    );
  }
} 