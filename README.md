# WorldExplorer 🌍
App educativa desarrollada en Flutter que integra REST Countries y Open-Meteo.

## Respuestas Fase 1 (Investigación APIs)
1. [cite_start]**Endpoint REST Countries:** `https://restcountries.com/v3.1/name/{nom}?fullText=false`[cite: 349]. [cite_start]Retorna datos como `name`, `flags`, `capital`, `region`, `population`, `capitalInfo`, `languages`, `currencies`, `timezones`, `borders`, `area`[cite: 297, 399, 400, 401, 402, 403].
2. [cite_start]**Coordenadas:** Se obtienen del array `latlng` dentro del objeto `capitalInfo`[cite: 298, 362].
3. [cite_start]**Endpoint Open-Meteo:** `https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current_weather=true`[cite: 302, 366]. [cite_start]Acepta parámetros de latitud, longitud y flags de tiempo actual[cite: 366].
4. [cite_start]**Formato JSON:** Objeto principal que contiene un sub-objeto `current_weather` con campos como `temperature`, `windspeed` y `weathercode`[cite: 303, 367].

## Extensiones Implementadas
- [x] B1, B2, B3 (Base Obligatoria)
- [x] E1: Favoritos persistentes
- [x] E2: Previsió meteorològica de 7 dies amb icones
- [x] E3: Vista detallada del país
- [x] E4: Historial de cerques
- [x] E5: Toggle mode fosc/clar + unitat °C/°F
- [x] E6: Gestió robusta d'errors (4 casos)

[cite_start]*(Añade aquí el enlace a tu vídeo y capturas de pantalla)* [cite: 428, 432]