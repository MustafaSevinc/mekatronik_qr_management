import 'package:workmanager/workmanager.dart';
import 'dart:math';

class BackgroundService {
  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      //var connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = Random()
          .nextBool(); //(connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile);

      if (isConnected) {
        // Internet is available, perform Firestore write
        try {
          // Example: await _writeToFirestore();
        } catch (e) {
          // Handle Firestore write error
          print('Firestore write error: $e');
        }
      } else {
        // No internet connection, handle accordingly
        print('No internet connection');
      }

      return Future.value(true);
    });
  }
}
