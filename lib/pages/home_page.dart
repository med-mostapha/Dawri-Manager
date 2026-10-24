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
          (_, final String e, _) => Center(
            child: Text(e, style: TextStyle(color: Colors.redAccent)),
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
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TournamentDetailsPage(
                          tournament: tournament[index],
                        ),
                      ),
                    );
                  },
                  onLongPress: () => _editTournament(tournament[index]),
                  leading: Icon(
                    Icons.emoji_events,
                    color: Colors.amber, // gold color 🏆
                    size: 34,
                  ),
                  trailing: IconButton(
                    onPressed: () => _deleteTournament(tournament[index]),
                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                  ),
                  title: Text(tournament[index].name),
                  subtitle: Text(
                    tournament[index].createdAt,
                    style: TextStyle(fontSize: 10.0, color: Colors.brown),
                  ),
                ),
              );
            },
          ),
        },
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
