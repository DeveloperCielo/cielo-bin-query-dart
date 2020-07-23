class ErrorResponse {
  final String code;
  final String message;

  ErrorResponse({this.code, this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    code: (json["Code"] != null) ? json["Code"].toString() : "unknown_error",
    message: (json["Message"] != null) ? json["Message"] : "Unknown Error",
  );
}
