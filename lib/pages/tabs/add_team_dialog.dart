import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/generated/l10n.dart';
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
  String? _saveError;

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
        _nameError = S.of(context).teamNameRequired;
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
        setState(() {
          _isSaving = false;
          _saveError = S.of(context).duplicateTeamName;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).unexpectedError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.team == null ? S.of(context).addTeam : S.of(context).editTeam,
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: S.of(context).teamName,
              errorText: _nameError,
            ),
            onChanged: (value) {
              if (_nameError != null && value.trim().isNotEmpty) {
                setState(() {
                  _nameError = null;
                });
              }

              if (_saveError != null) {
                setState(() {
                  _saveError = null;
                });
              }
            },
            onSubmitted: (_) => _saveTeam(),
          ),
          if (_saveError != null) ...[
            const SizedBox(height: 12),
            Text(
              _saveError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),

      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(S.of(context).cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveTeam,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.team == null
                      ? S.of(context).create
                      : S.of(context).saveChanges,
                ),
        ),
      ],
    );
  }
}
