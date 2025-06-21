import 'package:flutter/material.dart';
import 'base_page.dart';

class AlisFaturasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Alış Faturası',
      content: const Center(
        child: Text('Alış Faturası içeriği'),
      ),
    );
  }
}

class SatinalmasiparisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Satınalma Siparişi',
      content: const Center(
        child: Text('Satınalma Siparişi içeriği'),
      ),
    );
  }
}

class TedarikciKartlariPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Tedarikçi Kartları',
      content: const Center(
        child: Text('Tedarikçi Kartları içeriği'),
      ),
    );
  }
}

class AlisRaporuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Alış Raporu',
      content: const Center(
        child: Text('Alış Raporu içeriği'),
      ),
    );
  }
} 