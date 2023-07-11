import 'dart:convert';

class Country {
  int id;
  String name;
  String shortName;
  int code;

  Country({this.id = 0, this.name, this.shortName, this.code});

  factory Country.fromJson(Map<String, dynamic> map) {
    return Country(
        id: map["id"], name: map["name"], shortName: map["short_name"], code: map["code"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "short_name": shortName, "code": code};
  }

  @override
  String toString() {
    return 'Country{id: $id, name: $name, short_name: $shortName, code: $code}';
  }

}

List<Country> countryFromJson(String jsonData) {
  final data = json.decode(jsonData);
  final dataList = data['data'];
  return List<Country>.from(dataList.map((item) => Country.fromJson(item)));
}

String countryToJson(Country data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
