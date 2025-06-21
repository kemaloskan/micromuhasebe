import 'package:flutter/material.dart';
import 'base_page.dart';

class SatisFaturasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Satış Faturası',
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.receipt, color: Colors.green[600], size: 32),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Satış Faturası',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Müşteri satış faturası oluşturun',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Fatura'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fatura Bilgileri',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Fatura No',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Tarih',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Müşteri Seçin',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ],
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

class iadeFaturasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'İade Faturası',
      content: const Center(
        child: Text('İade Faturası içeriği'),
      ),
    );
  }
}

class MusteriKartlariPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Müşteri Kartları',
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.people, color: Color(0xFF696CFF), size: 32),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Müşteri Kartları',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Müşteri bilgilerini yönetin',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add),
                      label: const Text('Yeni Müşteri'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF696CFF),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Müşteri Ara...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF696CFF),
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                                title: Text('Müşteri ${index + 1}'),
                                subtitle: Text('Telefon: 0555 123 456${index}'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {},
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

class SatisRaporuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Satış Raporu',
      content: const Center(
        child: Text('Satış Raporu içeriği'),
      ),
    );
  }
} 