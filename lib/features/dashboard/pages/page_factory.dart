import 'package:flutter/material.dart';
import 'base_page.dart';
import 'stok_pages.dart';
import 'satis_pages.dart';
import 'satinalma_pages.dart';
import 'finans_pages.dart';
import '../../../core/constants/app_colors.dart';

class PageFactory {
  static Widget createPage(String pageTitle) {
    switch (pageTitle) {
      // Dashboard
      case 'Dashboard':
        return _createDashboardPage();

      // Stok Yönetimi Sayfaları
      case 'Stok Giriş Fişi':
        return StokGirisFisiPage();
      case 'Stok Çıkış Fişi':
        return StokCikisFisiPage();
      case 'Sayım Fişi':
        return SayimFisiPage();
      case 'Depo Transfer':
        return DepoTransferPage();
      case 'Stok Kartları':
        return StokKartlariPage();
      case 'Hızlı Stok Tanımı':
        return HizliStokTanimiPage();
      case 'Stok Listesi':
        return StokListesiPage();
      case 'Stok Hareket Raporu':
        return StokHareketRaporuPage();

      // Satış Yönetimi Sayfaları
      case 'Satış Faturası':
        return SatisFaturasiPage();
      case 'İade Faturası':
        return iadeFaturasiPage();
      case 'Müşteri Kartları':
        return MusteriKartlariPage();
      case 'Satış Raporu':
        return SatisRaporuPage();

      // Satın Alma Yönetimi Sayfaları
      case 'Alış Faturası':
        return AlisFaturasiPage();
      case 'Satınalma Siparişi':
        return SatinalmasiparisiPage();
      case 'Tedarikçi Kartları':
        return TedarikciKartlariPage();
      case 'Alış Raporu':
        return AlisRaporuPage();

      // Finans Yönetimi Sayfaları
      case 'Tahsilat Fişi':
        return TahsilatFisiPage();
      case 'Ödeme Fişi':
        return OdemeFisiPage();
      case 'Kasa Tanımları':
        return KasaTanimlariPage();
      case 'Kasa Raporu':
        return KasaRaporuPage();

      // Varsayılan sayfa
      default:
        return _createDefaultPage(pageTitle);
    }
  }

  static Widget _createDashboardPage() {
    return BasePage(
      title: 'Dashboard',
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.activeBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.dashboard,
                size: 64,
                color: AppColors.primaryMain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ana Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hoş geldiniz! Bu ana dashboard sayfasıdır.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _createDefaultPage(String title) {
    return BasePage(
      title: title,
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              color: AppColors.backgroundSecondary,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.activeBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: AppColors.primaryMain,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryMain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bu sayfa henüz geliştirilme aşamasındadır.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sayfa: $title',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Örnek içerik kartları
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildInfoCard(
                    'Özellikler',
                    'Sayfa özellikleri burada listelenir',
                    Icons.star,
                    AppColors.warningMain,
                  ),
                  _buildInfoCard(
                    'İşlemler',
                    'Yapılabilecek işlemler burada gösterilir',
                    Icons.build,
                    AppColors.infoMain,
                  ),
                  _buildInfoCard(
                    'Raporlar',
                    'İlgili raporlar bu bölümde yer alır',
                    Icons.assessment,
                    AppColors.successMain,
                  ),
                  _buildInfoCard(
                    'Ayarlar',
                    'Sayfa ayarları ve konfigürasyonlar',
                    Icons.settings,
                    AppColors.secondaryMain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryMain,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  static Widget _buildInfoCard(String title, String description, IconData icon, Color accentColor) {
    return Card(
      elevation: 2,
      color: AppColors.backgroundSecondary,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 