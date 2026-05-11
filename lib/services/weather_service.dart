import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  Future<Weather> getCurrentWeather(double lat, double lon) async {
    try {
      // Afegim paràmetres daily per l'Extensió E2
      final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Weather.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtenir la meteorologia.');
      }
    } on SocketException {
      throw Exception('Sense connexió a Internet.');
    } on TimeoutException {
      throw Exception('Timeout al carregar el temps.');
    }
  }
}