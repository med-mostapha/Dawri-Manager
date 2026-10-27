import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/pages/tabs/match_details_page.dart';
import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';
import 'package:tournament_organizer/models/goal.dart';

class MatchesPage extends StatefulWidget {
  final Tournament tournament;

  const MatchesPage({super.key, required this.tournament});

  @override
  State<MatchesPage> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  List<Match> _matches = [];
  Map<int, String> _teamNames = {};
  Map<int, List<Goal>> _goalsByMatch = {};
  bool _isLoading = true;
  bool _isGenerating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tournamentId = widget.tournament.id!;

      final results = await Future.wait([
        _databaseHelper.getTeamsByTournament(tournamentId),
        _databaseHelper.getMatchesByTournament(tournamentId),
      ]);

      final teams = results[0] as List<Team>;
      final matches = results[1] as List<Match>;

      final matchesWithIds = matches
          .where((match) => match.id != null)
          .toList();

      final goalsLists = await Future.wait(
        matchesWithIds.map(
          (match) => _databaseHelper.getGoalsByMatch(match.id!),
        ),
      );

      final goalsByMatch = <int, List<Goal>>{};

      for (var i = 0; i < matchesWithIds.length; i++) {
        goalsByMatch[matchesWithIds[i].id!] = goalsLists[i];
      }

      if (!mounted) return;

      setState(() {
        _teamNames = {
          for (final team in teams)
            if (team.id != null) team.id!: team.name,
        };

        _matches = matches;
        _goalsByMatch = goalsByMatch;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Failed to load matches.';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateSchedule() async {
    if (_isGenerating) return;

    setState(() => _isGenerating = true);

    final success = await context.read<TournamentViewModel>().generateSchedule(
      widget.tournament,
    );

    if (!mounted) return;

    if (success) {
      await _loadData();
    } else {
      final error = context.read<TournamentViewModel>().error;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Failed to generate schedule.')),
      );
    }

    if (mounted) {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _openMatchDetails(Match match) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MatchDetailsPage(match: match)),
    );

    if (!mounted) return;

    await _loadData();
  }

  Map<int, List<Match>> _groupMatchesByRound() {
    final rounds = <int, List<Match>>{};

    for (final match in _matches) {
      rounds.putIfAbsent(match.roundNumber, () => []).add(match);
    }

    return rounds;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_matches.isEmpty) {
      return _buildEmptyState();
    }

    final rounds = _groupMatchesByRound();
    final roundNumbers = rounds.keys.toList()..sort();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMatchesHeader(),
          const SizedBox(height: 8),
          for (final roundNumber in roundNumbers) ...[
            _buildRoundTitle(roundNumber),
            for (final match in rounds[roundNumber]!) _buildMatchCard(match),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchesHeader() {
    return Row(
      children: [
        const Icon(Icons.calendar_month_outlined),
        const SizedBox(width: 8),
        Text(
          '${_matches.length} matches',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Refresh',
          onPressed: _loadData,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildRoundTitle(int roundNumber) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        'Round $roundNumber',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMatchCard(Match match) {
    final homeTeam = _teamNames[match.homeTeamId] ?? 'Unknown team';

    final awayTeam = _teamNames[match.awayTeamId] ?? 'Unknown team';

    final isFinished = match.status == MatchStatus.finished;

    final goals = match.id == null ? <Goal>[] : _goalsByMatch[match.id!] ?? [];

    final homeScore = goals
        .where((goal) => goal.teamId == match.homeTeamId)
        .length;

    final awayScore = goals
        .where((goal) => goal.teamId == match.awayTeamId)
        .length;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openMatchDetails(match),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  homeTeam,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      isFinished ? '$homeScore - $awayScore' : 'VS',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isFinished ? 'Finished' : 'Scheduled',
                      style: TextStyle(
                        fontSize: 11,
                        color: isFinished ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  awayTeam,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            const Text(
              'No matches yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add at least two teams to generate the schedule.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isGenerating ? null : _generateSchedule,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                _isGenerating ? 'Generating...' : 'Generate Schedule',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_error!),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: _loadData, child: const Text('Retry')),
        ],
      ),
    );
  }
}
