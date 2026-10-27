import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/models/team_standing.dart';
import 'package:tournament_organizer/viewmodels/standings_view_model.dart';

class StandingsPage extends StatefulWidget {
  final Tournament tournament;

  const StandingsPage({super.key, required this.tournament});

  @override
  State<StandingsPage> createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<StandingsViewModel>().loadStandings(widget.tournament.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StandingsViewModel>();

    if (viewModel.isLoading && viewModel.standings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null && viewModel.standings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 42,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(viewModel.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  viewModel.loadStandings(widget.tournament.id!);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.standings.isEmpty) {
      return RefreshIndicator(
        onRefresh: () {
          return viewModel.loadStandings(widget.tournament.id!);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Icon(Icons.emoji_events_outlined, size: 56, color: Colors.grey),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No standings yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Add teams and finish matches to see the standings.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return viewModel.loadStandings(widget.tournament.id!);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        children: [
          _buildSummary(viewModel.standings),
          const SizedBox(height: 16),
          _buildStandingsTable(viewModel.standings),
          const SizedBox(height: 12),
          const Text(
            'P: Played  W: Won  D: Drawn  L: Lost\n'
            'GF: Goals For  GA: Goals Against  GD: Goal Difference  PTS: Points',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<TeamStanding> standings) {
    final totalPlayed = standings.fold<int>(
      0,
      (total, team) => total + team.played,
    );

    return Row(
      children: [
        _SummaryItem(label: 'Teams', value: '${standings.length}'),
        _SummaryItem(label: 'Matches played', value: '$totalPlayed'),
        _SummaryItem(label: 'Leader', value: standings.first.teamName),
      ],
    );
  }

  Widget _buildStandingsTable(List<TeamStanding> standings) {
    const headingStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 12,
        columnSpacing: 18,
        headingRowHeight: 44,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 56,
        columns: const [
          DataColumn(label: Text('#', style: headingStyle)),
          DataColumn(label: Text('Team', style: headingStyle)),
          DataColumn(label: Text('P', style: headingStyle), numeric: true),
          DataColumn(label: Text('W', style: headingStyle), numeric: true),
          DataColumn(label: Text('D', style: headingStyle), numeric: true),
          DataColumn(label: Text('L', style: headingStyle), numeric: true),
          DataColumn(label: Text('GF', style: headingStyle), numeric: true),
          DataColumn(label: Text('GA', style: headingStyle), numeric: true),
          DataColumn(label: Text('GD', style: headingStyle), numeric: true),
          DataColumn(label: Text('PTS', style: headingStyle), numeric: true),
        ],
        rows: List.generate(standings.length, (index) {
          final team = standings[index];
          final isLeader = index == 0;

          return DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 22,
                  child: isLeader
                      ? const Icon(
                          Icons.emoji_events,
                          size: 19,
                          color: Color(0xFFB8860B),
                        )
                      : Text('${index + 1}'),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100,
                  child: Text(
                    team.teamName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: isLeader ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(Text('${team.played}')),
              DataCell(Text('${team.won}')),
              DataCell(Text('${team.drawn}')),
              DataCell(Text('${team.lost}')),
              DataCell(Text('${team.goalsFor}')),
              DataCell(Text('${team.goalsAgainst}')),
              DataCell(
                Text(
                  team.goalDifference > 0
                      ? '+${team.goalDifference}'
                      : '${team.goalDifference}',
                  style: TextStyle(
                    color: team.goalDifference > 0
                        ? Colors.green.shade700
                        : team.goalDifference < 0
                        ? Colors.red.shade700
                        : null,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${team.points}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLeader ? Colors.green.shade700 : null,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
