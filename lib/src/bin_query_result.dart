import 'package:cielo_bin_query/cielo_bin_query.dart';

class BinQueryResult {
  BinQueryResult({this.binQueryResponse, this.errorResponse, this.statusCode});

  final BinQueryResponse binQueryResponse;
  final List<ErrorResponse> errorResponse;
  final int statusCode;
}