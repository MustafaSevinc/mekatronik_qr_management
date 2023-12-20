import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/objects/local_data.dart';
import 'package:mekatronik_qr_management/services/auth_service.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/services/store_service.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'
    show BarcodeFormat, QRViewController, QRView;
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScannerScreen extends StatefulWidget {
  final String action;

  const QRScannerScreen({super.key, required this.action});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;
  late String _result = 'Scanning for QR';
  bool isProcessing = false;

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
      if (!isProcessing && scanData.format == BarcodeFormat.qrcode) {
        _handleQRResult(scanData.code!);
        setState(() {
          isProcessing = true;
        });
      }
    });
  }

  void _handleQRResult(String qrResult) {
    assetsAudioPlayer.open(
      Audio(Constants.soundFilePath),
      autoStart: true,
    );
    setState(() {
      _result = qrResult;
    });

    Future.delayed(Constants.qrReadDelay, () {
      setState(() {
        isProcessing = false;
      });
    });

    _writeResultToFirestoreOrLocal(qrResult);
  }

  void _writeResultToFirestoreOrLocal(String qrResult) async {
    try {
      await _writeResultToFirestore(qrResult);
      await _processPendingLocalData();
    } catch (e) {
      _saveToLocal(qrResult);
    }
  }

  Future<void> _writeResultToFirestore(String qrResult) async {
    var day = DateTime.now().day;
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    var time = DateTime.now().toString().split(' ')[1];
    var data = {
      'time': time,
    };
    StoreService.setData(
        path: '${widget.action}/${'$year.$month'}/$day/$qrResult', data: data);
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
        await AuthService.signInWithEmailAndPassword(
            SharedPref.getString(Constants.userName)!,
            SharedPref.getString(Constants.userPassword)!);
      }
    }

    SharedPref.setStringList(Constants.localResultsKey, localResults);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
