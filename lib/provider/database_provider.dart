import 'package:flutter/material.dart';
import 'package:restaurantcity3/data/db/database_helper.dart';
import 'package:restaurantcity3/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;
  DatabaseProvider({required this.databaseHelper}) {
    _getFavorite();
  }

  StatusState? _state;
  StatusState? get state => _state;

  String _message = '';
  String get message => _message;

  List<String> _favorite = [];
  List<String> get favorite => _favorite;

  void _getFavorite() async {
    _favorite = await databaseHelper.getFavorite();
    if (_favorite.isNotEmpty) {
      _state = StatusState.hasData;
    } else {
      _state = StatusState.noData;
      _message = 'No Data';
    }
    notifyListeners();
  }

  void addFavorite(String restoId) async {
    try {
      await databaseHelper.addFavorite(restoId);
      _getFavorite();
    } catch (e) {
      _state = StatusState.error;
      _message = 'Error $e';
      notifyListeners();
    }
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorite();
    } catch (e) {
      _state = StatusState.error;
      _message = 'Error : $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteResto = await databaseHelper.getFavoriteById(id);
    return favoriteResto.isNotEmpty;
  }
}
