import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/models/player.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/viewmodels/player_view_model.dart';
import 'package:tournament_organizer/widgets/alert_dialog.dart';
import 'package:tournament_organizer/widgets/build_placeholder.dart';
import 'package:tournament_organizer/pages/tabs/add_player_dialog.dart';

class PlayerPage extends StatefulWidget {
  final Team team;

  const PlayerPage({super.key, required this.team});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<PlayerViewModel>().loadPlayers(widget.team.id!);
    });
  }

  void _deletePlayer(Player player) {
    showDeleteDialog(
      context: context,
      title: 'Delete ${player.name}?',
      message: 'Are you sure you want to delete this player?',
      onConfirm: () async {
        await context.read<PlayerViewModel>().deletePlayer(player);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlayerViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text('${widget.team.name} Players')),
      body: switch ((viewModel.isLoading, viewModel.error, viewModel.players)) {
        (true, _, _) => const Center(child: CircularProgressIndicator()),
        (_, final String error, _) => Center(
          child: Text(error, style: const TextStyle(color: Colors.redAccent)),
        ),
        (_, _, final players) when players.isEmpty => const BuildPlaceholder(
          icon: Icons.person_outline,
          message: 'No players yet',
        ),
        (_, _, final players) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];

            return Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(
                  player.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: player.age == null
                    ? null
                    : Text('Age: ${player.age}'),
                onLongPress: () => _editPlayer(player),
                trailing: IconButton(
                  onPressed: () => _deletePlayer(player),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            );
          },
        ),
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (_) => AddPlayerDialog(teamId: widget.team.id!),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Player'),
      ),
    );
  }

  void _editPlayer(Player player) {
    showDialog<void>(
      context: context,
      builder: (_) => AddPlayerDialog(teamId: widget.team.id!, player: player),
    );
  }
}
