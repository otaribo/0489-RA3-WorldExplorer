import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountriesService {
  Future<Country> getCountryByName(String name) async {
    try {
      final url = Uri.parse('https://restcountries.com/v3.1/name/$name?fullText=false');
      // E6: Timeout (petició >10s)
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return Country.fromJson(data.first);
      } else if (response.statusCode == 404) {
        // E6: País no trobat
        throw Exception('404: No s\'ha trobat el país "$name". Prova en anglès.');
      } else {
        throw Exception('Error del servidor al cercar el país.');
      }
    } on SocketException {
      // E6: Sense connexió a Internet
      throw Exception('No hi ha connexió a Internet. Comprova la xarxa.');
    } on TimeoutException {
      // E6: Timeout
      throw Exception('La petició ha trigat massa. Prova-ho de nou.');
    } on FormatException {
      // E6: Resposta malformada
      throw Exception('Error del servidor (Resposta malformada). Prova-ho més tard.');
    }
  }
}