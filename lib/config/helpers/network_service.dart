import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
