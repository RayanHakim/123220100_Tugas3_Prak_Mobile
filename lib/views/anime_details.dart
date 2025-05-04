import 'package:flutter/material.dart';
import 'package:flutter_application_1/network/base_network.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String endpoint;

  const DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetailData(widget.endpoint, widget.id);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Naruto theme background
      appBar: AppBar(
        title: const Text("Info tentang Shinobi tersebut"),
        backgroundColor: const Color(0xFFFF6F00), // Naruto orange
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    "Error loading data: $_errorMessage",
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _detailData != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  (_detailData!['images'] != null &&
                                          _detailData!['images'] is List &&
                                          _detailData!['images'].isNotEmpty)
                                      ? _detailData!['images'][0]
                                      : 'https://placehold.co/600x400',
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildInfoText("Name", _detailData!['name']),
                              _buildInfoText(
                                "Family",
                                (_detailData!['family'] is List)
                                    ? (_detailData!['family'] as List).join(', ')
                                    : 'Unknown',
                              ),
                              _buildInfoText("Debut", _detailData!['debut']),
                              _buildInfoText("Kekkei Genkai", _detailData!['personal']?['kekkeiGenkai']),
                              _buildInfoText("Title", _detailData!['personal']?['title']),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Center(child: Text('No data available')),
    );
  }

  Widget _buildInfoText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFBF360C), // Naruto dark orange
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : 'Unknown',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
