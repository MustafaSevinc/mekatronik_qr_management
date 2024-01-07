import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mekatronik_qr_management/services/store_service.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final CollectionReference users = StoreService.collection(
      path: "users"); // Firestore collection adını buraya ekleyin.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.textButtonColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.appBarColor,
        title: const Text('Mekatronik'),
      ),
      body: StreamBuilder(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var userData = snapshot.data!.docs; // Firestore'dan gelen dökümanlar
          return ListView.builder(
            itemCount: userData.length,
            itemBuilder: (context, index) {
              var user = userData[index].data() as Map<String, dynamic>;
              user['uid'] = userData[index].id;
              // Firestore dökümanı
              return ListTile(
                title: Text(user['name'] +
                    ' ' +
                    user['surname']), // Değiştirilecek alanı belirtin
                subtitle: Text(user['email']),
                onTap: () {
                  // Elemana tıklanınca pop-up açılacak
                  // Pop-up için bir fonksiyon çağırabilirsiniz
                  openPopup(context, user);
                },
              );
            },
          );
        },
      ),
    );
  }

  void openPopup(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            item['name'] + ' ' + item['surname'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: TextEditingController(text: item['id']),
                  decoration: const InputDecoration(labelText: 'TC Kimlik No'),
                  onChanged: (value) {
                    item['id'] = value;
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: item['name']),
                  decoration: const InputDecoration(labelText: 'Ad'),
                  onChanged: (value) {
                    item['name'] = value;
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: item['surname']),
                  decoration: const InputDecoration(labelText: 'Soyad'),
                  onChanged: (value) {
                    item['surname'] = value;
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: item['phone']),
                  decoration: const InputDecoration(labelText: 'Telefon'),
                  onChanged: (value) {
                    item['phone'] = value;
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: item['email']),
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  onChanged: (value) {
                    item['email'] = value;
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: item['password']),
                  decoration: const InputDecoration(labelText: 'Şifre'),
                  onChanged: (value) {
                    item['password'] = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    CollectionReference db =
                        StoreService.collection(path: 'users');
                    db.doc(item['uid']).set(item);
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(135, 21, 255, 0),
                  ),
                  child: const Text('Kaydet'),
                ),
                TextButton(
                  onPressed: () {
                    CollectionReference db =
                        StoreService.collection(path: 'users');
                    db.doc(item['uid']).delete();
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(136, 255, 0, 0),
                  ),
                  child: const Text('Sil'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(136, 255, 255, 255),
                  ),
                  child: const Text('Kapat'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
