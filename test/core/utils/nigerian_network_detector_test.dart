import 'package:flutter_test/flutter_test.dart';
import 'package:sedi_pay/core/utils/nigerian_network_detector.dart';

void main() {
  group('NigerianNetworkDetector', () {
    test('returns empty string for short numbers', () {
      expect(NigerianNetworkDetector.detect('080'), '');
      expect(NigerianNetworkDetector.detect(''), '');
    });

    test('detects MTN prefixes correctly', () {
      expect(NigerianNetworkDetector.detect('08031234567'), 'MTN');
      expect(NigerianNetworkDetector.detect('08060000000'), 'MTN');
      expect(NigerianNetworkDetector.detect('09139999999'), 'MTN');
    });

    test('detects Airtel prefixes correctly', () {
      expect(NigerianNetworkDetector.detect('08021234567'), 'Airtel');
      expect(NigerianNetworkDetector.detect('07010000000'), 'Airtel');
      expect(NigerianNetworkDetector.detect('09129999999'), 'Airtel');
    });

    test('detects Glo prefixes correctly', () {
      expect(NigerianNetworkDetector.detect('08051234567'), 'Glo');
      expect(NigerianNetworkDetector.detect('08110000000'), 'Glo');
      expect(NigerianNetworkDetector.detect('09059999999'), 'Glo');
    });

    test('detects 9mobile prefixes correctly', () {
      expect(NigerianNetworkDetector.detect('08091234567'), '9mobile');
      expect(NigerianNetworkDetector.detect('08180000000'), '9mobile');
      expect(NigerianNetworkDetector.detect('09099999999'), '9mobile');
    });

    test('returns empty string for unknown prefixes', () {
      expect(NigerianNetworkDetector.detect('08041234567'), '');
      expect(NigerianNetworkDetector.detect('07040000000'), '');
      expect(NigerianNetworkDetector.detect('99999999999'), '');
    });
  });
}
