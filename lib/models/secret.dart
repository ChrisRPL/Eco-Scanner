class Secret {
  final String apiKey;
  final String idKey;

  Secret({this.apiKey = "", this.idKey = ""});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(apiKey: jsonMap["api_key"], idKey: jsonMap["id_key"]);
  }
}
