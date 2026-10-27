import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/goal.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/viewmodels/goal_view_model.dart';
import 'package:tournament_organizer/viewmodels/player_view_model.dart';
import 'package:tournament_organizer/widgets/build_placeholder.dart';
import 'package:tournament_organizer/pages/tabs/add_goal_dialog.dart';

class MatchDetailsPage extends StatefulWidget {
  final Match match;

  const MatchDetailsPage({super.key, required this.match});

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Team? _homeTeam;
  Team? _awayTeam;

  bool _isLoadingTeams = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _loadTeams();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.match.id != null) {
        context.read<GoalViewModel>().loadGoals(widget.match.id!);
      }
    });
  }

  Future<void> _loadTeams() async {
    try {
      final teams = await _databaseHelper.getTeamsByTournament(
        widget.match.tournamentId,
      );

      Team? homeTeam;
      Team? awayTeam;

      for (final team in teams) {
        if (team.id == widget.match.homeTeamId) {
          homeTeam = team;
        }

        if (team.id == widget.match.awayTeamId) {
          awayTeam = team;
        }
      }

      if (!mounted) return;

      setState(() {
        _homeTeam = homeTeam;
        _awayTeam = awayTeam;

        if (homeTeam == null || awayTeam == null) {
          _error = 'Could not find both teams.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Failed to load teams.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTeams = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalViewModel = context.watch<GoalViewModel>();

    final goals = goalViewModel.goals
        .where((goal) => goal.matchId == widget.match.id)
        .toList();

    final homeScore = goals
        .where((goal) => goal.teamId == widget.match.homeTeamId)
        .length;

    final awayScore = goals
        .where((goal) => goal.teamId == widget.match.awayTeamId)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Match Details')),
      body: _buildBody(
        goals: goals,
        homeScore: homeScore,
        awayScore: awayScore,
        goalViewModel: goalViewModel,
      ),
    );
  }

  Future<void> _openAddGoalDialog() async {
    if (widget.match.status == MatchStatus.finished) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reopen the match before adding goals.')),
      );
      return;
    }

    if (_homeTeam == null || _awayTeam == null) {
      return;
    }

    await showDialog<bool>(
      context: context,
      builder: (context) =>
          AddGoalDialog(match: widget.match, teams: [_homeTeam!, _awayTeam!]),
    );
  }

  Future<void> _openEditGoalDialog(Goal goal) async {
    if (widget.match.status != MatchStatus.scheduled) {
      return;
    }

    if (_homeTeam == null || _awayTeam == null) {
      return;
    }

    await showDialog<bool>(
      context: context,
      builder: (context) => AddGoalDialog(
        match: widget.match,
        teams: [_homeTeam!, _awayTeam!],
        goal: goal,
      ),
    );
  }

  Widget _buildBody({
    required List<Goal> goals,
    required int homeScore,
    required int awayScore,
    required GoalViewModel goalViewModel,
  }) {
    if (_isLoadingTeams) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScoreCard(homeScore, awayScore),
          const SizedBox(height: 16),

          if (widget.match.status == MatchStatus.scheduled)
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _openAddGoalDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Goal'),
              ),
            ),

          const SizedBox(height: 16),
          _buildGoalsHeader(goals.length),
          const SizedBox(height: 8),
          Expanded(child: _buildGoalsList(goals)),
        ],
      ),
    );
  }

  Widget _buildScoreCard(int homeScore, int awayScore) {
    final isFinished = widget.match.status == MatchStatus.finished;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _homeTeam!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '$homeScore - $awayScore',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    _awayTeam!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isFinished ? 'Finished' : 'Scheduled',
              style: TextStyle(
                color: isFinished ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsHeader(int goalsCount) {
    return Row(
      children: [
        Text('Goals', style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        Text('$goalsCount', style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildGoalsList(List<Goal> goals) {
    if (goals.isEmpty) {
      return _buildEmptyGoalsState();
    }

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return _buildGoalTile(goals[index]);
      },
    );
  }

  Widget _buildEmptyGoalsState() {
    return const BuildPlaceholder(
      icon: Icons.sports_soccer_outlined,
      message: 'No goals recorded yet.',
    );
  }

  Widget _buildGoalTile(Goal goal) {
    final isHomeTeam = goal.teamId == widget.match.homeTeamId;
    final canEdit = widget.match.status == MatchStatus.scheduled;

    return FutureBuilder(
      future: context.read<PlayerViewModel>().getPlayerById(goal.playerId),
      builder: (context, snapshot) {
        final playerName =
            snapshot.data?.name ??
            (snapshot.connectionState == ConnectionState.waiting
                ? 'Loading...'
                : 'Unknown player');

        return GestureDetector(
          onDoubleTap: canEdit ? () => _openEditGoalDialog(goal) : null,
          onLongPress: canEdit ? () => _confirmDeleteGoal(goal) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: isHomeTeam
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                if (isHomeTeam) ...[
                  const Icon(Icons.sports_soccer, size: 16),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    '$playerName ${goal.minute == null ? "—" : "(${goal.minute})"}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isHomeTeam) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.sports_soccer, size: 16),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteGoal(Goal goal) async {
    if (widget.match.status != MatchStatus.scheduled) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Goal?'),
        content: const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    final goalId = goal.id;
    final matchId = widget.match.id;

    if (goalId == null || matchId == null) {
      return;
    }

    final success = await context.read<GoalViewModel>().deleteGoal(
      goalId,
      matchId,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete goal.')));
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _loadTeams, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
