import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/services/store_service.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mekatronik_qr_management/widgets/popup.dart';

class ChecklistEmployee extends StatefulWidget {
  const ChecklistEmployee({Key? key})
      : super(key: key); // Fixed the constructor

  @override
  State<ChecklistEmployee> createState() => _ChecklistEmployeeState();
}

class _ChecklistEmployeeState extends State<ChecklistEmployee> {
  List<QueryDocumentSnapshot<Object?>> employeeList =
      []; //employeeList[index].get('name/surname/...').toString()
  List<dynamic> entryList = []; //entryList[index]['giris/cikis/uid'].toString()
  List<QueryDocumentSnapshot<Object?>> diffList = [];
  bool _isLoading = true;
  List<QueryDocumentSnapshot<Object?>> selectedItems = [];
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() async {
    await _fetchEmployeeIds();
    await _fetchEntry();
    _takeDiff();
    setState(() {
      _isLoading = false;
    });
  }

  _fetchEmployeeIds() async {
    List<QueryDocumentSnapshot<Object?>> uids = [];
    QuerySnapshot usersSnapshot =
        await StoreService.collectionReference(path: 'users');
    for (var doc in usersSnapshot.docs) {
      uids.add(doc);
    }
    setState(() {
      employeeList = uids;
    });
  }

  _fetchEntry() async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year.toString()}";
    DocumentSnapshot puantajSnapshot =
        await StoreService.collection(path: 'puantaj').doc(formattedDate).get();

    Map<String, dynamic> data = puantajSnapshot.data() as Map<String, dynamic>;
    List<dynamic> usersArray = (data['users'] as List<dynamic>);
    setState(() {
      entryList = usersArray;
    });
  }

  _takeDiff() {
    bool isExist;
    for (var i = 0; i < employeeList.length; i++) {
      isExist = false;
      for (var j = 0; j < entryList.length; j++) {
        if (employeeList[i].id == entryList[j]['uid']) {
          isExist = true;
        }
      }
      if (!isExist) {
        employeeList[i];
        diffList.add(employeeList[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mekatronik'),
          backgroundColor: CustomColors.appBarColor,
        ),
        backgroundColor: CustomColors.appBarBodyColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: CustomColors.appBarBodyColor,
      appBar: AppBar(
        title: const Text('Mekatronik'),
        backgroundColor: CustomColors.appBarColor,
      ),
      body: ListView.builder(
        itemCount: diffList.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
              diffList[index].get('name') +
                  ' ' +
                  diffList[index].get('surname'),
            ),
            value: selectedItems.contains(diffList[index]),
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  selectedItems.add(diffList[index]);
                } else {
                  selectedItems.remove(diffList[index]);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _performActionsOnSelectedItems();
        },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }

  void _performActionsOnSelectedItems() async {
    setState(() {
      _isLoading = true;
    });
    String username = Constants.mailServiceMail;
    String password = Constants.mailServicePassword;

    final smtpServer = gmail(username, password);
    List mails = [];
    for (var item in selectedItems) {
      if (item.get('email') != null && item.get('email') != 'empty@mail.com') {
        mails.add(item.get('email'));
      }
    }
    debugPrint(mails.toString());
    // Create our message.
    final message = Message()
      ..from = Address(username, 'anonim savunmaGonderici')
      ..recipients.addAll(mails)
      ..subject = 'Savunma Maili ${DateTime.now()}'
      ..text = Constants.savunmaMailText;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      setState(() {
        _isLoading = false;
      });
      popUp(context, "İşlem Başarılı", "Savunma Mailleri Başarıyla Gönderildi");
    } on MailerException catch (e) {
      setState(() {
        _isLoading = false;
      });
      popUp(context, "İşlem Başarısız", "Savunma Mailleri Gönderilemedi.");
      print(e);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
