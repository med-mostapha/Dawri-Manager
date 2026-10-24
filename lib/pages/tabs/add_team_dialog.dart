import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/models/team.dart';

import 'package:tournament_organizer/viewmodels/team_view_model.dart';

class AddTeamDialog extends StatefulWidget {
  final int tournamentId;
  final Team? team;
  const AddTeamDialog(this.team, {required this.tournamentId, super.key});

  @override
  State<AddTeamDialog> createState() => _AddTournamentDialogState();
}

class _AddTournamentDialogState extends State<AddTeamDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.team?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveTeam() async {
    final name = _nameController.text.trim();

    if (_isSaving) {
      return;
    }

    if (name.isEmpty) {
      setState(() {
        _nameError = 'Please enter a team name.';
      });
      return;
    }

    setState(() {
      _nameError = null;
      _isSaving = true;
    });

    final viewModel = context.read<TeamViewModel>();

    try {
      final team = widget.team;

      final bool success;

      if (team == null) {
        success = await viewModel.addTeam(
          Team(name: name, tournamentId: widget.tournamentId),
        );
      } else {
        success = await viewModel.updateTeam(
          Team(
            id: widget.team?.id,
            name: name,
            tournamentId: widget.tournamentId,
          ),
        );
      }

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.team == null
                  ? "Can't add Team. Please try again."
                  : "Can't update Team. Please try again.",
            ),
          ),
        );

        setState(() {
          _isSaving = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.team == null ? 'Add Team' : 'Edit Team'),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Team name',
          errorText: _nameError,
        ),
        onChanged: (value) {
          if (_nameError != null && value.trim().isNotEmpty) {
            setState(() {
              _nameError = null;
            });
          }
        },
        onSubmitted: (_) => _saveTeam(),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveTeam,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.team == null ? 'Create' : 'Save Changes'),
        ),
      ],
    );
  }
}
