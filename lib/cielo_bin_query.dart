library cielo_bin_query;

import 'dart:convert';

import 'package:cielo_oauth/cielo_oauth.dart' as oauth;
import 'package:http/http.dart' as http;

import 'src/bin_query_response.dart';
import 'src/bin_query_result.dart';
import 'src/environment.dart';
import 'src/error_response.dart';

export 'src/bin_query_response.dart';
export 'src/bin_query_result.dart';
export 'src/environment.dart';
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
    this._url = _defineUrl(environment);
    this._oAuthEnvironment = _defineOAuthEnvironment(environment);
  }

  Future<BinQueryResult> query(String bin) async {
    oauth.AccessTokenResult accessTokenResult = await _getOAuthResult(
        this.clientId, this.clientSecret, _oAuthEnvironment);

    BinQueryResult errorResult = _checkOAuthErrors(accessTokenResult);
    if (errorResult != null) return errorResult;

    final token = accessTokenResult.accessTokenResponse?.accessToken;

    final Uri url = Uri.https(this._url, "/1/cardBin/" + bin);

    final String sdkName = "cielo_bin_query";
    final String sdkVersion = "1.0.1";

    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'x-sdk-version': '$sdkName\_dart@$sdkVersion',
        'MerchantId': this.merchantId,
      },
    );
    return _checkResponse(response, accessTokenResult);
  }
}

Future<oauth.AccessTokenResult> _getOAuthResult(String clientId,
    String clientSecret, oauth.Environment oAuthEnvironment) async {
  var oauthClient = oauth.OAuth(
    clientId: clientId,
    clientSecret: clientSecret,
    environment: oAuthEnvironment,
  );
  return await oauthClient.getToken();
}

dynamic _checkOAuthErrors(oauth.AccessTokenResult accessTokenResult) {
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
  return null;
}

BinQueryResult _checkResponse(
    http.Response response, oauth.AccessTokenResult accessTokenResult) {
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
        errors =
            jsonDecoded.map((error) => ErrorResponse.fromJson(error)).toList();
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

String _defineUrl(Environment environment) {
  return environment == Environment.SANDBOX
      ? 'apiquerysandbox.cieloecommerce.cielo.com.br'
      : 'apiquery.cieloecommerce.cielo.com.br';
}

oauth.Environment _defineOAuthEnvironment(Environment environment) {
  return environment == Environment.SANDBOX
      ? oauth.Environment.SANDBOX
      : oauth.Environment.PRODUCTION;
}
