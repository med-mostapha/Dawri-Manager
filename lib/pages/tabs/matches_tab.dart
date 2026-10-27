import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/models/match.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';

class MatchesTab extends StatefulWidget {
  final Tournament tournament;

  const MatchesTab({super.key, required this.tournament});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  List<Match> _matches = [];
  Map<int, String> _teamNames = {};

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
      final teams = await _databaseHelper.getTeamsByTournament(
        widget.tournament.id!,
      );

      final matches = await _databaseHelper.getMatchesByTournament(
        widget.tournament.id!,
      );

      if (!mounted) return;

      setState(() {
        _teamNames = {
          for (final Team team in teams)
            if (team.id != null) team.id!: team.name,
        };
        _matches = matches;
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
    setState(() => _isGenerating = true);

    final success = await context.read<TournamentViewModel>().generateSchedule(
      widget.tournament,
    );

    if (!mounted) return;

    if (success) {
      await _loadData();
    } else {
      setState(() => _isGenerating = false);

      final error = context.read<TournamentViewModel>().error;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Failed to generate schedule.')),
      );
    }

    if (mounted) {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
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

    if (_matches.isEmpty) {
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
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                  _isGenerating ? 'Generating...' : 'Generate Schedule',
                ),
              ),
            ],
          ),
        ),
      );
    }

    final rounds = <int, List<Match>>{};

    for (final match in _matches) {
      rounds.putIfAbsent(match.roundNumber, () => []).add(match);
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined),
              const SizedBox(width: 8),
              Text(
                '${_matches.length} matches',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final roundNumber in rounds.keys.toList()..sort()) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(
                'Round $roundNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (final match in rounds[roundNumber]!)
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _teamNames[match.homeTeamId] ?? 'Unknown team',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            const Text(
                              'VS',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              match.status == MatchStatus.finished
                                  ? 'Finished'
                                  : 'Scheduled',
                              style: TextStyle(
                                fontSize: 11,
                                color: match.status == MatchStatus.finished
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _teamNames[match.awayTeamId] ?? 'Unknown team',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
