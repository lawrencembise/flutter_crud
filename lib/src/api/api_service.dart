import 'package:flutter_crud_api_sample_app/src/model/country.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "http://localhost:4323/pme/api/v1";
  Client client = Client();

  Future<List<Country>> getCountrys() async {
    final response = await client.post("$baseUrl/countries/list");
    if (response.statusCode == 200) {
      return countryFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createCountry(Country data) async {
    final response = await client.post(
      "$baseUrl/countries/create",
      headers: {"content-type": "application/json"},
      body: countryToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateCountry(Country data) async {
    final response = await client.post(
      "$baseUrl/countries/update",
      headers: {"content-type": "application/json"},
      body: countryToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteCountry(int id) async {
    final response = await client.post(
      "$baseUrl/countries/delete",
      headers: {"content-type": "application/json"},

    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
