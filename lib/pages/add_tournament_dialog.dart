import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/utils/date_utils.dart';
import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';
import 'package:tournament_organizer/generated/l10n.dart';

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
  late MatchType _matchType;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.tournament?.name ?? '';
    _matchType = widget.tournament?.matchType ?? MatchType.homeAndAway;
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
        _nameError = S.of(context).enterChampionshipName;
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
          Tournament(name: name, createdAt: getNow(), matchType: _matchType),
        );
      } else {
        success = await viewModel.updateTournament(
          Tournament(
            id: tournament.id,
            name: name,
            createdAt: tournament.createdAt,
            matchType: _matchType,
          ),
          originalMatchType: tournament.matchType,
        );
      }

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
      } else {
        final error = viewModel.error;
        viewModel.clearError();

        setState(() => _isSaving = false);

        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(S.of(context).cannotSaveTournament),
            content: Text(error ?? S.of(context).pleaseTryAgain),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(S.of(context).ok),
              ),
            ],
          ),
        );
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
        widget.tournament == null
            ? S.of(context).addChampionship
            : S.of(context).editChampionship,
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
              hintText: S.of(context).championshipName,
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
          const SizedBox(height: 16),
          Text(
            S.of(context).matchFormat,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          RadioGroup<MatchType>(
            groupValue: _matchType,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _matchType = value;
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<MatchType>(
                  value: MatchType.singleRound,
                  title: Text(S.of(context).singleRound),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<MatchType>(
                  value: MatchType.homeAndAway,
                  title: Text(S.of(context).homeAndAway),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(S.of(context).cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveTournament,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.tournament == null
                      ? S.of(context).create
                      : S.of(context).saveChanges,
                ),
        ),
      ],
    );
  }
}
