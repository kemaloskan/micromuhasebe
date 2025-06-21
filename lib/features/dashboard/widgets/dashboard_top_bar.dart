import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';

class DashboardTopBar extends StatelessWidget {
  final bool showMenuButton;
  final VoidCallback? onMenuTap;
  
  const DashboardTopBar({
    super.key,
    this.showMenuButton = false,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1024;
        
        return Container(
          height: 64,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : isTablet ? 20 : 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Menu button (mobile/tablet)
              if (showMenuButton) ...[
                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(Icons.menu),
                  color: Colors.grey.shade600,
                  iconSize: isMobile ? 22 : 24,
                ),
                const SizedBox(width: 8),
              ],
              
              // App title
              if (isMobile) ...[
                // Mobile'da kısa title
                Text(
                  'Micro ERP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF696CFF),
                  ),
                ),
              ] else ...[
                // Tablet/Desktop'ta full title
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF696CFF),
                  ),
                ),
              ],
              
              const Spacer(),
              
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Row(
                    children: [
                      // User info (sadece desktop'ta göster)
                      if (!isMobile) ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              authProvider.userName ?? 'Kullanıcı',
                              style: TextStyle(
                                fontSize: isTablet ? 13 : 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF566A7F),
                              ),
                            ),
                            Text(
                              authProvider.getRoleDisplayName(),
                              style: TextStyle(
                                fontSize: isTablet ? 11 : 12,
                                color: const Color(0xFFA5A3AE),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                      ],
                      
                      // User avatar and menu
                      PopupMenuButton<String>(
                        icon: CircleAvatar(
                          backgroundColor: const Color(0xFF696CFF),
                          radius: isMobile ? 16 : isTablet ? 18 : 20,
                          child: Text(
                            authProvider.getUserInitials(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 12 : isTablet ? 13 : 14,
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
                                Flexible(
                                  child: Text(
                                    'Profil (${authProvider.userEmail})',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
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
                            await _handleLogout(context);
                          } else if (value == 'profile') {
                            _handleProfile(context);
                          } else if (value == 'settings') {
                            _handleSettings(context);
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
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
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

    if (confirmed == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(SuccessMessages.logoutSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _handleProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil sayfası henüz mevcut değil')),
    );
  }

  void _handleSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ayarlar sayfası henüz mevcut değil')),
    );
  }
} 