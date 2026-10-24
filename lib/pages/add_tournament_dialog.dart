import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/utils/date_utils.dart';
import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';

class AddTournamentDialog extends StatefulWidget {
  final Tournament? tournament;
  const AddTournamentDialog(this.tournament, {super.key});

  @override
  State<AddTournamentDialog> createState() => _AddTournamentDialogState();
}

class _AddTournamentDialogState extends State<AddTournamentDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.tournament?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveTournament() async {
    final name = _nameController.text.trim();

    if (_isSaving) {
      return;
    }

    if (name.isEmpty) {
      setState(() {
        _nameError = 'Please enter a championship name.';
      });
      return;
    }

    setState(() {
      _nameError = null;
      _isSaving = true;
    });

    final viewModel = context.read<TournamentViewModel>();

    try {
      final tournament = widget.tournament;

      final bool success;

      if (tournament == null) {
        success = await viewModel.addTournament(
          Tournament(name: name, createdAt: getNow()),
        );
      } else {
        success = await viewModel.updateTournament(
          Tournament(
            id: tournament.id,
            name: name,
            createdAt: tournament.createdAt,
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
              widget.tournament == null
                  ? "Can't add tournament. Please try again."
                  : "Can't update tournament. Please try again.",
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
      title: Text(
        widget.tournament == null ? 'Add Championship' : 'Edit Championship',
      ),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Championship name',
          errorText: _nameError,
        ),
        onChanged: (value) {
          if (_nameError != null && value.trim().isNotEmpty) {
            setState(() {
              _nameError = null;
            });
          }
        },
        onSubmitted: (_) => _saveTournament(),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveTournament,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.tournament == null ? 'Create' : 'Save Changes'),
        ),
      ],
    );
  }
}
