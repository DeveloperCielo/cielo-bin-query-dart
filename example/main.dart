import 'package:cielo_bin_query/cielo_bin_query.dart';

void main(List<String> arguments) async {
  var binquery = CieloBinQuery(
      clientId: "YOUR-CLIENT-ID",
      clientSecret: "YOUR-CLIENT-SECRET",
      merchantId: "YOUR-MERCHANT-ID",
      environment: Environment.SANDBOX);

  var result = await binquery.query("410715");
  print("Status Code: ${result.statusCode}");

  if (result.binQueryResponse != null) {
    print("Status: ${result.binQueryResponse.status}");
    print("Provider: ${result.binQueryResponse.provider}");
    print("Card Type: ${result.binQueryResponse.cardType}");
    print("Foreign Card: ${result.binQueryResponse.foreignCard}");
    print("Corporate Card: ${result.binQueryResponse.corporateCard}");
    print("Issuer: ${result.binQueryResponse.issuer}");
    print("Issuer Code: ${result.binQueryResponse.issuerCode}");
    print("Pre Paid: ${result.binQueryResponse.prePaid}");
  }

  if (result.errorResponse != null)
    print(result.errorResponse.map((e) {
      print("ErrorCode: ${e.code}");
      print("ErrorMessage: ${e.message}");
    }));
}
