import 'dart:convert';

class Tokenization {
  final String accessToken;
  final String refreshToken;
  Tokenization({required this.accessToken, required this.refreshToken});

  Map<String, String> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory Tokenization.fromMap(Map<String, dynamic> map) {
    return Tokenization(
      accessToken: map['access_token'] ?? '',
      refreshToken: map['refresh_token'] ?? '',
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory Tokenization.fromJson(String json) {
    return Tokenization.fromMap(jsonDecode(json));
  }
}
