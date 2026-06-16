/// A utility class for detecting Nigerian network providers from phone number prefixes.
class NigerianNetworkDetector {
  NigerianNetworkDetector._(); // Prevent instantiation

  /// Returns the name of the network provider for the given [phoneNumber],
  /// or an empty string if it cannot be detected.
  static String detect(String phoneNumber) {
    if (phoneNumber.length < 4) return '';

    final prefix = phoneNumber.substring(0, 4);

    const mtnPrefixes = ['0803', '0806', '0813', '0816', '0703', '0706', '0903', '0906', '0913'];
    const airtelPrefixes = ['0802', '0808', '0812', '0701', '0708', '0902', '0907', '0912'];
    const gloPrefixes = ['0805', '0807', '0811', '0815', '0705', '0905'];
    const mobilePrefixes = ['0809', '0817', '0818', '0909', '0908'];

    if (mtnPrefixes.contains(prefix)) return 'MTN';
    if (airtelPrefixes.contains(prefix)) return 'Airtel';
    if (gloPrefixes.contains(prefix)) return 'Glo';
    if (mobilePrefixes.contains(prefix)) return '9mobile';

    return '';
  }
}
