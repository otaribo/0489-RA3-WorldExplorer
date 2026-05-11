class Country {
  final String commonName;
  final String officialName;
  final String flagUrl;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final double lat;
  final double lng;
  // E3: Vista detallada
  final String languages;
  final String currencies;
  final String timezones;
  final String borders;
  final double area;

  Country({
    required this.commonName, required this.officialName, required this.flagUrl,
    required this.capital, required this.region, required this.subregion,
    required this.population, required this.lat, required this.lng,
    required this.languages, required this.currencies, required this.timezones,
    required this.borders, required this.area,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<dynamic> latlng = json['capitalInfo']?['latlng'] ?? [0.0, 0.0];
    
    // Parseo seguro para E3
    String langs = json['languages']?.values.join(', ') ?? 'Desconegut';
    String currs = json['currencies']?.values.map((c) => '${c['name']} (${c['symbol']})').join(', ') ?? 'Desconegut';
    String tzones = json['timezones']?.join(', ') ?? 'Desconegut';
    String brders = json['borders']?.join(', ') ?? 'Cap frontera';
    double area = (json['area'] ?? 0).toDouble();

    return Country(
      commonName: json['name']['common'] ?? 'Desconegut',
      officialName: json['name']['official'] ?? 'Desconegut',
      flagUrl: json['flags']['png'] ?? '',
      capital: (json['capital'] as List<dynamic>?)?.first ?? 'Sense capital',
      region: json['region'] ?? 'Sense regió',
      subregion: json['subregion'] ?? 'Sense subregió',
      population: json['population'] ?? 0,
      lat: latlng[0].toDouble(),
      lng: latlng[1].toDouble(),
      languages: langs,
      currencies: currs,
      timezones: tzones,
      borders: brders,
      area: area,
    );
  }
}