import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/objects/local_data.dart';
import 'package:mekatronik_qr_management/services/auth_service.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/services/store_service.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'
    show BarcodeFormat, QRViewController, QRView;

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
  Map<String, dynamic> entryList = {'users': []};

  @override
  void initState() {
    super.initState();
    _fetchEntry();
  }

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
    if (widget.action == "yemek") {
      Map data = {
        'time': time,
      };
      StoreService.setData(path: 'yemek/${'$day.$month.$year'}', data: data);
    }

    bool isExist = false;
    for (Map<String, dynamic> entry in entryList['users']) {
      if (entry['uid'] == qrResult) {
        isExist = true;
        if (entry['cikis'].length >= entry['giris'].length &&
            widget.action == 'giris') {
          entry['giris'].add(time);
        } else if (entry['cikis'].length < entry['giris'].length &&
            widget.action == 'cikis') {
          entry['cikis'].add(time);
        }
      }
    }
    if (!isExist && widget.action == 'giris') {
      entryList['users'].add({
        'uid': qrResult,
        'giris': [time],
        'cikis': [],
      });
      debugPrint("-----------------------------------------------" +
          entryList.toString() +
          'puantaj/${'$day.$month.$year'}/$qrResult');
    }
    StoreService.setData(
        path: 'puantaj/${'$day.$month.$year'}', data: entryList);
  }

  void _saveToLocal(String qrResult) {
    final List<LocalData> localResults =
        SharedPref.getLocalDataList(Constants.localResultsKey);
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
    final localResults = SharedPref.getLocalDataList(Constants.localResultsKey);

    for (final result in localResults) {
      try {
        await _writeResultToFirestore(result.uid);
        localResults.remove(result);
      } catch (e) {
        await AuthService.signInWithEmailAndPassword(
            SharedPref.getString(Constants.userName)!,
            SharedPref.getString(Constants.userPassword)!);
      }
    }

    SharedPref.setLocalDataList(Constants.localResultsKey, localResults);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _fetchEntry() async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year.toString()}";
    DocumentSnapshot puantajSnapshot =
        await StoreService.collection(path: 'puantaj').doc(formattedDate).get();
    debugPrint("313131313" + puantajSnapshot.data().toString());
    //BURANIN ALTINDA SIKINTI VAR

    Map<String, dynamic> data = puantajSnapshot.data() as Map<String, dynamic>;
    List<dynamic> usersArray = (data['users'] as List<dynamic>);
    debugPrint("313131313" + entryList.toString());

    setState(() {
      entryList['users'] = usersArray;
      debugPrint("313131313" + entryList.toString());
    });
  }
}
