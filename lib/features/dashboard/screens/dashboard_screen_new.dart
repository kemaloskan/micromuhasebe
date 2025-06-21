import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_menu_provider.dart';
import '../widgets/dashboard_menu.dart';
import '../widgets/dashboard_content.dart';
import '../widgets/dashboard_top_bar.dart';

class DashboardScreenNew extends StatefulWidget {
  const DashboardScreenNew({super.key});

  @override
  State<DashboardScreenNew> createState() => _DashboardScreenNewState();
}

class _DashboardScreenNewState extends State<DashboardScreenNew> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardMenuProvider(),
      child: Consumer<DashboardMenuProvider>(
        builder: (context, menuProvider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1024;
              final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1024;
              final isMobile = constraints.maxWidth < 768;

              return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.grey.shade50,
                // Mobile ve tablet için drawer
                drawer: (isMobile || isTablet) ? DashboardMenu(
                  isMobile: isMobile,
                  onItemSelected: () {
                    Navigator.of(context).pop();
                  },
                ) : null,
                body: Row(
                  children: [
                    // Desktop için sidebar
                    if (isDesktop) DashboardMenu(
                      isMobile: false,
                      onItemSelected: () {},
                    ),
                    
                    // Ana content area
                    Expanded(
                      child: Column(
                        children: [
                          // Content
                          Expanded(
                            child: DashboardContent(
                              screenType: isDesktop ? ScreenType.desktop 
                                        : isTablet ? ScreenType.tablet 
                                        : ScreenType.mobile,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

enum ScreenType { mobile, tablet, desktop } 