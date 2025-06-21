import 'package:flutter/material.dart';
import 'base_page.dart';

class TahsilatFisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Tahsilat Fişi',
      content: const Center(
        child: Text('Tahsilat Fişi içeriği'),
      ),
    );
  }
}

class OdemeFisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Ödeme Fişi',
      content: const Center(
        child: Text('Ödeme Fişi içeriği'),
      ),
    );
  }
}

class KasaTanimlariPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Kasa Tanımları',
      content: const Center(
        child: Text('Kasa Tanımları içeriği'),
      ),
    );
  }
}

class KasaRaporuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Kasa Raporu',
      content: const Center(
        child: Text('Kasa Raporu içeriği'),
      ),
    );
  }
} 