library cielo_bin_query;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cielo_oauth/cielo_oauth.dart' as oauth;

import 'src/environment.dart';
import 'src/bin_query_result.dart';
import 'src/bin_query_response.dart';
import 'src/error_response.dart';

export 'src/environment.dart';
export 'src/bin_query_result.dart';
export 'src/bin_query_response.dart';
export 'src/error_response.dart';

class CieloBinQuery {
  final String clientId;
  final String clientSecret;
  final String merchantId;
  final Environment environment;
  oauth.Environment _oAuthEnvironment;
  String _url;

  CieloBinQuery({
    this.clientId,
    this.clientSecret,
    this.merchantId,
    this.environment = Environment.SANDBOX,
  }) {
    if (environment == Environment.SANDBOX) {
      this._url = 'apiquerysandbox.cieloecommerce.cielo.com.br';
      this._oAuthEnvironment = oauth.Environment.SANDBOX;
    } else {
      this._url = 'apiquery.cieloecommerce.cielo.com.br';
      this._oAuthEnvironment = oauth.Environment.PRODUCTION;
    }
  }

  Future<BinQueryResult> query(String bin) async {
    var oauthClient = oauth.OAuth(
      clientId: this.clientId,
      clientSecret: this.clientSecret,
      environment: _oAuthEnvironment,
    );

    final accessTokenResult = await oauthClient.getToken();

    if (accessTokenResult.errorResponse != null) {
      return BinQueryResult(
        errorResponse: <ErrorResponse>[
          ErrorResponse(
              code: accessTokenResult.errorResponse?.error,
              message: accessTokenResult.errorResponse?.errorDescription),
        ],
        statusCode: accessTokenResult.statusCode,
      );
    }

    if (accessTokenResult.accessTokenResponse?.accessToken == null) {
      return BinQueryResult(
        errorResponse: <ErrorResponse>[
          ErrorResponse(
              code: "unknown_authentication_error",
              message: "Unknown Authentication Error")
        ],
        statusCode: accessTokenResult.statusCode,
      );
    }

    final token = accessTokenResult.accessTokenResponse?.accessToken;
    final Uri url = Uri.https(this._url, "/1/cardBin/" + bin);

    var response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'MerchantId': this.merchantId,
      },
    );
    if (response.statusCode == 200) {
      return BinQueryResult(
        binQueryResponse: BinQueryResponse.fromJson(jsonDecode(response.body)),
        statusCode: response.statusCode,
      );
    } else {
      List<ErrorResponse> errors = <ErrorResponse>[];
      try {
        var jsonDecoded = jsonDecode(response.body);
        if (jsonDecoded is List) {
          errors = jsonDecoded
              .map((error) => ErrorResponse.fromJson(error))
              .toList();
        } else {
          errors.add(ErrorResponse.fromJson(jsonDecoded));
        }
        return BinQueryResult(
          errorResponse: errors,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return BinQueryResult(
          errorResponse: <ErrorResponse>[
            ErrorResponse(
              code: "unknown_error",
              message: "Unknown Error",
            )
          ],
          statusCode: accessTokenResult.statusCode,
        );
      }
    }
  }
}
