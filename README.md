# WorldExplorer - RA3

**Autor:** ota
**Mòdul:** 0489 · DAM · PratFP
**Data:** 12/05/2026

---

## 🛠 Investigació d'APIs

**1. Endpoint de REST Countries:**
`https://restcountries.com/v3.1/name/{nom}`. Retorna un JSON amb les dades generals del país (nom, capital, població, coordenades, etc.).

**2. Coordenades:**
S'extreuen de `capitalInfo['latlng']` de la resposta de REST Countries. Són necessàries per fer la consulta meteorològica exacta.

**3. Endpoint d'Open-Meteo:**
`https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto`.

**4. Estructura JSON Open-Meteo:**
Llegeixo `current_weather` per a la temperatura i vent actuals, i l'objecte `daily` per a la previsió de 7 dies (min/max i weathercodes).

---

## ⚠️ Gestió d'errors i caigudes de l'API
S'han implementat blocs `try-catch` amb `timeout` de 10 segons a totes les crides. Si una API falla o no hi ha internet:
1. Es captura l'error (E6).
2. Es mostra un `SnackBar` explicatiu a l'usuari.
3. L'app no es bloqueja i permet reintentar la cerca.

---

## ✅ Funcionalitats (Extensions)
- **E1:** Favorits persistents amb `shared_preferences`.
- **E2:** Previsió de 7 dies amb icones mapejades segons el codi de temps.
- **E3:** Vista de detalls ampliada (idiomes, monedes, fronteres, densitat).
- **E4:** Historial de les últimes 5 cerques (persistent).
- **E5:** Toggle de Mode Fosc i canvi d'unitats (ºC/ºF) persistents.
- **E6:** Gestió d'errors robusta (Timeout, No internet, 404).

---

## 🤖 Ús d'IA
S'ha utilitzat IA per a l'ajuda en l'estructura del codi i la resolució d'errors puntuals.

---
