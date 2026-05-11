import 'package:flutter/material.dart';

class DailyWeather {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int weathercode;

  DailyWeather({required this.date, required this.maxTemp, required this.minTemp, required this.weathercode});

  IconData get icon {
    if (weathercode == 0) return Icons.wb_sunny;
    if (weathercode >= 1 && weathercode <= 3) return Icons.cloud;
    if (weathercode >= 45 && weathercode <= 48) return Icons.foggy;
    if (weathercode >= 51 && weathercode <= 67) return Icons.water_drop;
    if (weathercode >= 71 && weathercode <= 77) return Icons.ac_unit;
    if (weathercode >= 95) return Icons.flash_on;
    return Icons.wb_cloudy;
  }
}

class Weather {
  final double temperature;
  final double windspeed;
  final int weathercode;
  final List<DailyWeather> dailyForecast; // Extensión E2

  Weather({required this.temperature, required this.windspeed, required this.weathercode, required this.dailyForecast});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current_weather'];
    final daily = json['daily'];

    List<DailyWeather> forecast = [];
    if (daily != null) {
      for (int i = 0; i < (daily['time'] as List).length; i++) {
        forecast.add(DailyWeather(
          date: daily['time'][i],
          maxTemp: daily['temperature_2m_max'][i].toDouble(),
          minTemp: daily['temperature_2m_min'][i].toDouble(),
          weathercode: daily['weathercode'][i],
        ));
      }
    }

    return Weather(
      temperature: currentWeather['temperature'].toDouble(),
      windspeed: currentWeather['windspeed'].toDouble(),
      weathercode: currentWeather['weathercode'],
      dailyForecast: forecast,
    );
  }

  String get condition {
    if (weathercode == 0) return 'Clar / Assolellat';
    if (weathercode >= 1 && weathercode <= 3) return 'Parcialment ennuvolat';
    if (weathercode >= 51 && weathercode <= 67) return 'Pluja';
    if (weathercode >= 71 && weathercode <= 77) return 'Neu';
    if (weathercode >= 95) return 'Tempesta';
    return 'Desconegut';
  }
}