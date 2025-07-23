import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherly/bloc/weather_bloc_bloc.dart';
import 'package:weatherly/data/city_suggestions_service.dart';

class WeatherSearchBar extends StatefulWidget {
  const WeatherSearchBar({super.key});

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<CitySuggestion> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _searchController.addListener(() {
      setState(() {}); // Met à jour l'interface quand le texte change
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _searchController.text.isNotEmpty) {
      // Petit délai pour éviter les conflits avec la sélection
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_focusNode.hasFocus && _searchController.text.isNotEmpty) {
          _showSuggestions();
        }
      });
    } else {
      // Délai pour permettre la sélection avant de fermer l'overlay
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (value.trim().isNotEmpty) {
        _fetchSuggestions(value.trim());
      } else {
        setState(() {
          _suggestions.clear();
          _isLoading = false;
        });
        _removeOverlay();
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await CitySuggestionsService.getCitySuggestions(query);
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
        
        if (_focusNode.hasFocus) {
          _showSuggestions();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions.clear();
          _isLoading = false;
        });
        if (_focusNode.hasFocus) {
          _showSuggestions();
        }
      }
    }
  }

  void _showSuggestions() {
    _removeOverlay();
    
    // Afficher l'overlay même s'il n'y a pas de suggestions (pour montrer "Aucun résultat")
    if (!_isLoading && _suggestions.isEmpty && _searchController.text.trim().isEmpty) {
      return; // Ne pas afficher si le champ est vide
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Recherche en cours...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (!_isLoading && _suggestions.isEmpty && _searchController.text.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.search_off, color: Colors.orange, size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Aucune ville trouvée pour "${_searchController.text}"',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!_isLoading && _suggestions.isNotEmpty)
                        ..._suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildSuggestionItem(CitySuggestion suggestion) {
    return InkWell(
      onTap: () {
        print('🖱️ Clic sur suggestion: ${suggestion.name}');
        _selectSuggestion(suggestion);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.location_city, color: Colors.white70, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectSuggestion(CitySuggestion suggestion) {
    print('🎯 Sélection de la suggestion: ${suggestion.name}');
    
    // D'abord, mettre à jour le texte et l'interface
    setState(() {
      _searchController.text = suggestion.name;
    });
    
    // Ensuite, nettoyer l'overlay et enlever le focus
    _removeOverlay();
    
    // Attendre un peu avant d'enlever le focus pour s'assurer que le texte est bien mis à jour
    Future.delayed(const Duration(milliseconds: 50), () {
      _focusNode.unfocus();
    });
    
    // Enfin, soumettre la recherche
    _onSearchSubmitted(suggestion.name);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSearchSubmitted(String cityName) {
    print('🔍 Recherche soumise: "$cityName"');
    if (cityName.trim().isNotEmpty) {
      print('✅ Recherche valide, envoi de l\'événement FetchWeatherByCity');
      context.read<WeatherBlocBloc>().add(FetchWeatherByCity(cityName.trim()));
      // Ne pas vider le champ de recherche pour que l'utilisateur voit la ville sélectionnée
      _removeOverlay();
      // Hide keyboard
      FocusScope.of(context).unfocus();
    } else {
      print('❌ Recherche vide, ignorée');
    }
  }

  void _getCurrentLocationWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Les services de localisation sont désactivés')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission de localisation refusée')),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      context.read<WeatherBlocBloc>().add(FetchWeather(position));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'obtention de la localisation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: CompositedTransformTarget(
              link: _layerLink,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Rechercher une ville...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        prefixIcon: _isLoading
                            ? Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                              )
                            : Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.8)),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _suggestions.clear();
                                  });
                                  _removeOverlay();
                                  // Optionnel: remettre le focus pour permettre une nouvelle recherche
                                  _focusNode.requestFocus();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      ),
                      onSubmitted: _onSearchSubmitted,
                      onChanged: _onSearchChanged,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: IconButton(
                  onPressed: _getCurrentLocationWeather,
                  icon: const Icon(Icons.my_location, color: Colors.white),
                  tooltip: 'Utiliser ma position',
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
