import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/screens/admin_screens/export_screens/export_qr.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';
import 'package:mekatronik_qr_management/widgets/custom_icon_button.dart';
import 'package:mekatronik_qr_management/widgets/popup.dart';

class ExportMainScreen extends StatefulWidget {
  const ExportMainScreen({super.key});

  @override
  _ExortXlsxScreenState createState() => _ExortXlsxScreenState();
}

class _ExortXlsxScreenState extends State<ExportMainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appBarBodyColor,
      key: _scaffoldMessengerKey,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomIconButton(
                text: 'Export',
                onPressed: _onExportPressed,
                iconData: Icons.download,
              ),
              SizedBox(height: 40),
              CustomIconButton(
                text: 'QR Codes',
                onPressed: _onQRPressed,
                iconData: Icons.download,
              ),
            ]),
      ),
    );
  }

  Future<void> _onExportPressed() async {
    popUp(context, "UNDER DEVELOPMENT",
        "Bu özellik henüz geliştirilme aşamasındadır.");
  }
/*
  Future<void> _onExportPressed() async {
    final Excel excel = Excel.createExcel();

    final Sheet sheetObject = excel["Sheet1"];

    CellStyle cellStyle = CellStyle(
        backgroundColorHex: '#1AFF1A',
        fontFamily: getFontFamily(FontFamily.Calibri));

    cellStyle.underline = Underline.Single;

    List users = [];
    QuerySnapshot<Map<String, dynamic>> collection =
        await StoreService.CollectionReference(path: 'users');
    collection.docs.forEach((element) {
      users.add(element);
    });

    List puantajList = [];
    QuerySnapshot<Map<String, dynamic>> collection2 =
        await StoreService.CollectionReference(path: 'puantaj');
    collection2.docs.forEach((element) {
      puantajList.add(element);
    });

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    // Reference to the parent collection
    CollectionReference parentCollection =
        FirebaseFirestore.instance.collection('puantaj');

    // Get documents from the parent collection
    QuerySnapshot snapshot = await parentCollection.get();

    // Iterate through each document in the collection
      // Get the data (fields) of the document
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Print each field in the document
      data.forEach((key, value) {
        print('$key: $value');
      });

      print('--------------------');
    }

    var column = 7;
    var row = 15;
    for (QueryDocumentSnapshot<Map<String, dynamic>> month in puantajList) {
      var cell = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
    }
  }
*/

  void _onQRPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExportQRScreen(),
      ),
    );
  }
}
