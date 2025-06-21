import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StockSearchPage extends StatefulWidget {
  const StockSearchPage({super.key});

  @override
  State<StockSearchPage> createState() => _StockSearchPageState();
}

class _StockSearchPageState extends State<StockSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedGroup = 'Tümü';
  String _searchCriteria = 'Tümü';
  String _statusFilter = 'Tümü';
  
  // Window control states - simplified
  bool _isMaximized = false;
  
  List<StockItem> _allStocks = [];
  List<StockItem> _filteredStocks = [];
  StockItem? _selectedStock;
  
  int? _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsPerPage = 10;
  String _searchQuery = '';

  final List<String> _groups = ['Tümü', 'A GRUBU', 'B GRUBU', 'C GRUBU', 'D GRUBU'];
  final List<String> _searchCriteriaList = ['Tümü', 'Stok Kodu', 'Stok Adı', 'Barkod'];
  final List<String> _statusOptions = ['Tümü', 'Aktif', 'Pasif'];

  late StockDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _allStocks = _generateStockData();
    _filteredStocks = List.from(_allStocks);
    _updateDataSource();
  }

  void _updateDataSource() {
    _dataSource = StockDataSource(
      stocks: _filteredStocks,
      selectedStock: _selectedStock,
      onSelectionChanged: _onStockSelectionChanged,
      searchQuery: _searchQuery,
    );
  }

  void _toggleMaximize() {
    setState(() {
      _isMaximized = !_isMaximized;
    });
  }

  void _closeWindow() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;
    
    Widget pageContent = Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.search, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Stok Arama (${_filteredStocks.length} kayıt)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false, // Remove default back button
        actions: [
          IconButton(
            onPressed: _resetFilters,
            icon: Icon(Icons.refresh),
            tooltip: 'Filtreleri Sıfırla',
          ),
          // Maximize/Restore Button  
          IconButton(
            onPressed: _toggleMaximize,
            icon: Icon(
              _isMaximized ? Icons.fullscreen_exit : Icons.fullscreen,
              size: 20,
            ),
            tooltip: _isMaximized ? 'Eski Boyut' : 'Büyüt',
            padding: EdgeInsets.all(8),
          ),
          // Close Button
          IconButton(
            onPressed: _closeWindow,
            icon: Icon(Icons.close, size: 20),
            tooltip: 'Kapat',
            padding: EdgeInsets.all(8),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      bottomNavigationBar: _buildBottomBar(),
    );

    if (_isMaximized) {
      // Full screen mode
      return pageContent;
    } else {
      // Resizable window mode
      return Dialog(
        child: Container(
          width: screenSize.width * 0.8,
          height: screenSize.height * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 2.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: pageContent,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchField(),
          SizedBox(height: 16),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              children: [
                _buildSearchField(),
                SizedBox(height: 16),
                _buildDesktopFilters(),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Arama',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            )
          : null,
      ),
      onChanged: _performSearch,
    );
  }

  Widget _buildDesktopFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filtreler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        
        DropdownButtonFormField<String>(
          value: _searchCriteria,
          decoration: InputDecoration(
            labelText: 'Arama Kriteri',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: _searchCriteriaList.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) {
            setState(() => _searchCriteria = v!);
            _performSearch(_searchController.text);
          },
        ),
        
        SizedBox(height: 12),
        
        DropdownButtonFormField<String>(
          value: _selectedGroup,
          decoration: InputDecoration(
            labelText: 'Grup',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: _groups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (v) {
            setState(() => _selectedGroup = v!);
            _performSearch(_searchController.text);
          },
        ),
        
        SizedBox(height: 12),
        
        DropdownButtonFormField<String>(
          value: _statusFilter,
          decoration: InputDecoration(
            labelText: 'Durum',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: _statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) {
            setState(() => _statusFilter = v!);
            _performSearch(_searchController.text);
          },
        ),
        
        SizedBox(height: 16),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _resetFilters,
            icon: Icon(Icons.refresh, size: 16),
            label: Text('Sıfırla'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.table_chart, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Stok Listesi (${_filteredStocks.length} kayıt)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Spacer(),
                if (_selectedStock != null)
                  Chip(
                    avatar: Icon(Icons.check_circle, color: Colors.green, size: 16),
                    label: Text('Seçildi', style: TextStyle(fontSize: 12)),
                    backgroundColor: Colors.green.shade50,
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * (isMobile ? 0.9 : 0.6),
                    ),
                    child: DataTable(
                      columns: _buildColumns(isMobile),
                      rows: _buildDataRows(isMobile),
                      columnSpacing: isMobile ? 16 : 24,
                      horizontalMargin: 16,
                      headingRowHeight: 48,
                      dataRowHeight: 56,
                      showCheckboxColumn: false,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (_selectedStock != null)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seçili Stok:',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${_selectedStock!.code} - ${_selectedStock!.name}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Fiyat: ₺${_selectedStock!.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
          if (_selectedStock != null) SizedBox(width: 16),
          
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('İptal'),
          ),
          
          SizedBox(width: 8),
          
          ElevatedButton(
            onPressed: _selectedStock != null 
              ? () => Navigator.of(context).pop(_selectedStock)
              : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Seç'),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredStocks = _allStocks.where((stock) {
        bool matchesSearch = query.isEmpty || _matchesSearchCriteria(stock, query);
        bool matchesGroup = _selectedGroup == 'Tümü' || stock.group == _selectedGroup;
        bool matchesStatus = _matchesStatusFilter(stock);
        
        return matchesSearch && matchesGroup && matchesStatus;
      }).toList();
      
      _updateDataSource();
    });
  }

  bool _matchesSearchCriteria(StockItem stock, String query) {
    final lowerQuery = query.toLowerCase();
    switch (_searchCriteria) {
      case 'Stok Kodu': return stock.code.toLowerCase().contains(lowerQuery);
      case 'Stok Adı': return stock.name.toLowerCase().contains(lowerQuery);
      case 'Barkod': return stock.barcode.toLowerCase().contains(lowerQuery);
      default: return stock.code.toLowerCase().contains(lowerQuery) ||
                      stock.name.toLowerCase().contains(lowerQuery) ||
                      stock.barcode.toLowerCase().contains(lowerQuery);
    }
  }

  bool _matchesStatusFilter(StockItem stock) {
    switch (_statusFilter) {
      case 'Aktif': return stock.isActive;
      case 'Pasif': return !stock.isActive;
      default: return true;
    }
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      // Add sorting implementation if needed
    });
  }

  void _onStockSelectionChanged(StockItem? stock) {
    setState(() => _selectedStock = stock);
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedGroup = 'Tümü';
      _searchCriteria = 'Tümü';
      _statusFilter = 'Tümü';
      _searchQuery = '';
      _sortColumnIndex = null;
      _sortAscending = true;
    });
    _performSearch('');
  }

  List<StockItem> _generateStockData() => [
    StockItem(
      code: 'STK001', name: 'Laptop Dell XPS 13', group: 'A GRUBU',
      price: 25000, stockLevel: 15, barcode: '1234567890123',
      description: 'Yüksek performanslı laptop', isActive: true,
    ),
    StockItem(
      code: 'STK002', name: 'Monitör Samsung 24"', group: 'B GRUBU',
      price: 3500, stockLevel: 25, barcode: '2345678901234',
      description: 'Full HD monitör', isActive: true,
    ),
    StockItem(
      code: 'STK003', name: 'Klavye Logitech MX', group: 'C GRUBU',
      price: 1200, stockLevel: 8, barcode: '3456789012345',
      description: 'Mekanik klavye', isActive: false,
    ),
    StockItem(
      code: 'STK004', name: 'Mouse Gaming RGB', group: 'C GRUBU',
      price: 850, stockLevel: 12, barcode: '4567890123456',
      description: 'Gaming mouse', isActive: true,
    ),
    StockItem(
      code: 'STK005', name: 'Tablet iPad Air', group: 'A GRUBU',
      price: 18000, stockLevel: 5, barcode: '5678901234567',
      description: 'Apple tablet', isActive: true,
    ),
    StockItem(
      code: 'STK006', name: 'Telefon iPhone 15', group: 'A GRUBU',
      price: 45000, stockLevel: 3, barcode: '6789012345678',
      description: 'Apple telefon', isActive: true,
    ),
    StockItem(
      code: 'STK007', name: 'Kulaklık Sony WH', group: 'B GRUBU',
      price: 2500, stockLevel: 0, barcode: '7890123456789',
      description: 'Kablosuz kulaklık', isActive: false,
    ),
    StockItem(
      code: 'STK008', name: 'Yazıcı HP LaserJet', group: 'B GRUBU',
      price: 4200, stockLevel: 7, barcode: '8901234567890',
      description: 'Lazer yazıcı', isActive: true,
    ),
    StockItem(
      code: 'STK009', name: 'Hard Disk 1TB', group: 'C GRUBU',
      price: 1800, stockLevel: 20, barcode: '9012345678901',
      description: 'Harici disk', isActive: true,
    ),
    StockItem(
      code: 'STK010', name: 'Ram 16GB DDR4', group: 'D GRUBU',
      price: 2200, stockLevel: 15, barcode: '0123456789012',
      description: 'DDR4 bellek', isActive: true,
    ),
  ];

  List<DataRow> _buildDataRows(bool isMobile) {
    return _filteredStocks.map((stock) {
      return DataRow(
        selected: _selectedStock?.code == stock.code,
        onSelectChanged: (selected) {
          _onStockSelectionChanged(selected == true ? stock : null);
        },
        cells: _buildDataCells(stock, isMobile),
      );
    }).toList();
  }

  List<DataCell> _buildDataCells(StockItem stock, bool isMobile) {
    if (isMobile) {
      return [
        DataCell(Text(stock.code, style: TextStyle(fontSize: 13))),
        DataCell(Text(stock.name, style: TextStyle(fontSize: 13))),
        DataCell(Text('₺${stock.price.toStringAsFixed(2)}', 
          style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500))),
      ];
    } else {
      return [
        DataCell(Text(stock.code, style: TextStyle(fontSize: 13))),
        DataCell(Text(stock.name, style: TextStyle(fontSize: 13))),
        DataCell(Text(stock.group, style: TextStyle(fontSize: 13))),
        DataCell(Text('₺${stock.price.toStringAsFixed(2)}', 
          style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500))),
        DataCell(Text('${stock.stockLevel}', style: TextStyle(fontSize: 13))),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: stock.isActive ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              stock.isActive ? 'Aktif' : 'Pasif',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: stock.isActive ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ),
        ),
      ];
    }
  }

  List<DataColumn> _buildColumns(bool isMobile) {
    if (isMobile) {
      return [
        DataColumn(
          label: Text('Kod', style: TextStyle(fontWeight: FontWeight.w600)),
          onSort: (i, asc) => _sortData(i, asc),
        ),
        DataColumn(
          label: Text('Ad', style: TextStyle(fontWeight: FontWeight.w600)),
          onSort: (i, asc) => _sortData(i, asc),
        ),
        DataColumn(
          label: Text('Fiyat', style: TextStyle(fontWeight: FontWeight.w600)),
          numeric: true,
          onSort: (i, asc) => _sortData(i, asc),
        ),
      ];
    } else {
      return [
        DataColumn(
          label: Text('Stok Kodu', style: TextStyle(fontWeight: FontWeight.w600)),
          onSort: (i, asc) => _sortData(i, asc),
        ),
        DataColumn(
          label: Text('Stok Adı', style: TextStyle(fontWeight: FontWeight.w600)),
          onSort: (i, asc) => _sortData(i, asc),
        ),
        DataColumn(
          label: Text('Grup', style: TextStyle(fontWeight: FontWeight.w600)),
          onSort: (i, asc) => _sortData(i, asc),
        ),
        DataColumn(
          label: Text('Fiyat', style: TextStyle(fontWeight: FontWeight.w600)),
          numeric: true,
          onSort: (i, asc) => _sortData(i, asc),
        ),
        DataColumn(
          label: Text('Stok', style: TextStyle(fontWeight: FontWeight.w600)),
          numeric: true,
          onSort: (i, asc) => _sortData(i, asc),
        ),
        DataColumn(
          label: Text('Durum', style: TextStyle(fontWeight: FontWeight.w600)),
          onSort: (i, asc) => _sortData(i, asc),
        ),
      ];
    }
  }
}

class StockItem {
  final String code, name, group, barcode, description;
  final double price;
  final int stockLevel;
  final bool isActive;

  StockItem({
    required this.code, required this.name, required this.group,
    required this.price, required this.stockLevel, required this.barcode,
    required this.description, required this.isActive,
  });
}

class StockDataSource extends DataTableSource {
  final List<StockItem> stocks;
  final StockItem? selectedStock;
  final Function(StockItem?) onSelectionChanged;
  final String searchQuery;

  StockDataSource({
    required this.stocks, required this.selectedStock,
    required this.onSelectionChanged, required this.searchQuery,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= stocks.length) return null;
    final stock = stocks[index];
    final isMobile = true; // Will be determined by caller
    
    return DataRow(
      selected: selectedStock?.code == stock.code,
      onSelectChanged: (selected) {
        onSelectionChanged(selected == true ? stock : null);
      },
      cells: _buildCells(stock),
    );
  }

  List<DataCell> _buildCells(StockItem stock) {
    // Simplified for mobile and desktop compatibility
    return [
      DataCell(Text(stock.code, style: TextStyle(fontSize: 13))),
      DataCell(Text(stock.name, style: TextStyle(fontSize: 13))),
      DataCell(Text(stock.group, style: TextStyle(fontSize: 13))),
      DataCell(Text('₺${stock.price.toStringAsFixed(2)}', 
        style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500))),
      DataCell(Text('${stock.stockLevel}', style: TextStyle(fontSize: 13))),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: stock.isActive ? Colors.green.shade100 : Colors.red.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            stock.isActive ? 'Aktif' : 'Pasif',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: stock.isActive ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => stocks.length;
  @override
  int get selectedRowCount => selectedStock != null ? 1 : 0;
} 