import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> getOnline() async {
  
  final List<ConnectivityResult> results =
      await Connectivity().checkConnectivity();
  bool isOnline = results.any((r) => r != ConnectivityResult.none);
  return isOnline;
}
