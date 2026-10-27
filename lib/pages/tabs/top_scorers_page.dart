import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/tournament.dart';
import '../../viewmodels/top_scorers_view_model.dart';

class TopScorersPage extends StatefulWidget {
  final Tournament tournament;

  const TopScorersPage({super.key, required this.tournament});

  @override
  State<TopScorersPage> createState() => _TopScorersPageState();
}

class _TopScorersPageState extends State<TopScorersPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<TopScorersViewModel>().loadTopScorers(widget.tournament.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopScorersViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(viewModel.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.loadTopScorers(widget.tournament.id!);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (viewModel.topScorers.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => viewModel.loadTopScorers(widget.tournament.id!),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 140),
                Icon(
                  Icons.sports_soccer_outlined,
                  size: 56,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    'No goals scored yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.loadTopScorers(widget.tournament.id!),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FixedColumnWidth(60),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade300),
                ),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
                    children: [
                      _HeaderCell('Player'),
                      _HeaderCell('Team'),
                      _HeaderCell('Goals'),
                    ],
                  ),
                  ...List.generate(viewModel.topScorers.length, (index) {
                    final scorer = viewModel.topScorers[index];

                    return TableRow(
                      children: [
                        _BodyCell(scorer.playerName),
                        _BodyCell(scorer.teamName),
                        _BodyCell(
                          '${scorer.goals}',
                          centered: true,
                          bold: true,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  final bool centered;
  final bool bold;

  const _BodyCell(this.text, {this.centered = false, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Text(
        text,
        textAlign: centered ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
