import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/objects/local_data.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/services/store_service.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'
    show BarcodeFormat, QRViewController, QRView;
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScannerScreen extends StatefulWidget {
  final String action;

  const QRScannerScreen({super.key, required this.action});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late final AudioPlayer _audioPlayer = AudioPlayer();
  late QRViewController _controller;
  late String _result = 'Scanning for QR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            bottom: 20.0,
            child: Text(_result),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    _controller.scannedDataStream.listen((scanData) {
      if (scanData.format == BarcodeFormat.qrcode) {
        _handleQRResult(scanData.code!);
      }
    });
  }

  void _handleQRResult(String qrResult) {
    _audioPlayer.play(UrlSource('assets/sound/beep.mp3'));
    setState(() {
      _result = qrResult;
      Future.delayed(Constants.qrReadDelay, () {
        _result = 'Scanning for QR';
      });
    });

    _writeResultToFirestoreOrLocal(qrResult);
  }

  void _writeResultToFirestoreOrLocal(String qrResult) async {
    try {
      await _writeResultToFirestore(qrResult);
      // Successfully written to Firestore, check for and process any pending local data
      await _processPendingLocalData();
    } catch (e) {
      // Writing to Firestore failed, save result locally
      _saveToLocal(qrResult);
    }
  }

  Future<void> _writeResultToFirestore(String qrResult) async {
    var data = {
      'result': qrResult,
      'timestamp': FieldValue.serverTimestamp(),
    };
    StoreService.setData(path: 'qr/12.2023/15', data: data);
  }

  void _saveToLocal(String qrResult) {
    final localResults = SharedPref.getLocalDataList(Constants.localResultsKey);
    final LocalData localData = LocalData(
      uid: qrResult,
      action: widget.action,
      date: DateTime.now().toString().split(' ')[0],
      time: DateTime.now().toString().split(' ')[1],
    );
    localResults.add(localData);
    SharedPref.setLocalDataList(Constants.localResultsKey, localResults);
  }

  Future<void> _processPendingLocalData() async {
    final localResults =
        SharedPref.getStringList(Constants.localResultsKey) ?? [];

    for (final result in localResults) {
      try {
        await _writeResultToFirestore(result);
        localResults.remove(result);
      } catch (e) {
        // Handle failure or try again later
      }
    }

    SharedPref.setStringList(Constants.localResultsKey, localResults);
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
