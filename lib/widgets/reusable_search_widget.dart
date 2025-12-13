import 'package:flutter/material.dart';

class ReusableSearchPage extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(String) searchFunction;
  final Widget Function(Map<String, dynamic>) itemBuilder;
  final String hintText;
  final String emptyMessage;
  final String initialMessage;
  final Color? primaryColor;

  const ReusableSearchPage({
    Key? key,
    required this.searchFunction,
    required this.itemBuilder,
    this.hintText = 'ابحث...',
    this.emptyMessage = 'لا توجد نتائج',
    this.initialMessage = 'ابدأ بالبحث',
    this.primaryColor,
  }) : super(key: key);

  @override
  State<ReusableSearchPage> createState() => _ReusableSearchPageState();
}

class _ReusableSearchPageState extends State<ReusableSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    await Future.delayed(Duration(milliseconds: 300));

    try {
      final results = await widget.searchFunction(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print('❌ خطأ في البحث: $e');
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _hasSearched = false;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'البحث',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // شريط البحث
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: _clearSearch,
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),

          // النتائج
          Expanded(
            child: _hasSearched
                ? _searchResults.isEmpty && !_isSearching
                ? _buildEmptyState()
                : _buildResultsList()
                : _buildInitialState(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            widget.initialMessage,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            widget.emptyMessage,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _isSearching ? _searchResults.length + 1 : _searchResults.length,
      itemBuilder: (context, index) {
        if (_isSearching && index == _searchResults.length) {
          return Center(child: CircularProgressIndicator());
        }

        final item = _searchResults[index];
        return widget.itemBuilder(item);
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}