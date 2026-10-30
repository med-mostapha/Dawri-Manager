import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/generated/l10n.dart';
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

  Future<void> _deleteTeam(Team team) async {
    if (!await _checkCanModifyTeams()) return;

    if (!mounted) return;

    showDeleteDialog(
      context: context,
      title: S.of(context).deleteTeamTitle(team.name),
      message: S.of(context).confirmDeleteTeam,
      onConfirm: () => context.read<TeamViewModel>().deleteTeam(team),
    );
  }

  Future<bool> _checkCanModifyTeams() async {
    final canModify = await context.read<TeamViewModel>().canModifyTeams(
      widget.tournament.id!,
    );

    if (!mounted) return false;

    if (!canModify) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(S.of(context).scheduleAlreadyGenerated),
          content: Text(S.of(context).cannotModifyTeamsAfterSchedule),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(S.of(context).ok),
            ),
          ],
        ),
      );

      return false;
    }

    return true;
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
          message: S.of(context).noTeamYet,
        ),
        (_, _, final teams) => RefreshIndicator(
          onRefresh: () async {
            await viewModel.loadTeams(widget.tournament.id!);
          },
          child: Column(
            children: [
              _buildTeamsCount(teams.length),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 178, 134, 248),
                          child: Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          teams[index].name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${viewModel.playerCount(teams[index].id!)} ${S.of(context).players}',
                        ),
                        trailing: IconButton(
                          onPressed: () => _deleteTeam(teams[index]),
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                        ),
                        onLongPress: () =>
                            _editTeam(teams[index], widget.tournament.id!),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlayerPage(team: teams[index]),
                            ),
                          );

                          if (!mounted) return;

                          await viewModel.loadTeams(widget.tournament.id!);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      },

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTeamButton(widget.tournament.id!),
        icon: const Icon(Icons.add),
        label: Text(S.of(context).addTeam),
      ),
    );
  }

  Widget _buildTeamsCount(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            S.of(context).teamsCount(count),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _addTeamButton(int tournamentId) async {
    if (!await _checkCanModifyTeams()) return;

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (_) => AddTeamDialog(null, tournamentId: tournamentId),
    );
  }

  Future<void> _editTeam(Team team, int tournamentId) async {
    showDialog<void>(
      context: context,
      builder: (_) => AddTeamDialog(team, tournamentId: tournamentId),
    );
  }
}
