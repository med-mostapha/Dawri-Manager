import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/models/team_standing.dart';
import 'package:tournament_organizer/viewmodels/standings_view_model.dart';
import 'package:tournament_organizer/generated/l10n.dart';

class StandingsPage extends StatefulWidget {
  final Tournament tournament;

  const StandingsPage({super.key, required this.tournament});

  @override
  State<StandingsPage> createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  final Map<String, bool> _visibleColumns = {
    'played': true,
    'won': true,
    'drawn': true,
    'lost': true,
    'goalsFor': true,
    'goalsAgainst': true,
    'goalDifference': true,
    'points': true,
  };
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
                label: Text(S.of(context).retry),
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
          children: [
            SizedBox(height: 120),
            Icon(Icons.emoji_events_outlined, size: 56, color: Colors.grey),
            SizedBox(height: 16),
            Center(
              child: Center(
                child: Text(
                  S.of(context).noStandingsYet,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                S.of(context).addTeamsAndFinishMatches,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _showColumnSettings,
                icon: const Icon(Icons.tune),
                tooltip: 'Column Settings',
              ),
            ],
          ),
          _buildStandingsTable(viewModel.standings),
          const SizedBox(height: 12),
          Text(
            S.of(context).standingsLegend,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
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
        Expanded(
          flex: 1,
          child: _SummaryItem(
            label: S.of(context).teams,
            value: '${standings.length}',
          ),
        ),
        Expanded(
          flex: 2,
          child: _SummaryItem(
            label: S.of(context).matchesPlayed,
            value: '$totalPlayed',
          ),
        ),
        Expanded(
          flex: 2,
          child: _SummaryItem(
            label: S.of(context).leader,
            value: standings.first.teamName,
          ),
        ),
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
        columns: [
          DataColumn(label: Text('#', style: headingStyle)),
          DataColumn(label: Text(S.of(context).team, style: headingStyle)),
          if (_visibleColumns['played']!)
            DataColumn(
              label: Text(S.of(context).played, style: headingStyle),
              numeric: true,
            ),
          if (_visibleColumns['won']!)
            DataColumn(
              label: Text(S.of(context).won, style: headingStyle),
              numeric: true,
            ),
          if (_visibleColumns['drawn']!)
            DataColumn(
              label: Text(S.of(context).drawn, style: headingStyle),
              numeric: true,
            ),
          if (_visibleColumns['lost']!)
            DataColumn(
              label: Text(S.of(context).lost, style: headingStyle),
              numeric: true,
            ),
          if (_visibleColumns['goalsFor']!)
            DataColumn(
              label: Text(S.of(context).goalsFor, style: headingStyle),
              numeric: true,
            ),
          if (_visibleColumns['goalsAgainst']!)
            DataColumn(
              label: Text(S.of(context).goalsAgainst, style: headingStyle),
              numeric: true,
            ),
          if (_visibleColumns['goalDifference']!)
            DataColumn(
              label: Text(S.of(context).goalDifference, style: headingStyle),
              numeric: true,
            ),
          if (_visibleColumns['points']!)
            DataColumn(
              label: Text(S.of(context).points, style: headingStyle),
              numeric: true,
            ),
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
              if (_visibleColumns['played']!) DataCell(Text('${team.played}')),
              if (_visibleColumns['won']!) DataCell(Text('${team.won}')),
              if (_visibleColumns['drawn']!) DataCell(Text('${team.drawn}')),
              if (_visibleColumns['lost']!) DataCell(Text('${team.lost}')),
              if (_visibleColumns['goalsFor']!)
                DataCell(Text('${team.goalsFor}')),
              if (_visibleColumns['goalsAgainst']!)
                DataCell(Text('${team.goalsAgainst}')),
              if (_visibleColumns['goalDifference']!)
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
              if (_visibleColumns['points']!)
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

  void _showColumnSettings() {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(S.of(context).close),
                ),
              ],
              title: const Text('Column Settings'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // Played
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).played),
                                value: _visibleColumns['played'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['played'] = value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                              // Won
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).won),
                                value: _visibleColumns['won'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['won'] = value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                              // Drawn
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).drawn),
                                value: _visibleColumns['drawn'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['drawn'] = value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                              // Lost
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).lost),
                                value: _visibleColumns['lost'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['lost'] = value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              // Goals For
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).goalsFor),
                                value: _visibleColumns['goalsFor'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['goalsFor'] =
                                        value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                              // Goals Against
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).goalsAgainst),
                                value: _visibleColumns['goalsAgainst'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['goalsAgainst'] =
                                        value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                              // Goal Difference
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).goalDifference),
                                value: _visibleColumns['goalDifference'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['goalDifference'] =
                                        value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                              // Points
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(S.of(context).points),
                                value: _visibleColumns['points'],
                                onChanged: (value) {
                                  setDialogState(() {
                                    _visibleColumns['points'] = value ?? false;
                                  });
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
