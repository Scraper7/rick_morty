import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetWorkInfoImp implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetWorkInfoImp(this.connectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
