import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> setData({
    required String path,
    required dynamic data,
    bool merge = false,
  }) async {
    final DocumentReference<Map<String, dynamic>> ref = _db.doc(path);
    await ref.set(data, SetOptions(merge: merge));
  }

  static CollectionReference collection({required String path}) {
    return _db.collection(path);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> collectionReference({
    required String path,
  }) async {
    return await _db.collection(path).get();
  }
}
