import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final DocumentReference<Map<String, dynamic>> ref = _db.doc(path);
    print('$path: $data');
    await ref.set(data, SetOptions(merge: merge));
  }

  static CollectionReference({required String path}) {
    final DocumentReference<Map<String, dynamic>> ref = _db.doc(path);
    return ref.get();
  }
}
