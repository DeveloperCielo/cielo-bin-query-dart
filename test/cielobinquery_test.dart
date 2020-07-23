import 'package:cielo_bin_query/cielo_bin_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final String clientId = "YOUR-CLIENT-ID";
  final String clientSecret = "YOUR-CLIENT-SECRET";
  final String merchantId = "YOUR-MERCHANT-ID";

  group("correct credentials", () {
    BinQueryResult result;
    setUp(() async {
      var binquery = CieloBinQuery(
        clientId: clientId,
        clientSecret: clientSecret,
        merchantId: merchantId,
        environment: Environment.SANDBOX,
      );
      result = await binquery.query("410715");
    });

    test("returns status code 200", () {
      expect(result.statusCode, 200);
    });

    test('returns bin query response', () {
      expect(result.binQueryResponse, isNotNull);
    });

    test('returns status', () {
      expect(result.binQueryResponse.status, isNotNull);
    });

    test('returns provider', () {
      expect(result.binQueryResponse.provider, isNotNull);
    });

    test('returns card type', () {
      expect(result.binQueryResponse.cardType, isNotNull);
    });

    test('returns foreign card', () {
      expect(result.binQueryResponse.foreignCard, isNotNull);
    });

    test('returns corporate card', () {
      expect(result.binQueryResponse.corporateCard, isNotNull);
    });

    test('returns issuer', () {
      expect(result.binQueryResponse.issuer, isNotNull);
    });

    test('returns issuer code', () {
      expect(result.binQueryResponse.issuerCode, isNotNull);
    });
  });

  group("incorrect bin", () {
    BinQueryResult result;
    setUp(() async {
      var binquery = CieloBinQuery(
        clientId: clientId,
        clientSecret: clientSecret,
        merchantId: merchantId,
        environment: Environment.SANDBOX,
      );
      result = await binquery.query("ABC");
    });

    test("returns status code 400", () {
      expect(result.statusCode, 400);
    });

    test("returns error response", () {
      expect(result.errorResponse, isNotEmpty);
    });

    test("returns 217 as error code", () {
      expect(result.errorResponse[0].code, "217");
    });

    test("returns error message", () {
      expect(result.errorResponse[0], isNotNull);
    });
  });
  
  group("incorrect credentials", () {
    BinQueryResult result;
    setUp(() async {
      var binquery = CieloBinQuery(
        clientId: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE",
        clientSecret: "9999999999999999999999999999999999999999999=",
        merchantId: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE",
        environment: Environment.SANDBOX,
      );
      result = await binquery.query("410715");
    });

    test("returns status code 400", () {
      expect(result.statusCode, 400);
    });

    test("returns error response", () {
      expect(result.errorResponse, isNotEmpty);
    });

    test("returns invalid_client as error code", () {
      expect(result.errorResponse[0].code, "invalid_client");
    });

    test("returns error message", () {
      expect(result.errorResponse[0], isNotNull);
    });
  });
}
