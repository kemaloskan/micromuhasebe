import 'package:flutter/material.dart';
import 'package:micromuhasebe/features/dashboard/pages/base_page.dart';
import 'package:micromuhasebe/features/dashboard/widgets/stock_search_dialog.dart';

// Stok İşlemleri Sayfaları
class StokGirisFisiPage extends StatefulWidget {
  @override
  State<StokGirisFisiPage> createState() => _StokGirisFisiPageState();
}

class _StokGirisFisiPageState extends State<StokGirisFisiPage> {
  StockItem? _selectedStock;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Stok Giriş Fişi',
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            Expanded(child: _buildStokGirisForm()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF696CFF),
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE7E7FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.input, 
                color: const Color(0xFF696CFF), 
                size: 24
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stok Giriş Fişi',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF696CFF),
                  ),
                ),
                Text(
                  'Depoya stok girişi yapın',
                  style: TextStyle(color: Color(0xFF5F6368)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStokGirisForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Fiş Bilgileri Card
          Card(
            elevation: 2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fiş Bilgileri',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF696CFF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Fiş Numarası',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF696CFF), width: 2),
                      ),
                      labelStyle: TextStyle(color: Color(0xFF5F6368)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Depo Seçin',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF696CFF), width: 2),
                      ),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF696CFF)),
                      labelStyle: TextStyle(color: Color(0xFF5F6368)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Açıklama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF696CFF), width: 2),
                      ),
                      labelStyle: TextStyle(color: Color(0xFF5F6368)),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stok Seçimi Card
          Card(
            elevation: 2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stok Seçimi',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF696CFF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Stok Seçim Butonu
                  InkWell(
                    onTap: _openStockSearchDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xFF696CFF),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedStock != null 
                                    ? '${_selectedStock!.code} - ${_selectedStock!.name}'
                                    : 'Stok kartı seçin',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _selectedStock != null ? FontWeight.w500 : FontWeight.normal,
                                    color: _selectedStock != null ? Colors.black87 : Colors.grey.shade600,
                                  ),
                                ),
                                if (_selectedStock != null)
                                  Text(
                                    'Fiyat: ${_selectedStock!.price.toStringAsFixed(2)} TL',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade400,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  if (_selectedStock != null) ...[
                    const SizedBox(height: 16),
                    
                    // Miktar ve Fiyat Bilgileri
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _quantityController,
                            decoration: InputDecoration(
                              labelText: 'Miktar',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Color(0xFF696CFF), width: 2),
                              ),
                              labelStyle: TextStyle(color: Color(0xFF5F6368)),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _unitPriceController,
                            decoration: InputDecoration(
                              labelText: 'Birim Fiyat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Color(0xFF696CFF), width: 2),
                              ),
                              labelStyle: TextStyle(color: Color(0xFF5F6368)),
                              suffixText: 'TL',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Toplam Tutar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Toplam Tutar:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF696CFF),
                            ),
                          ),
                          Text(
                            '${_calculateTotal()} TL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF696CFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openStockSearchDialog() async {
    final selectedStock = await showDialog<StockItem>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const StockSearchPage(),
    );

    if (selectedStock != null) {
      setState(() {
        _selectedStock = selectedStock;
        _unitPriceController.text = selectedStock.price.toStringAsFixed(2);
      });
    }
  }

  String _calculateTotal() {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final total = quantity * unitPrice;
    return total.toStringAsFixed(2);
  }
}

class StokCikisFisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Stok Çıkış Fişi',
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
                    Icon(Icons.output, color: Colors.red[600], size: 32),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stok Çıkış Fişi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Depodan stok çıkışı yapın',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
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
                  child: const Center(
                    child: Text(
                      'Stok çıkış formu burada olacak',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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

class SayimFisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Sayım Fişi',
      content: const Center(
        child: Text('Sayım Fişi içeriği'),
      ),
    );
  }
}

class DepoTransferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Depo Transfer',
      content: const Center(
        child: Text('Depo Transfer içeriği'),
      ),
    );
  }
}

// Stok Tanımları Sayfaları
class StokKartlariPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Stok Kartları',
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
                    Icon(Icons.inventory_2, color: Color(0xFF696CFF), size: 32),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stok Kartları',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Ürün ve hizmet kartlarını yönetin',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Kart'),
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
                          labelText: 'Stok Ara...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF696CFF),
                                  child: Text('${index + 1}'),
                                ),
                                title: Text('Ürün ${index + 1}'),
                                subtitle: Text('Stok Kodu: STK00${index + 1}'),
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

class HizliStokTanimiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Hızlı Stok Tanımı',
      content: const Center(
        child: Text('Hızlı Stok Tanımı içeriği'),
      ),
    );
  }
}

// Stok Raporları
class StokListesiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Stok Listesi',
      content: const Center(
        child: Text('Stok Listesi Raporu'),
      ),
    );
  }
}

class StokHareketRaporuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Stok Hareket Raporu',
      content: const Center(
        child: Text('Stok Hareket Raporu içeriği'),
      ),
    );
  }
} 