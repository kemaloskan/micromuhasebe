import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';

class MenuDataProvider {
  static List<MenuItem> getMenuItems() {
    return [
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
  }
} 