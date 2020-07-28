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

    test("should return status code 200", () {
      expect(result.statusCode, 200);
    });

    test('should return bin query response', () {
      expect(result.binQueryResponse, isNotNull);
    });

    test('should return status', () {
      expect(result.binQueryResponse.status, isNotNull);
    });

    test('should return provider', () {
      expect(result.binQueryResponse.provider, isNotNull);
    });

    test('should return card type', () {
      expect(result.binQueryResponse.cardType, isNotNull);
    });

    test('should return foreign card', () {
      expect(result.binQueryResponse.foreignCard, isNotNull);
    });

    test('should return corporate card', () {
      expect(result.binQueryResponse.corporateCard, isNotNull);
    });

    test('should return issuer', () {
      expect(result.binQueryResponse.issuer, isNotNull);
    });

    test('should return issuer code', () {
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

    test("should return status code 400", () {
      expect(result.statusCode, 400);
    });

    test("should return error response", () {
      expect(result.errorResponse, isNotEmpty);
    });

    test("should return 217 as error code", () {
      expect(result.errorResponse[0].code, "217");
    });

    test("should return error message", () {
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

    test("should return status code 400", () {
      expect(result.statusCode, 400);
    });

    test("should return error response", () {
      expect(result.errorResponse, isNotEmpty);
    });

    test("should return invalid_client as error code", () {
      expect(result.errorResponse[0].code, "invalid_client");
    });

    test("should return error message", () {
      expect(result.errorResponse[0].message, isNotNull);
    });
  });
}
