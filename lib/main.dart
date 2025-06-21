import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/menu_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/sidebar_provider.dart';
import 'widgets/sidebar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SidebarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Micro Muhasebe',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: isMobile ? const Drawer(child: Sidebar()) : null,
      body: Row(
        children: [
          if (!isMobile) const DesktopSidebar(),
          Expanded(child: MainContent(scaffoldKey: isMobile ? _scaffoldKey : null)),
        ],
      ),
    );
  }
}

class DesktopSidebar extends StatelessWidget {
  const DesktopSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarProvider = context.watch<SidebarProvider>();
    final sidebarWidth = sidebarProvider.isExpanded ? 260.0 : 70.0;
    const animationDuration = Duration(milliseconds: 200);

    // Add 16px extra width for the overflowing part of the button (32px / 2)
    // This creates a "safety zone" for hit-testing.
    final totalWidth = sidebarWidth + 16.0;

    return SizedBox(
      width: totalWidth,
      child: MouseRegion(
        onEnter: (_) => context.read<SidebarProvider>().onHoverEntered(),
        onExit: (_) => context.read<SidebarProvider>().onHoverExited(),
        child: Stack(
          children: [
            // The visible sidebar content, positioned to the left
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Material(
                elevation: 1,
                child: AnimatedContainer(
                  duration: animationDuration,
                  curve: Curves.easeOut,
                  width: sidebarWidth,
                  child: const Sidebar(),
                ),
              ),
            ),
            // The toggle button, positioned within the full bounds of the parent Stack
            AnimatedPositioned(
              duration: animationDuration,
              curve: Curves.easeOut,
              top: 24,
              left: sidebarWidth - 16,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: sidebarProvider.isExpanded ? 1.0 : 0.0,
                child: Material(
                  elevation: 6,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).colorScheme.primary,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.1),
                    onTap: () {
                      context.read<SidebarProvider>().togglePin();
                    },
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: Icon(
                          sidebarProvider.isPinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const MainContent({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarWidget(scaffoldKey: scaffoldKey),
        const Expanded(child: ContentArea()),
      ],
    );
  }
}

class AppBarWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppBarWidget({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isMobile = MediaQuery.of(context).size.width < 1200;
    final isDarkMode = themeProvider.isDarkMode;

    final Widget appBarContent = Row(
      children: [
        if (isMobile)
          IconButton(
            icon: Icon(Icons.menu,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => scaffoldKey?.currentState?.openDrawer(),
          ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search (Ctrl+K)',
              hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14),
              prefixIcon: Icon(Icons.search,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  size: 20),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.language_outlined,
                color: Theme.of(context).colorScheme.onSurface)),
        IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Icon(
                isDarkMode
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round_outlined,
                color: Theme.of(context).colorScheme.onSurface)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.grid_view_outlined,
                color: Theme.of(context).colorScheme.onSurface)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined,
                color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(width: 10),
        VerticalDivider(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
        const SizedBox(width: 10),
        PopupMenuButton<String>(
          onSelected: (value) {},
          offset: const Offset(0, 50),
          child: const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
                'https://api.dicebear.com/8.x/pixel-art/png?seed=JohnDoe&backgroundType=gradientLinear'),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'profil', child: Text('Profilim')),
            const PopupMenuItem(value: 'ayarlar', child: Text('Ayarlar')),
            const PopupMenuDivider(),
            const PopupMenuItem(value: 'cikis', child: Text('Çıkış Yap')),
          ],
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: kToolbarHeight + 10,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withOpacity(0.2)),
              ),
              child: appBarContent,
            ),
          ),
        ),
      ),
    );
  }
}

class ContentArea extends StatelessWidget {
  const ContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      itemCount: 50,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 7.5),
          elevation: 0,
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color:
                  Theme.of(context).colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ListTile(
            title: Text('Öğe Numarası ${index + 1}'),
            subtitle: const Text('Bu bir kart içeriğidir.'),
          ),
        );
      },
    );
  }
}
