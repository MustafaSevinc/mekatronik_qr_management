import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/services/store_service.dart';

class ChecklistEmployee extends StatefulWidget {
  const ChecklistEmployee({super.key});

  @override
  State<ChecklistEmployee> createState() => _ChecklistEmployeeState();
}

class _ChecklistEmployeeState extends State<ChecklistEmployee> {
  List employeeList = [];
  List girisList = [];
  List cikisList = [];
  List result = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchEnter();
    _fetchExit();
  }

  _fetchUsers() async {
    List users = [];
    QuerySnapshot<Map<String, dynamic>> collection =
        await StoreService.CollectionReference(path: 'users');
    collection.docs.forEach((element) {
      users.add(element.id);
    });
    setState(() {
      employeeList = users;
    });
  }

  _fetchEnter() async {
    List users = [];

    var day = DateTime.now().day;
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    QuerySnapshot<Map<String, dynamic>> collection =
        await StoreService.CollectionReference(
            path: 'giris/${'$year.$month'}/$day');

    collection.docs.forEach((element) {
      users.add(element.id);
    });
    setState(() {
      girisList = users;
    });
  }

  _fetchExit() async {
    List users = [];

    var day = DateTime.now().day;
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    QuerySnapshot<Map<String, dynamic>> collection =
        await StoreService.CollectionReference(
            path: 'cikis/${'$year.$month'}/$day');
    collection.docs.forEach((element) {
      users.add(element.id);
    });
    setState(() {
      cikisList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    Set girisSet = girisList.toSet();
    Set cikisSet = cikisList.toSet();

    Set intersection = girisSet.intersection(cikisSet);

    result = employeeList;
    result = employeeList.where((e) => !intersection.contains(e)).toList();
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: result.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.white,
          child: Center(child: Text('${result[index]}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
