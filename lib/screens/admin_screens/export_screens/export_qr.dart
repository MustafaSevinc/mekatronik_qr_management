import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/services/store_service.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';
import 'package:mekatronik_qr_management/widgets/popup.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ExportQRScreen extends StatefulWidget {
  const ExportQRScreen({super.key});

  @override
  State<ExportQRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<ExportQRScreen> {
  final List<List> _texts = [];
  bool _isLoading = true;
  @override
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot usersSnapshot =
        await StoreService.collectionReference(path: 'users');
    for (var doc in usersSnapshot.docs) {
      _texts.add([doc.id, doc.get('name') + ' ' + doc.get('surname')]);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _downloadPDF() async {
    popUp(context, "Under Construst", "This feature is under construction.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appBarBodyColor,
      appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,
        title: const Text('QR Kod Oluşturucu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _downloadPDF,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _texts.length,
              itemBuilder: (context, index) => ListTile(
                title: Column(
                  children: [
                    QrImageView(
                      data: _texts[index][0],
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                    const SizedBox(
                        height:
                            8), // Adding a small space between the QR code and the text
                    Text(
                      _texts[index][1], // Or any other text you want to display
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
