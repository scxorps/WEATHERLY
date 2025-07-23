import 'dart:convert';
import 'package:http/http.dart' as http;

class CitySuggestionsService {
  static const String _baseUrl = 'http://api.openweathermap.org/geo/1.0';
  static const String _apiKey = 'bb73bf034cb36f2cfdf9b36a5ad8f6fd';

  // Base de données de villes populaires pour des suggestions immédiates
  static final List<CitySuggestion> _popularCities = [
    // Algérie - Toutes les wilayas
    CitySuggestion(name: 'Alger', country: 'DZ', state: 'Alger', lat: 36.7538, lon: 3.0588),
    CitySuggestion(name: 'Oran', country: 'DZ', state: 'Oran', lat: 35.6911, lon: -0.6417),
    CitySuggestion(name: 'Constantine', country: 'DZ', state: 'Constantine', lat: 36.3650, lon: 6.6147),
    CitySuggestion(name: 'Annaba', country: 'DZ', state: 'Annaba', lat: 36.9000, lon: 7.7667),
    CitySuggestion(name: 'Blida', country: 'DZ', state: 'Blida', lat: 36.4203, lon: 2.8277),
    CitySuggestion(name: 'Batna', country: 'DZ', state: 'Batna', lat: 35.5559, lon: 6.1744),
    CitySuggestion(name: 'Djelfa', country: 'DZ', state: 'Djelfa', lat: 34.6773, lon: 3.2633),
    CitySuggestion(name: 'Sétif', country: 'DZ', state: 'Sétif', lat: 36.1900, lon: 5.4100),
    CitySuggestion(name: 'Sidi Bel Abbès', country: 'DZ', state: 'Sidi Bel Abbès', lat: 35.1908, lon: -0.6307),
    CitySuggestion(name: 'Biskra', country: 'DZ', state: 'Biskra', lat: 34.8518, lon: 5.7282),
    CitySuggestion(name: 'Tébessa', country: 'DZ', state: 'Tébessa', lat: 35.4042, lon: 8.1242),
    CitySuggestion(name: 'Tlemcen', country: 'DZ', state: 'Tlemcen', lat: 34.8789, lon: -1.3150),
    CitySuggestion(name: 'Béjaïa', country: 'DZ', state: 'Béjaïa', lat: 36.7525, lon: 5.0667),
    CitySuggestion(name: 'Tiaret', country: 'DZ', state: 'Tiaret', lat: 35.3703, lon: 1.3170),
    CitySuggestion(name: 'Bordj Bou Arréridj', country: 'DZ', state: 'Bordj Bou Arréridj', lat: 36.0731, lon: 4.7608),
    CitySuggestion(name: 'Tizi Ouzou', country: 'DZ', state: 'Tizi Ouzou', lat: 36.7117, lon: 4.0433),
    CitySuggestion(name: 'Mostaganem', country: 'DZ', state: 'Mostaganem', lat: 35.9315, lon: 0.0892),
    CitySuggestion(name: 'Ouargla', country: 'DZ', state: 'Ouargla', lat: 31.9539, lon: 5.3139),
    CitySuggestion(name: 'Ghardaïa', country: 'DZ', state: 'Ghardaïa', lat: 32.4840, lon: 3.6731),
    CitySuggestion(name: 'Chlef', country: 'DZ', state: 'Chlef', lat: 36.1654, lon: 1.3347),
    CitySuggestion(name: 'Skikda', country: 'DZ', state: 'Skikda', lat: 36.8761, lon: 6.9088),
    CitySuggestion(name: 'Jijel', country: 'DZ', state: 'Jijel', lat: 36.8190, lon: 5.7667),
    CitySuggestion(name: 'Relizane', country: 'DZ', state: 'Relizane', lat: 35.7373, lon: 0.5560),
    CitySuggestion(name: 'Khenchela', country: 'DZ', state: 'Khenchela', lat: 35.4364, lon: 7.1430),
    CitySuggestion(name: 'Souk Ahras', country: 'DZ', state: 'Souk Ahras', lat: 36.2865, lon: 7.9511),
    CitySuggestion(name: 'Laghouat', country: 'DZ', state: 'Laghouat', lat: 33.8000, lon: 2.8647),
    CitySuggestion(name: 'Bechar', country: 'DZ', state: 'Bechar', lat: 31.6177, lon: -2.2158),
    CitySuggestion(name: 'Medea', country: 'DZ', state: 'Medea', lat: 36.2650, lon: 2.7533),
    CitySuggestion(name: 'El Oued', country: 'DZ', state: 'El Oued', lat: 33.3567, lon: 6.8675),
    CitySuggestion(name: 'Bouira', country: 'DZ', state: 'Bouira', lat: 36.3739, lon: 3.9031),
    CitySuggestion(name: 'Tamanrasset', country: 'DZ', state: 'Tamanrasset', lat: 22.7850, lon: 5.5281),
    CitySuggestion(name: 'Tindouf', country: 'DZ', state: 'Tindouf', lat: 27.6711, lon: -8.1475),
    CitySuggestion(name: 'Tissemsilt', country: 'DZ', state: 'Tissemsilt', lat: 35.6078, lon: 1.8114),
    CitySuggestion(name: 'El Bayadh', country: 'DZ', state: 'El Bayadh', lat: 33.6792, lon: 1.0197),
    CitySuggestion(name: 'Naama', country: 'DZ', state: 'Naama', lat: 33.2667, lon: -0.3167),
    CitySuggestion(name: 'Ain Defla', country: 'DZ', state: 'Ain Defla', lat: 36.2639, lon: 1.9681),
    CitySuggestion(name: 'Ain Temouchent', country: 'DZ', state: 'Ain Temouchent', lat: 35.2981, lon: -1.1408),
    CitySuggestion(name: 'Guelma', country: 'DZ', state: 'Guelma', lat: 36.4611, lon: 7.4281),
    CitySuggestion(name: 'Oum El Bouaghi', country: 'DZ', state: 'Oum El Bouaghi', lat: 35.8753, lon: 7.1136),
    CitySuggestion(name: 'Illizi', country: 'DZ', state: 'Illizi', lat: 26.4833, lon: 8.4667),
    CitySuggestion(name: 'Bordj Badji Mokhtar', country: 'DZ', state: 'Bordj Badji Mokhtar', lat: 21.3167, lon: 0.9333),
    CitySuggestion(name: 'Ouled Djellal', country: 'DZ', state: 'Biskra', lat: 34.4167, lon: 5.0833),
    CitySuggestion(name: 'Beni Abbes', country: 'DZ', state: 'Bechar', lat: 30.1333, lon: -2.1667),
    CitySuggestion(name: 'In Salah', country: 'DZ', state: 'Tamanrasset', lat: 27.1939, lon: 2.4608),
    CitySuggestion(name: 'In Guezzam', country: 'DZ', state: 'Tamanrasset', lat: 19.5667, lon: 5.7667),
    CitySuggestion(name: 'Touggourt', country: 'DZ', state: 'Ouargla', lat: 33.1061, lon: 6.0569),
    CitySuggestion(name: 'Djanet', country: 'DZ', state: 'Illizi', lat: 24.5542, lon: 9.4844),
    CitySuggestion(name: 'El Meghaier', country: 'DZ', state: 'El Oued', lat: 33.9500, lon: 5.9167),
    CitySuggestion(name: 'El Meniaa', country: 'DZ', state: 'Ghardaïa', lat: 30.5833, lon: 2.8833),
    
    // Grandes villes mondiales
    CitySuggestion(name: 'Paris', country: 'FR', state: 'Île-de-France', lat: 48.8566, lon: 2.3522),
    CitySuggestion(name: 'London', country: 'GB', state: 'England', lat: 51.5074, lon: -0.1278),
    CitySuggestion(name: 'New York', country: 'US', state: 'New York', lat: 40.7128, lon: -74.0060),
    CitySuggestion(name: 'Tokyo', country: 'JP', state: 'Tokyo', lat: 35.6762, lon: 139.6503),
    CitySuggestion(name: 'Madrid', country: 'ES', state: 'Madrid', lat: 40.4168, lon: -3.7038),
    CitySuggestion(name: 'Rome', country: 'IT', state: 'Lazio', lat: 41.9028, lon: 12.4964),
    CitySuggestion(name: 'Berlin', country: 'DE', state: 'Berlin', lat: 52.5200, lon: 13.4050),
    CitySuggestion(name: 'Moscow', country: 'RU', state: 'Moscow', lat: 55.7558, lon: 37.6176),
    CitySuggestion(name: 'Cairo', country: 'EG', state: 'Cairo Governorate', lat: 30.0444, lon: 31.2357),
    CitySuggestion(name: 'Dubai', country: 'AE', state: 'Dubai', lat: 25.2048, lon: 55.2708),
    CitySuggestion(name: 'Istanbul', country: 'TR', state: 'Istanbul', lat: 41.0082, lon: 28.9784),
    CitySuggestion(name: 'Barcelona', country: 'ES', state: 'Catalonia', lat: 41.3851, lon: 2.1734),
    CitySuggestion(name: 'Amsterdam', country: 'NL', state: 'North Holland', lat: 52.3676, lon: 4.9041),
    CitySuggestion(name: 'Brussels', country: 'BE', state: 'Brussels', lat: 50.8503, lon: 4.3517),
    CitySuggestion(name: 'Vienna', country: 'AT', state: 'Vienna', lat: 48.2082, lon: 16.3738),
    CitySuggestion(name: 'Prague', country: 'CZ', state: 'Prague', lat: 50.0755, lon: 14.4378),
    CitySuggestion(name: 'Warsaw', country: 'PL', state: 'Masovian Voivodeship', lat: 52.2297, lon: 21.0122),
    CitySuggestion(name: 'Budapest', country: 'HU', state: 'Budapest', lat: 47.4979, lon: 19.0402),
    CitySuggestion(name: 'Stockholm', country: 'SE', state: 'Stockholm', lat: 59.3293, lon: 18.0686),
    CitySuggestion(name: 'Copenhagen', country: 'DK', state: 'Capital Region', lat: 55.6761, lon: 12.5683),
    CitySuggestion(name: 'Oslo', country: 'NO', state: 'Oslo', lat: 59.9139, lon: 10.7522),
    CitySuggestion(name: 'Helsinki', country: 'FI', state: 'Uusimaa', lat: 60.1699, lon: 24.9384),
    CitySuggestion(name: 'Lisbon', country: 'PT', state: 'Lisbon', lat: 38.7223, lon: -9.1393),
    CitySuggestion(name: 'Athens', country: 'GR', state: 'Attica', lat: 37.9838, lon: 23.7275),
    CitySuggestion(name: 'Zurich', country: 'CH', state: 'Zurich', lat: 47.3769, lon: 8.5417),
    CitySuggestion(name: 'Geneva', country: 'CH', state: 'Geneva', lat: 46.2044, lon: 6.1432),
    CitySuggestion(name: 'Montreal', country: 'CA', state: 'Quebec', lat: 45.5017, lon: -73.5673),
    CitySuggestion(name: 'Toronto', country: 'CA', state: 'Ontario', lat: 43.6532, lon: -79.3832),
    CitySuggestion(name: 'Vancouver', country: 'CA', state: 'British Columbia', lat: 49.2827, lon: -123.1207),
    CitySuggestion(name: 'Sydney', country: 'AU', state: 'New South Wales', lat: -33.8688, lon: 151.2093),
    CitySuggestion(name: 'Melbourne', country: 'AU', state: 'Victoria', lat: -37.8136, lon: 144.9631),
    CitySuggestion(name: 'Brisbane', country: 'AU', state: 'Queensland', lat: -27.4698, lon: 153.0251),
    CitySuggestion(name: 'Perth', country: 'AU', state: 'Western Australia', lat: -31.9505, lon: 115.8605),
    CitySuggestion(name: 'Auckland', country: 'NZ', state: 'Auckland', lat: -36.8485, lon: 174.7633),
    CitySuggestion(name: 'Wellington', country: 'NZ', state: 'Wellington', lat: -41.2865, lon: 174.7762),
    CitySuggestion(name: 'Seoul', country: 'KR', state: 'Seoul', lat: 37.5665, lon: 126.9780),
    CitySuggestion(name: 'Beijing', country: 'CN', state: 'Beijing', lat: 39.9042, lon: 116.4074),
    CitySuggestion(name: 'Shanghai', country: 'CN', state: 'Shanghai', lat: 31.2304, lon: 121.4737),
    CitySuggestion(name: 'Hong Kong', country: 'HK', state: 'Hong Kong', lat: 22.3193, lon: 114.1694),
    CitySuggestion(name: 'Singapore', country: 'SG', state: 'Singapore', lat: 1.3521, lon: 103.8198),
    CitySuggestion(name: 'Mumbai', country: 'IN', state: 'Maharashtra', lat: 19.0760, lon: 72.8777),
    CitySuggestion(name: 'Delhi', country: 'IN', state: 'Delhi', lat: 28.7041, lon: 77.1025),
    CitySuggestion(name: 'Bangalore', country: 'IN', state: 'Karnataka', lat: 12.9716, lon: 77.5946),
    CitySuggestion(name: 'Chennai', country: 'IN', state: 'Tamil Nadu', lat: 13.0827, lon: 80.2707),
    CitySuggestion(name: 'Kolkata', country: 'IN', state: 'West Bengal', lat: 22.5726, lon: 88.3639),
    CitySuggestion(name: 'Bangkok', country: 'TH', state: 'Bangkok', lat: 13.7563, lon: 100.5018),
    CitySuggestion(name: 'Jakarta', country: 'ID', state: 'Jakarta', lat: -6.2088, lon: 106.8456),
    CitySuggestion(name: 'Manila', country: 'PH', state: 'Metro Manila', lat: 14.5995, lon: 120.9842),
    CitySuggestion(name: 'Kuala Lumpur', country: 'MY', state: 'Federal Territory of Kuala Lumpur', lat: 3.1390, lon: 101.6869),
    CitySuggestion(name: 'Ho Chi Minh City', country: 'VN', state: 'Ho Chi Minh', lat: 10.8231, lon: 106.6297),
    CitySuggestion(name: 'São Paulo', country: 'BR', state: 'São Paulo', lat: -23.5505, lon: -46.6333),
    CitySuggestion(name: 'Rio de Janeiro', country: 'BR', state: 'Rio de Janeiro', lat: -22.9068, lon: -43.1729),
    CitySuggestion(name: 'Buenos Aires', country: 'AR', state: 'Buenos Aires', lat: -34.6118, lon: -58.3960),
    CitySuggestion(name: 'Mexico City', country: 'MX', state: 'Mexico City', lat: 19.4326, lon: -99.1332),
    CitySuggestion(name: 'Lima', country: 'PE', state: 'Lima', lat: -12.0464, lon: -77.0428),
    CitySuggestion(name: 'Bogotá', country: 'CO', state: 'Bogotá', lat: 4.7110, lon: -74.0721),
    CitySuggestion(name: 'Santiago', country: 'CL', state: 'Santiago Metropolitan', lat: -33.4489, lon: -70.6693),
    CitySuggestion(name: 'Caracas', country: 'VE', state: 'Capital District', lat: 10.4806, lon: -66.9036),
    CitySuggestion(name: 'Los Angeles', country: 'US', state: 'California', lat: 34.0522, lon: -118.2437),
    CitySuggestion(name: 'Chicago', country: 'US', state: 'Illinois', lat: 41.8781, lon: -87.6298),
    CitySuggestion(name: 'Houston', country: 'US', state: 'Texas', lat: 29.7604, lon: -95.3698),
    CitySuggestion(name: 'Phoenix', country: 'US', state: 'Arizona', lat: 33.4484, lon: -112.0740),
    CitySuggestion(name: 'Philadelphia', country: 'US', state: 'Pennsylvania', lat: 39.9526, lon: -75.1652),
    CitySuggestion(name: 'San Antonio', country: 'US', state: 'Texas', lat: 29.4241, lon: -98.4936),
    CitySuggestion(name: 'San Diego', country: 'US', state: 'California', lat: 32.7157, lon: -117.1611),
    CitySuggestion(name: 'Dallas', country: 'US', state: 'Texas', lat: 32.7767, lon: -96.7970),
    CitySuggestion(name: 'San Jose', country: 'US', state: 'California', lat: 37.3382, lon: -121.8863),
    CitySuggestion(name: 'Austin', country: 'US', state: 'Texas', lat: 30.2672, lon: -97.7431),
    CitySuggestion(name: 'Jacksonville', country: 'US', state: 'Florida', lat: 30.3322, lon: -81.6557),
    CitySuggestion(name: 'Fort Worth', country: 'US', state: 'Texas', lat: 32.7555, lon: -97.3308),
    CitySuggestion(name: 'Columbus', country: 'US', state: 'Ohio', lat: 39.9612, lon: -82.9988),
    CitySuggestion(name: 'San Francisco', country: 'US', state: 'California', lat: 37.7749, lon: -122.4194),
    CitySuggestion(name: 'Charlotte', country: 'US', state: 'North Carolina', lat: 35.2271, lon: -80.8431),
    CitySuggestion(name: 'Indianapolis', country: 'US', state: 'Indiana', lat: 39.7684, lon: -86.1581),
    CitySuggestion(name: 'Seattle', country: 'US', state: 'Washington', lat: 47.6062, lon: -122.3321),
    CitySuggestion(name: 'Denver', country: 'US', state: 'Colorado', lat: 39.7392, lon: -104.9903),
    CitySuggestion(name: 'Boston', country: 'US', state: 'Massachusetts', lat: 42.3601, lon: -71.0589),
    
    // Pays arabes et du Moyen-Orient
    CitySuggestion(name: 'Casablanca', country: 'MA', state: 'Casablanca-Settat', lat: 33.5731, lon: -7.5898),
    CitySuggestion(name: 'Rabat', country: 'MA', state: 'Rabat-Salé-Kénitra', lat: 34.0209, lon: -6.8416),
    CitySuggestion(name: 'Marrakech', country: 'MA', state: 'Marrakech-Safi', lat: 31.6295, lon: -7.9811),
    CitySuggestion(name: 'Fès', country: 'MA', state: 'Fès-Meknès', lat: 34.0181, lon: -5.0078),
    CitySuggestion(name: 'Tunis', country: 'TN', state: 'Tunis', lat: 36.8065, lon: 10.1815),
    CitySuggestion(name: 'Sfax', country: 'TN', state: 'Sfax', lat: 34.7406, lon: 10.7603),
    CitySuggestion(name: 'Sousse', country: 'TN', state: 'Sousse', lat: 35.8256, lon: 10.6369),
    CitySuggestion(name: 'Tripoli', country: 'LY', state: 'Tripoli', lat: 32.8872, lon: 13.1913),
    CitySuggestion(name: 'Benghazi', country: 'LY', state: 'Benghazi', lat: 32.1190, lon: 20.0685),
    CitySuggestion(name: 'Riyadh', country: 'SA', state: 'Riyadh', lat: 24.7136, lon: 46.6753),
    CitySuggestion(name: 'Jeddah', country: 'SA', state: 'Makkah', lat: 21.4858, lon: 39.1925),
    CitySuggestion(name: 'Mecca', country: 'SA', state: 'Makkah', lat: 21.3891, lon: 39.8579),
    CitySuggestion(name: 'Medina', country: 'SA', state: 'Al Madinah', lat: 24.5247, lon: 39.5692),
    CitySuggestion(name: 'Dammam', country: 'SA', state: 'Eastern Province', lat: 26.4207, lon: 50.0888),
    CitySuggestion(name: 'Abu Dhabi', country: 'AE', state: 'Abu Dhabi', lat: 24.2539, lon: 54.3773),
    CitySuggestion(name: 'Sharjah', country: 'AE', state: 'Sharjah', lat: 25.3463, lon: 55.4209),
    CitySuggestion(name: 'Al Ain', country: 'AE', state: 'Abu Dhabi', lat: 24.2075, lon: 55.7447),
    CitySuggestion(name: 'Kuwait City', country: 'KW', state: 'Al Asimah', lat: 29.3117, lon: 47.4818),
    CitySuggestion(name: 'Manama', country: 'BH', state: 'Capital', lat: 26.0667, lon: 50.5577),
    CitySuggestion(name: 'Doha', country: 'QA', state: 'Doha', lat: 25.2764, lon: 51.5200),
    CitySuggestion(name: 'Muscat', country: 'OM', state: 'Muscat', lat: 23.5859, lon: 58.4059),
    CitySuggestion(name: 'Sanaa', country: 'YE', state: 'Amanat Al Asimah', lat: 15.3694, lon: 44.1910),
    CitySuggestion(name: 'Aden', country: 'YE', state: 'Aden', lat: 12.7797, lon: 45.0365),
    CitySuggestion(name: 'Baghdad', country: 'IQ', state: 'Baghdad', lat: 33.3152, lon: 44.3661),
    CitySuggestion(name: 'Basra', country: 'IQ', state: 'Basra', lat: 30.5084, lon: 47.7804),
    CitySuggestion(name: 'Erbil', country: 'IQ', state: 'Erbil', lat: 36.2381, lon: 44.0094),
    CitySuggestion(name: 'Tehran', country: 'IR', state: 'Tehran', lat: 35.6892, lon: 51.3890),
    CitySuggestion(name: 'Isfahan', country: 'IR', state: 'Isfahan', lat: 32.6539, lon: 51.6660),
    CitySuggestion(name: 'Mashhad', country: 'IR', state: 'Razavi Khorasan', lat: 36.2605, lon: 59.6168),
    CitySuggestion(name: 'Shiraz', country: 'IR', state: 'Fars', lat: 29.5918, lon: 52.5837),
    CitySuggestion(name: 'Tabriz', country: 'IR', state: 'East Azerbaijan', lat: 38.0667, lon: 46.3000),
    CitySuggestion(name: 'Damascus', country: 'SY', state: 'Damascus', lat: 33.5138, lon: 36.2765),
    CitySuggestion(name: 'Aleppo', country: 'SY', state: 'Aleppo', lat: 36.2021, lon: 37.1343),
    CitySuggestion(name: 'Homs', country: 'SY', state: 'Homs', lat: 34.7394, lon: 36.7229),
    CitySuggestion(name: 'Beirut', country: 'LB', state: 'Beirut', lat: 33.8938, lon: 35.5018),
    CitySuggestion(name: 'Tripoli', country: 'LB', state: 'North', lat: 34.4367, lon: 35.8497),
    CitySuggestion(name: 'Sidon', country: 'LB', state: 'South', lat: 33.5633, lon: 35.3650),
    CitySuggestion(name: 'Amman', country: 'JO', state: 'Amman', lat: 31.9539, lon: 35.9106),
    CitySuggestion(name: 'Zarqa', country: 'JO', state: 'Zarqa', lat: 32.0753, lon: 36.0870),
    CitySuggestion(name: 'Irbid', country: 'JO', state: 'Irbid', lat: 32.5556, lon: 35.8500),
    CitySuggestion(name: 'Jerusalem', country: 'PS', state: 'Jerusalem', lat: 31.7683, lon: 35.2137),
    CitySuggestion(name: 'Gaza', country: 'PS', state: 'Gaza', lat: 31.3547, lon: 34.3088),
    CitySuggestion(name: 'Ramallah', country: 'PS', state: 'West Bank', lat: 31.9073, lon: 35.2028),
    CitySuggestion(name: 'Alexandria', country: 'EG', state: 'Alexandria', lat: 31.2001, lon: 29.9187),
    CitySuggestion(name: 'Giza', country: 'EG', state: 'Giza', lat: 30.0131, lon: 31.2089),
    CitySuggestion(name: 'Shubra El Kheima', country: 'EG', state: 'Qalyubia', lat: 30.1218, lon: 31.2444),
    CitySuggestion(name: 'Port Said', country: 'EG', state: 'Port Said', lat: 31.2653, lon: 32.3019),
    CitySuggestion(name: 'Suez', country: 'EG', state: 'Suez', lat: 29.9668, lon: 32.5498),
    CitySuggestion(name: 'Luxor', country: 'EG', state: 'Luxor', lat: 25.6872, lon: 32.6396),
    CitySuggestion(name: 'Aswan', country: 'EG', state: 'Aswan', lat: 24.0889, lon: 32.8998),
    CitySuggestion(name: 'Khartoum', country: 'SD', state: 'Khartoum', lat: 15.5007, lon: 32.5599),
    CitySuggestion(name: 'Omdurman', country: 'SD', state: 'Khartoum', lat: 15.6445, lon: 32.4777),
    CitySuggestion(name: 'Port Sudan', country: 'SD', state: 'Red Sea', lat: 19.6158, lon: 37.2164),
    CitySuggestion(name: 'Mogadishu', country: 'SO', state: 'Banaadir', lat: 2.0469, lon: 45.3182),
    CitySuggestion(name: 'Hargeisa', country: 'SO', state: 'Woqooyi Galbeed', lat: 9.5600, lon: 44.0650),
    CitySuggestion(name: 'Addis Ababa', country: 'ET', state: 'Addis Ababa', lat: 9.1450, lon: 40.4897),
    CitySuggestion(name: 'Dire Dawa', country: 'ET', state: 'Dire Dawa', lat: 9.5950, lon: 41.8550),
    CitySuggestion(name: 'Mekelle', country: 'ET', state: 'Tigray', lat: 13.4967, lon: 39.4753),
    CitySuggestion(name: 'Gondar', country: 'ET', state: 'Amhara', lat: 12.6090, lon: 37.4476),
    CitySuggestion(name: 'Bahir Dar', country: 'ET', state: 'Amhara', lat: 11.5942, lon: 37.3964),
    CitySuggestion(name: 'Djibouti', country: 'DJ', state: 'Djibouti', lat: 11.8251, lon: 42.5903),
    CitySuggestion(name: 'Asmara', country: 'ER', state: 'Maekel', lat: 15.3229, lon: 38.9251),
    CitySuggestion(name: 'Massawa', country: 'ER', state: 'Northern Red Sea', lat: 15.6118, lon: 39.4745),
  ];

  /// Filtre les villes populaires selon la requête
  static List<CitySuggestion> _filterPopularCities(String query) {
    if (query.trim().isEmpty) return [];
    
    String queryLower = query.toLowerCase().trim();
    
    return _popularCities
        .where((city) => 
            city.name.toLowerCase().startsWith(queryLower) ||
            city.name.toLowerCase().contains(queryLower) ||
            city.country.toLowerCase().contains(queryLower) ||
            (city.state?.toLowerCase().contains(queryLower) ?? false))
        .take(10)
        .toList();
  }

  /// Récupère les suggestions de villes - d'abord localement, puis via API si nécessaire
  static Future<List<CitySuggestion>> getCitySuggestions(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    print('🔍 Recherche de suggestions pour: "$query"');

    // D'abord, chercher dans notre base locale
    List<CitySuggestion> localSuggestions = _filterPopularCities(query);
    print('📍 ${localSuggestions.length} suggestions locales trouvées');

    // Si on a des suggestions locales, les retourner immédiatement
    if (localSuggestions.isNotEmpty) {
      return localSuggestions;
    }

    // Sinon, essayer l'API pour des villes moins communes
    try {
      final url = '$_baseUrl/direct?q=${Uri.encodeComponent(query)}&limit=5&appid=$_apiKey';
      print('🌐 API Request: $url');
      
      final response = await http.get(Uri.parse(url));
      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('📦 Raw response: $data');
        
        if (data.isEmpty) {
          print('🚫 Aucune suggestion API trouvée pour: "$query"');
          return [];
        }
        
        List<CitySuggestion> apiSuggestions = data.map((item) {
          return CitySuggestion.fromJson(item);
        }).toList();
        
        print('✅ ${apiSuggestions.length} suggestions API trouvées');
        return apiSuggestions;
      } else {
        print('❌ Erreur API: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('🔥 Exception lors de la recherche API: $e');
      return [];
    }
  }

  /// Vérifie si une ville existe (d'abord localement, puis via API)
  static Future<bool> cityExists(String cityName) async {
    // Vérifier d'abord localement
    List<CitySuggestion> localMatches = _filterPopularCities(cityName);
    if (localMatches.isNotEmpty) {
      return true;
    }
    
    // Puis vérifier via API
    final suggestions = await getCitySuggestions(cityName);
    return suggestions.isNotEmpty;
  }

  /// Recherche exacte d'une ville pour la météo
  static Future<CitySuggestion?> findExactCity(String cityName) async {
    print('🎯 Recherche exacte pour: "$cityName"');
    
    // D'abord dans la base locale
    String cityLower = cityName.toLowerCase().trim();
    CitySuggestion? localMatch = _popularCities
        .where((city) => city.name.toLowerCase() == cityLower)
        .firstOrNull;
    
    if (localMatch != null) {
      print('✅ Ville trouvée localement: ${localMatch.displayName}');
      return localMatch;
    }

    // Puis via API
    try {
      final suggestions = await getCitySuggestions(cityName);
      if (suggestions.isNotEmpty) {
        print('✅ Ville trouvée via API: ${suggestions.first.displayName}');
        return suggestions.first;
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche exacte: $e');
    }

    print('🚫 Ville non trouvée: "$cityName"');
    return null;
  }
}

class CitySuggestion {
  final String name;
  final String country;
  final String? state;
  final double lat;
  final double lon;
  final String displayName;

  CitySuggestion({
    required this.name,
    required this.country,
    this.state,
    required this.lat,
    required this.lon,
  }) : displayName = _buildDisplayName(name, state, country);

  static String _buildDisplayName(String name, String? state, String country) {
    if (state != null && state.isNotEmpty) {
      return '$name, $state, $country';
    } else {
      return '$name, $country';
    }
  }

  factory CitySuggestion.fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'],
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'state': state,
      'lat': lat,
      'lon': lon,
    };
  }

  @override
  String toString() {
    return 'CitySuggestion(name: $name, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CitySuggestion &&
        other.name == name &&
        other.country == country &&
        other.state == state;
  }

  @override
  int get hashCode => name.hashCode ^ country.hashCode ^ (state?.hashCode ?? 0);
}
