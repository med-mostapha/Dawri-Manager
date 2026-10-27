import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tournament_organizer/models/goal.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/player.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/viewmodels/goal_view_model.dart';
import 'package:tournament_organizer/viewmodels/player_view_model.dart';

class AddGoalDialog extends StatefulWidget {
  final Match match;
  final List<Team> teams;
  final Goal? goal;

  const AddGoalDialog({
    super.key,
    required this.match,
    required this.teams,
    this.goal,
  });

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  int? _selectedTeamId;
  int? _selectedPlayerId;
  int _minute = 1;

  bool _isLoadingPlayers = false;
  bool _isSaving = false;
  String? _error;

  List<Player> _players = [];

  Future<void> _selectTeam(int? teamId) async {
    if (teamId == null) return;

    setState(() {
      _selectedTeamId = teamId;
      _selectedPlayerId = null;
      _players = [];
      _isLoadingPlayers = true;
      _error = null;
    });

    try {
      await context.read<PlayerViewModel>().loadPlayers(teamId);

      if (!mounted) return;

      final players = context.read<PlayerViewModel>().players;

      setState(() {
        _players = players;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Failed to load players.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPlayers = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final goal = widget.goal;

    if (goal != null) {
      _selectedTeamId = goal.teamId;
      _selectedPlayerId = goal.playerId;
      _minute = goal.minute ?? 1;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _loadInitialPlayers(goal.teamId);
      });
    }
  }

  Future<void> _loadInitialPlayers(int teamId) async {
    setState(() {
      _isLoadingPlayers = true;
    });

    try {
      await context.read<PlayerViewModel>().loadPlayers(teamId);

      if (!mounted) return;

      setState(() {
        _players = context.read<PlayerViewModel>().players;
        _isLoadingPlayers = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingPlayers = false;
        _error = 'Failed to load players.';
      });
    }
  }

  void _changeMinute(int amount) {
    setState(() {
      _minute = (_minute + amount).clamp(1, 130);
    });
  }

  Future<void> _saveGoal() async {
    if (_isSaving) return;

    if (_selectedTeamId == null) {
      setState(() {
        _error = 'Please select a team.';
      });
      return;
    }

    if (_selectedPlayerId == null) {
      setState(() {
        _error = 'Please select a player.';
      });
      return;
    }

    final matchId = widget.match.id;

    if (matchId == null) {
      setState(() {
        _error = 'The match ID is missing.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final goal = Goal(
      id: widget.goal?.id,
      matchId: matchId,
      teamId: _selectedTeamId!,
      playerId: _selectedPlayerId!,
      minute: _minute,
    );

    final goalViewModel = context.read<GoalViewModel>();

    final success = widget.goal == null
        ? await goalViewModel.addGoal(goal)
        : await goalViewModel.updateGoal(goal);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isSaving = false;
        _error =
            context.read<GoalViewModel>().error ?? 'Failed to save the goal.';
      });
    }
  }

  Widget _buildTeamSelector() {
    return DropdownButtonFormField<int>(
      initialValue: _selectedTeamId,
      decoration: const InputDecoration(
        labelText: 'Team',
        border: OutlineInputBorder(),
      ),
      items: widget.teams
          .where(
            (team) =>
                team.id == widget.match.homeTeamId ||
                team.id == widget.match.awayTeamId,
          )
          .map(
            (team) =>
                DropdownMenuItem<int>(value: team.id!, child: Text(team.name)),
          )
          .toList(),
      onChanged: _isSaving ? null : _selectTeam,
    );
  }

  Widget _buildPlayerSelector() {
    if (_isLoadingPlayers) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DropdownButtonFormField<int>(
      initialValue: _selectedPlayerId,
      decoration: const InputDecoration(
        labelText: 'Player',
        border: OutlineInputBorder(),
      ),
      hint: Text(
        _selectedTeamId == null ? 'Select a team first' : 'Select a player',
      ),
      items: _players
          .where((player) => player.id != null)
          .map(
            (player) => DropdownMenuItem<int>(
              value: player.id!,
              child: Text(player.name),
            ),
          )
          .toList(),
      onChanged: _selectedTeamId == null || _isSaving || _players.isEmpty
          ? null
          : (playerId) {
              setState(() {
                _selectedPlayerId = playerId;
                _error = null;
              });
            },
    );
  }

  Widget _buildMinuteSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Minute',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        Center(
          child: Text(
            '$_minute′',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _buildMinuteControl(increase: 1)),
            const SizedBox(width: 12),
            Expanded(child: _buildMinuteControl(increase: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildMinuteControl({required int increase}) {
    final isIncrement = increase > 0;
    final amount = increase.abs();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isIncrement ? '+$amount' : '-$amount',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),

        IconButton.filledTonal(
          tooltip: 'Increase by $amount',
          onPressed: _isSaving || _minute >= 130
              ? null
              : () => _changeMinute(amount),
          icon: const Icon(Icons.add),
        ),

        IconButton.filledTonal(
          tooltip: 'Decrease by $amount',
          onPressed: _isSaving || _minute <= 1
              ? null
              : () => _changeMinute(-amount),
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.goal == null ? 'Add Goal' : 'Edit Goal'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // if (isFinished)
              //   const Padding(
              //     padding: EdgeInsets.only(bottom: 12),
              //     child: Text(
              //       'This match is finished. Reopen it before adding goals.',
              //       style: TextStyle(color: Colors.redAccent),
              //     ),
              //   ),
              _buildTeamSelector(),
              const SizedBox(height: 16),
              _buildPlayerSelector(),
              const SizedBox(height: 20),
              _buildMinuteSelector(),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving || _isLoadingPlayers ? null : _saveGoal,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.goal == null ? 'Save Goal' : 'Update Goal'),
        ),
      ],
    );
  }
}
