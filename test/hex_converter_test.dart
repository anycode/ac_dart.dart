import 'package:ac_dart/ac_dart.dart';
import 'package:test/test.dart';
import 'package:hex/hex.dart';

void main() {
  group('Test HexConverter', () {
    test('Test conversion from hex string to bytes', () {
      const HexConverter converter = HexConverter();
      final List<int> bytes = [10, 20, 30, 40, 50];
      final String hexString = '\\x0a141e2832';

      expect(converter.fromPgSql(hexString), equals(bytes));
    });

    test('Test conversion from bytes to hex string', () {
      const HexConverter converter = HexConverter();
      final List<int> bytes = [10, 20, 30, 40, 50];
      final String hexString = '\\x0a141e2832';

      expect(converter.toPgSql(bytes), equals(hexString));
    });
  });
}
