import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/countries_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];
  final CountriesService _service = CountriesService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  // Eliminar favorito directamente desde la lista
  void _removeFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _favorites.remove(name);
    await prefs.setStringList('favorites', _favorites);
    setState(() {}); // Actualiza la interfaz para que desaparezca
  }

  // Abrir el país obteniendo sus datos de la API de nuevo
  void _openCountry(String name) async {
    setState(() => _isLoading = true);
    
    try {
      final country = await _service.getCountryByName(name);
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      
      // Al navegar, le decimos que cuando VUELVA de la pantalla de detalles,
      // recargue la lista de favoritos (por si le hemos quitado la estrella allí)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(country: country)),
      ).then((_) => _loadFavorites());
      
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al carregar el país. Comprova la connexió.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Els meus Favorits')),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : _favorites.isEmpty
          ? Center(child: Text('Encara no tens països preferits.', style: TextStyle(fontSize: 16)))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final countryName = _favorites[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.star, color: Colors.amber),
                    title: Text(countryName, style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeFavorite(countryName),
                      tooltip: 'Eliminar de favorits',
                    ),
                    onTap: () => _openCountry(countryName), // Al tocar la fila, abre el país
                  ),
                );
              },
            ),
    );
  }
}