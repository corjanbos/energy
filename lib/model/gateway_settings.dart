

class GatewaySettings {

  GatewaySettings();

  Map<dynamic, String> get getJson => json;

  void setJson(Map<dynamic, String> value) {
    json = value;
  }

  Map<dynamic, String> json = {};
}