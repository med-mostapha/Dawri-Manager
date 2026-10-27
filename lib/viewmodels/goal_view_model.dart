import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/goal.dart';

class GoalViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  GoalViewModel(this._databaseHelper);

  List<Goal> _goals = [];
  bool _isLoading = false;
  String? _error;

  List<Goal> get goals => List.unmodifiable(_goals);
  bool get isLoading => _isLoading;
  String? get error => _error;

  int getGoalsForTeam(int teamId) {
    return _goals.where((goal) => goal.teamId == teamId).length;
  }

  Future<void> loadGoals(int matchId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _goals = await _databaseHelper.getGoalsByMatch(matchId);
    } catch (e) {
      _error = 'Failed to load goals: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addGoal(Goal goal) async {
    _error = null;

    try {
      await _databaseHelper.insertGoal(goal);
      await loadGoals(goal.matchId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGoal(Goal goal) async {
    _error = null;

    try {
      await _databaseHelper.updateGoal(goal);
      await loadGoals(goal.matchId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGoal(int goalId, int matchId) async {
    _error = null;

    try {
      await _databaseHelper.deleteGoal(goalId);
      await loadGoals(matchId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
