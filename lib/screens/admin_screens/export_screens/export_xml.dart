import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:xml/xml.dart' as xml;

import '../../../widgets/custom_elevated_button.dart';

class ExportXmlScreen extends StatefulWidget {
  const ExportXmlScreen({super.key});

  @override
  _ExportXmlScreenState createState() => _ExportXmlScreenState();
}

class _ExportXmlScreenState extends State<ExportXmlScreen> {
  bool _isExporting = false;

  Future<void> _exportDataToXml() async {
    setState(() {
      _isExporting = true;
    });

    // Fetch data from Firestore
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    // Convert data to XML
    /*final xmlBuilder = xml.XmlBuilder();
    xmlBuilder.processing('xml', 'version="1.0"');
    xmlBuilder.element('root', nest: () {
      for (final doc in snapshot.docs) {
        xmlBuilder.element('item', nest: () {
          xmlBuilder.element('id', nest: doc.id);
          xmlBuilder.element('name', nest: doc['name']);
          xmlBuilder.element('password', nest: doc['password']);
          // Add more fields as needed
        });
      }
    });*/
    //final xmlString = xmlBuilder.buildDocument().toXmlString(pretty: true);

    // Save XML to file
    final directory = await getDownloadsDirectory();

    final file = File('${directory?.path}/data.xml');
    debugPrint(directory!.path);
    // await file.writeAsString(xmlString);

    setState(() {
      _isExporting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isExporting
            ? const CircularProgressIndicator()
            : CustomElevatedButton(
                onPressed: _exportDataToXml,
                buttonText: 'Export to XML',
              ),
      ),
    );
  }
}
