import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../main.dart'; // IMPORTANTE: Importamos main.dart para acceder a WorldExplorerApp

class DetailScreen extends StatefulWidget {
  final Country country;
  const DetailScreen({Key? key, required this.country}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoadingWeather = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _checkFavorite();
  }

  void _fetchWeather() async {
    try {
      final weather = await _weatherService.getCurrentWeather(widget.country.lat, widget.country.lng);
      setState(() { _weather = weather; _isLoadingWeather = false; });
    } catch (e) {
      setState(() { _isLoadingWeather = false; });
    }
  }

  void _checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList('favorites') ?? [];
    setState(() { _isFavorite = favs.contains(widget.country.commonName); });
  }

  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList('favorites') ?? [];
    if (_isFavorite) {
      favs.remove(widget.country.commonName);
    } else {
      favs.add(widget.country.commonName);
    }
    await prefs.setStringList('favorites', favs);
    setState(() { _isFavorite = !_isFavorite; });
  }

  // Conversión de grados
  double _convertTemp(double celsius) {
    final isF = WorldExplorerApp.appKey.currentState?.isFahrenheit ?? false;
    if (isF) return (celsius * 9 / 5) + 32;
    return celsius;
  }
  
  String get _unitString => (WorldExplorerApp.appKey.currentState?.isFahrenheit ?? false) ? 'ºF' : 'ºC';

  @override
  Widget build(BuildContext context) {
    final formatNumber = NumberFormat('#,##0', 'ca_ES');
    final density = widget.country.area > 0 ? widget.country.population / widget.country.area : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.commonName),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.network(widget.country.flagUrl, height: 100),
                    SizedBox(height: 10),
                    Text(widget.country.officialName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ListTile(leading: Icon(Icons.location_city), title: Text('Capital'), subtitle: Text(widget.country.capital)),
                    ListTile(leading: Icon(Icons.people), title: Text('Població'), subtitle: Text('${formatNumber.format(widget.country.population)} hab.')),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              title: Text('Més informació', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                ListTile(title: Text('Idiomes'), subtitle: Text(widget.country.languages)),
                ListTile(title: Text('Monedes'), subtitle: Text(widget.country.currencies)),
                ListTile(title: Text('Fronteres'), subtitle: Text(widget.country.borders)),
              ],
            ),
            SizedBox(height: 10),
            if (_isLoadingWeather) CircularProgressIndicator()
            else if (_weather != null) ...[
              // Meteo Actual (B3 + E5)
              Card(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.blueGrey.shade800 : Colors.blue.shade50,
                child: ListTile(
                  leading: Icon(Icons.thermostat),
                  title: Text('Temps a ${widget.country.capital}'),
                  subtitle: Text('${_convertTemp(_weather!.temperature).toStringAsFixed(1)} $_unitString | Vent: ${_weather!.windspeed} km/h \n${_weather!.condition}'),
                ),
              ),
              SizedBox(height: 10),
              // Previsió 7 dies (E2)
              Text('Previsió 7 dies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _weather!.dailyForecast.length,
                  itemBuilder: (context, index) {
                    final day = _weather!.dailyForecast[index];
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(day.date.substring(5)), // Mostra MM-DD
                            Icon(day.icon, color: Colors.orange),
                            Text('Max: ${_convertTemp(day.maxTemp).toStringAsFixed(1)} $_unitString', style: TextStyle(fontSize: 12)),
                            Text('Min: ${_convertTemp(day.minTemp).toStringAsFixed(1)} $_unitString', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}