import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/goal.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/viewmodels/goal_view_model.dart';

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
          const SizedBox(height: 24),
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
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports_soccer_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No goals recorded yet.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTile(Goal goal) {
    final teamName = goal.teamId == widget.match.homeTeamId
        ? _homeTeam!.name
        : _awayTeam!.name;

    return FutureBuilder(
      future: _databaseHelper.getPlayerById(goal.playerId),
      builder: (context, snapshot) {
        final playerName =
            snapshot.data?.name ??
            (snapshot.connectionState == ConnectionState.waiting
                ? 'Loading player...'
                : 'Unknown player');

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: Text(playerName),
            subtitle: Text(
              '$teamName • ${goal.minute == null ? "Minute unknown" : "${goal.minute} min"}',
            ),
          ),
        );
      },
    );
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
