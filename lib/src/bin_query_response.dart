class BinQueryResponse {
  BinQueryResponse(
      {this.status,
      this.provider,
      this.cardType,
      this.foreignCard,
      this.corporateCard,
      this.issuer,
      this.issuerCode,
      this.prePaid});

  String status;
  String provider;
  String cardType;
  bool foreignCard;
  bool corporateCard;
  String issuer;
  String issuerCode;
  bool prePaid;

  factory BinQueryResponse.fromJson(Map<String, dynamic> json) =>
      BinQueryResponse(
        status: json["Status"],
        provider: json["Provider"],
        cardType: json["CardType"],
        foreignCard: json["ForeignCard"],
        corporateCard: json["CorporateCard"],
        issuer: json["Issuer"],
        issuerCode: json["IssuerCode"],
        prePaid: json["PrePaid"],
      );
}
