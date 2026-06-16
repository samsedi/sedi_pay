/// Contract for checking the device's internet connection status.
abstract class NetworkInfo {
  /// Returns `true` if the device is currently connected to the internet.
  Future<bool> get isConnected;
}
