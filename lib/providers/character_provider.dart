import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

enum CharacterState { initial, loading, loaded, error }

class CharacterProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Character> _allCharacters = [];
  List<Character> _displayCharacters = [];
  List<Character> _favorites = [];
  CharacterState _state = CharacterState.initial;
  String _errorMessage = '';

  List<Character> get characters => _displayCharacters;
  List<Character> get favorites => _favorites;
  CharacterState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchCharacters({bool manualRefresh = false}) async {
    _state = CharacterState.loading;
    if (!manualRefresh) notifyListeners();

    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      final favIds = await _dbHelper.getFavoriteIds();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        _allCharacters = await _dbHelper.getAllCharacters();
        if (_allCharacters.isEmpty) {
          _errorMessage = 'Brak połączenia z internetem i brak danych lokalnych.';
          _state = CharacterState.error;
        } else {
          _state = CharacterState.loaded;
        }
      } else {
        _allCharacters = await _apiService.fetchCharacters();
        await _dbHelper.deleteAllCharacters();
        await _dbHelper.insertCharacters(_allCharacters);
        _state = CharacterState.loaded;
      }

      _favorites = _allCharacters.where((char) => favIds.contains(char.id)).toList();
      _displayCharacters = List.from(_allCharacters);
    } catch (e) {
      _errorMessage = 'Wystąpił błąd: ${e.toString()}';
      _state = CharacterState.error;
    }
    notifyListeners();
  }

  void searchCharacters(String query) {
    if (query.isEmpty) {
      _displayCharacters = List.from(_allCharacters);
    } else {
      _displayCharacters = _allCharacters
          .where((char) => char.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Character character) async {
    final isFav = _favorites.any((c) => c.id == character.id);
    if (isFav) {
      _favorites.removeWhere((c) => c.id == character.id);
      await _dbHelper.removeFavorite(character.id);
    } else {
      _favorites.add(character);
      await _dbHelper.addFavorite(character.id);
    }
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.any((c) => c.id == id);
  }
}
