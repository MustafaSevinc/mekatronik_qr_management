import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mekatronik_qr_management/services/store_service.dart';
import 'package:mekatronik_qr_management/utils/constants.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';
import 'package:mekatronik_qr_management/widgets/popup.dart';

class ChecklistEmployee extends StatefulWidget {
  const ChecklistEmployee({super.key}); // Fixed the constructor

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
    print(formattedDate);
    DocumentSnapshot<Map<String, dynamic>> puantajSnapshot =
        await StoreService.collection(path: 'puantaj').doc(formattedDate).get()
            as DocumentSnapshot<Map<String, dynamic>>;

    if (!puantajSnapshot.exists) {
      print('Belirtilen tarih için doküman bulunamadı.');
      return; // ya da uygun bir hata işleme mekanizması kullanabilirsiniz.
    }

    var data = puantajSnapshot.data() as Map<String, dynamic>;

    if (!data.containsKey('users')) {
      print('Doküman verisi eksik veya yanlış.');
      return; // ya da uygun bir hata işleme mekanizması kullanabilirsiniz.
    }

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
        print(entryList[j]['uid']);
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
        body: const Center(
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
          loginService("", "");
        },
        child: const Icon(Icons.send_rounded),
      ),
    );
  }

  Future<dynamic> loginService(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    List mails = [];
    for (var item in selectedItems) {
      if (item.get('email') != null && item.get('email') != 'empty@mail.com') {
        mails.add(item.get('email'));
      }
    }
    for (String mail in mails) {
      // Tam URL'yi oluştur
      String loginUrl =
          "${Constants.loginUrl}?email=$mail&title=${Constants.savunmaMailTitle}&icerik=${Constants.savunmaMailText}";
      // API isteğini gerçekleştir
      http.Response response = await http.get(Uri.parse(loginUrl));
      try {
        // Başarılı cevabı al ve işle
        if (response.statusCode == 200) {
        } else {
          popUp(context, 'Başarısız', '$mail adresine mail gönderilemedi');
        }
      } catch (e) {
        // Hata durumu işlemleri
      }
    }
    setState(() {
      _isLoading = false;
    });
    popUp(context, 'Başarılı', 'Savunma Mailler, Gönderildi');
  }
}
