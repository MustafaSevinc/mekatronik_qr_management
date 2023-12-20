import 'package:flutter/material.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';

import '../../../objects/employee.dart';

class ChecklistEmployee extends StatefulWidget {
  const ChecklistEmployee({super.key});

  @override
  State<ChecklistEmployee> createState() => _ChecklistEmployeeState();
}

class _ChecklistEmployeeState extends State<ChecklistEmployee> {
  List employeeList = [
    Employee(
      name: "",
      surname: "",
      id: "",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(8),
    itemCount: employeeList.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        child: Center(child: Text('Entry ${employeeList[index]}')),
      );
    },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
