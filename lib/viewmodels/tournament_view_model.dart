import 'package:flutter/foundation.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/tournament.dart';

class TournamentViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  TournamentViewModel(this._databaseHelper);

  List<Tournament> _tournaments = [];

  bool _isLoading = false;
  String? _error;

  List<Tournament> get tournaments => List.unmodifiable(_tournaments);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _refreshTournaments() async {
    _tournaments = await _databaseHelper.getTournaments();
  }

  Future<void> loadTournaments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _refreshTournaments();
    } catch (e) {
      _error = 'Failed to load tournaments.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTournament(Tournament t) async {
    _error = null;

    try {
      await _databaseHelper.insertTournament(t);
      await _refreshTournaments();
      return true;
    } catch (e) {
      _error = "Can't add tournament";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateTournament(Tournament t) async {
    _error = null;

    try {
      await _databaseHelper.updateTournament(t);
      await _refreshTournaments();
      return true;
    } catch (e) {
      _error = "Can't update tournament";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<int> deleteTournament(int id) async {
    _error = null;

    try {
      final count = await _databaseHelper.deleteTournament(id);
      if (count > 0) {
        await _refreshTournaments();
      } else {
        _error = "Tournament not found.";
      }
      return count;
    } catch (e) {
      _error = "Failed to delete tournament";
      return 0;
    } finally {
      notifyListeners();
    }
  }
}
