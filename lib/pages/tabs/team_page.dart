import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/models/team.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/pages/tabs/add_team_dialog.dart';
import 'package:tournament_organizer/viewmodels/team_view_model.dart';
import 'package:tournament_organizer/widgets/alert_dialog.dart';
import 'package:tournament_organizer/widgets/build_placeholder.dart';
import 'package:tournament_organizer/pages/tabs/player_page.dart';

class TeamPage extends StatefulWidget {
  final Tournament tournament;
  const TeamPage({required this.tournament, super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamViewModel>().loadTeams(widget.tournament.id!);
    });
  }

  void _deleteTeam(Team t) {
    showDeleteDialog(
      context: context,
      title: 'Delete ${t.name} ?',
      message: 'Are you sure you want to delete?',
      onConfirm: () => context.read<TeamViewModel>().deleteTeam(t),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TeamViewModel>();
    return Scaffold(
      body: switch ((viewModel.isLoading, viewModel.error, viewModel.teams)) {
        (true, _, _) => const Center(child: CircularProgressIndicator()),
        (_, final String error, _) => Center(
          child: Text(error, style: TextStyle(color: Colors.redAccent)),
        ),
        (_, _, final teams) when teams.isEmpty => BuildPlaceholder(
          icon: Icons.groups_outlined,
          message: "No teams yet",
        ),
        (_, _, final teams) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 178, 134, 248),
                  child: Icon(Icons.shield_outlined, color: Colors.white),
                ),
                title: Text(
                  teams[index].name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Team ${index + 1}'),
                trailing: IconButton(
                  onPressed: () => _deleteTeam(teams[index]),
                  icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
                onLongPress: () =>
                    _editTeam(teams[index], widget.tournament.id!),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlayerPage(team: teams[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      },

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTeamButton(widget.tournament.id!),
        icon: const Icon(Icons.add),
        label: const Text('Add Team'),
      ),
    );
  }

  void _addTeamButton(int tournamentId) {
    showDialog<void>(
      context: context,
      builder: (_) => AddTeamDialog(null, tournamentId: tournamentId),
    );
  }

  void _editTeam(Team team, int tournamentId) {
    showDialog<void>(
      context: context,
      builder: (_) => AddTeamDialog(team, tournamentId: tournamentId),
    );
  }
}
