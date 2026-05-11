import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/countries_service.dart';
import '../main.dart'; // IMPORTANTE: Acceso a WorldExplorerApp
import 'detail_screen.dart';
import 'favorites_screen.dart'; // IMPORTANTE: Acceso a la nueva pantalla de favoritos

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final CountriesService _countriesService = CountriesService();
  bool _isLoading = false;
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('search_history') ?? [];
    });
  }

  void _saveToHistory(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _history.remove(query);
    _history.insert(0, query);
    if (_history.length > 5) _history = _history.sublist(0, 5); // Máximo 5
    await prefs.setStringList('search_history', _history);
    setState(() {});
  }

  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() { _history = []; });
  }

  void _searchCountry(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final country = await _countriesService.getCountryByName(query);
      _saveToHistory(query);
      
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => DetailScreen(country: country),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          action: SnackBarAction(label: 'Reintentar', onPressed: () => _searchCountry(query)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Leemos el estado actual de los grados desde el main
    final isFahrenheit = WorldExplorerApp.appKey.currentState?.isFahrenheit ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('WorldExplorer'),
        actions: [
          // Botón de Favoritos (E1)
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen())),
            tooltip: 'Els meus favorits',
          ),
          // Botón de Unidades de Temperatura (E5)
          IconButton(
            icon: Text(
              isFahrenheit ? 'ºF' : 'ºC',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onPressed: () {
              // Cambiamos la unidad
              WorldExplorerApp.appKey.currentState?.toggleUnits();
              
              // Forzamos un setState para que el icono (texto) se actualice al instante
              setState(() {}); 
              
              final isF = WorldExplorerApp.appKey.currentState?.isFahrenheit ?? false;
              // Mostramos el mensaje emergente
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Unitat canviada a ${isF ? "Fahrenheit (ºF)" : "Celsius (ºC)"}'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Canviar unitats',
          ),
          // Botón de Modo Oscuro/Claro (E5)
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => WorldExplorerApp.appKey.currentState?.toggleTheme(),
            tooltip: 'Mode fosc/clar',
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Cerca un país (ex: Japan)',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchCountry(_controller.text),
                ),
              ),
              onSubmitted: _searchCountry,
            ),
            SizedBox(height: 10),
            if (_history.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Últimes cerques:', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: _clearHistory, child: Text('Esborrar'))
                ],
              ),
              Wrap(
                spacing: 8.0,
                children: _history.map((h) => ActionChip(
                  label: Text(h),
                  onPressed: () {
                    _controller.text = h;
                    _searchCountry(h);
                  },
                )).toList(),
              )
            ],
            Spacer(),
            if (_isLoading) CircularProgressIndicator(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}