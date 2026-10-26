import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/models/player.dart';
import 'package:tournament_organizer/viewmodels/player_view_model.dart';
import 'package:flutter/services.dart';

class AddPlayerDialog extends StatefulWidget {
  final int teamId;
  final Player? player;

  const AddPlayerDialog({super.key, required this.teamId, this.player});

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  bool _isSaving = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.player?.name ?? '';
    _ageController.text = widget.player?.age?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _savePlayer() async {
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();

    if (_isSaving) return;

    if (name.isEmpty) {
      setState(() {
        _validationError = 'Player name is required.';
      });
      return;
    }
    final age = ageText.isEmpty ? null : int.tryParse(ageText);

    if (ageText.isNotEmpty && (age == null || age < 1 || age > 99)) {
      setState(() {
        _validationError = 'Age must be between 1 and 99.';
      });
      return;
    }
    setState(() {
      _isSaving = true;
      _validationError = null;
    });

    final viewModel = context.read<PlayerViewModel>();
    final player = widget.player;

    final bool success;

    if (player == null) {
      success = await viewModel.addPlayer(
        Player(teamId: widget.teamId, name: name, age: age),
      );
    } else {
      success = await viewModel.updatePlayer(
        Player(id: player.id, teamId: widget.teamId, name: name, age: age),
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isSaving = false;
        _validationError = widget.player == null
            ? "Can't add player. Please try again."
            : "Can't update player. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.player == null ? 'Add Player' : 'Edit Player'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (_) {
              if (_validationError != null) {
                setState(() {
                  _validationError = null;
                });
              }
            },
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Player name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _savePlayer(),
          ),
          const SizedBox(height: 12),
          TextField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onChanged: (_) {
              if (_validationError != null) {
                setState(() {
                  _validationError = null;
                });
              }
            },
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age (optional)',
              hintText: 'Unknown',
              border: OutlineInputBorder(),
            ),
          ),
          if (_validationError != null) ...[
            const SizedBox(height: 12),
            Text(
              _validationError!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(widget.player == null ? 'Create' : 'Save Changes'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _savePlayer,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
