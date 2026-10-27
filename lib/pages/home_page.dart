import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/pages/add_tournament_dialog.dart';
import 'package:tournament_organizer/pages/tournament_details_page.dart';

import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';
import 'package:tournament_organizer/widgets/alert_dialog.dart';
import 'package:tournament_organizer/widgets/build_placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TournamentViewModel>().loadTournaments();
    });
  }

  void _deleteTournament(Tournament t) {
    showDeleteDialog(
      context: context,
      title: 'Delete ${t.name} ?',
      message: 'Are you sure you want to delete?',
      onConfirm: () =>
          context.read<TournamentViewModel>().deleteTournament(t.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TournamentViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => viewModel.loadTournaments(),
            tooltip: 'Refresh matches',
            icon: const Icon(Icons.refresh),
          ),
        ],
        // backgroundColor: Theme.of(context).primaryColor,
        // titleTextStyle: TextStyle(color: Colors.white),
      ),
      floatingActionButton: _addTournamentButton(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: switch ((
          viewModel.isLoading,
          viewModel.error,
          viewModel.tournaments,
        )) {
          (true, _, _) => const Center(child: CircularProgressIndicator()),
          (_, final String e, _) => ListView(
            children: [
              const SizedBox(height: 100),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      e,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => viewModel.loadTournaments(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reload tournaments'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          (_, _, final tournament) when tournament.isEmpty => Center(
            child: const BuildPlaceholder(
              icon: Icons.emoji_events,
              message: 'No tournament yet!',
            ),
          ),
          (_, _, final tournament) => ListView.builder(
            itemCount: tournament.length,
            itemBuilder: (context, index) {
              return _tournamentCard(tournament[index]);
            },
          ),
        },
      ),
    );
  }

  Widget _tournamentCard(Tournament tournament) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  TournamentDetailsPage(tournament: tournament),
            ),
          );
        },
        onLongPress: () => _editTournament(tournament),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: Colors.amber,
            size: 28,
          ),
        ),
        title: Text(
          tournament.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tournament.createdAt,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    tournament.matchType == MatchType.singleRound
                        ? Icons.looks_one_outlined
                        : Icons.sync_rounded,
                    size: 16,
                    color: Colors.blueGrey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tournament.matchType == MatchType.singleRound
                        ? 'Aller simple'
                        : 'Aller-retour',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: IconButton(
          tooltip: 'Delete championship',
          onPressed: () => _deleteTournament(tournament),
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  Widget _addTournamentButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) => const AddTournamentDialog(null),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  void _editTournament(Tournament tournament) {
    showDialog<void>(
      context: context,
      builder: (_) => AddTournamentDialog(tournament),
    );
  }
}
