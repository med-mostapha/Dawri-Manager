// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Dawri Manager`
  String get pageHomeTitle {
    return Intl.message(
      'Dawri Manager',
      name: 'pageHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Players`
  String get players {
    return Intl.message('Players', name: 'players', desc: '', args: []);
  }

  /// `Players ({count})`
  String playersCount(int count) {
    return Intl.message(
      'Players ($count)',
      name: 'playersCount',
      desc: '',
      args: [count],
    );
  }

  /// `Age: {age}`
  String playerAge(int age) {
    return Intl.message('Age: $age', name: 'playerAge', desc: '', args: [age]);
  }

  /// `Are you sure you want to delete this player?`
  String get confirmDeletePlayer {
    return Intl.message(
      'Are you sure you want to delete this player?',
      name: 'confirmDeletePlayer',
      desc: '',
      args: [],
    );
  }

  /// `No players yet`
  String get noPlayersYet {
    return Intl.message(
      'No players yet',
      name: 'noPlayersYet',
      desc: '',
      args: [],
    );
  }

  /// `Add Player`
  String get addPlayer {
    return Intl.message('Add Player', name: 'addPlayer', desc: '', args: []);
  }

  /// `Edit Player`
  String get editPlayer {
    return Intl.message('Edit Player', name: 'editPlayer', desc: '', args: []);
  }

  /// `Player name`
  String get playerName {
    return Intl.message('Player name', name: 'playerName', desc: '', args: []);
  }

  /// `Age (optional)`
  String get playerAgeOptional {
    return Intl.message(
      'Age (optional)',
      name: 'playerAgeOptional',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get playerAgeText {
    return Intl.message('Age', name: 'playerAgeText', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Player name is required.`
  String get playerNameRequired {
    return Intl.message(
      'Player name is required.',
      name: 'playerNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Age must be between 1 and 99.`
  String get invalidPlayerAge {
    return Intl.message(
      'Age must be between 1 and 99.',
      name: 'invalidPlayerAge',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Can't add player. Please try again.`
  String get addPlayerFailed {
    return Intl.message(
      'Can\'t add player. Please try again.',
      name: 'addPlayerFailed',
      desc: '',
      args: [],
    );
  }

  /// `Can't update player. Please try again.`
  String get updatePlayerFailed {
    return Intl.message(
      'Can\'t update player. Please try again.',
      name: 'updatePlayerFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delete player`
  String get deletePlayer {
    return Intl.message(
      'Delete player',
      name: 'deletePlayer',
      desc: '',
      args: [],
    );
  }

  /// `Teams ({count})`
  String teamsCount(int count) {
    return Intl.message(
      'Teams ($count)',
      name: 'teamsCount',
      desc: '',
      args: [count],
    );
  }

  /// `No Teams Yet`
  String get noTeamYet {
    return Intl.message('No Teams Yet', name: 'noTeamYet', desc: '', args: []);
  }

  /// `Add Team`
  String get addTeam {
    return Intl.message('Add Team', name: 'addTeam', desc: '', args: []);
  }

  /// `Edit Team`
  String get editTeam {
    return Intl.message('Edit Team', name: 'editTeam', desc: '', args: []);
  }

  /// `Team name`
  String get teamName {
    return Intl.message('Team name', name: 'teamName', desc: '', args: []);
  }

  /// `Please enter a team name.`
  String get teamNameRequired {
    return Intl.message(
      'Please enter a team name.',
      name: 'teamNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `A team with this name may already exist in this tournament.`
  String get duplicateTeamName {
    return Intl.message(
      'A team with this name may already exist in this tournament.',
      name: 'duplicateTeamName',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred.`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Delete {teamName}?`
  String deleteTeamTitle(String teamName) {
    return Intl.message(
      'Delete $teamName?',
      name: 'deleteTeamTitle',
      desc: '',
      args: [teamName],
    );
  }

  /// `Are you sure you want to delete this team?`
  String get confirmDeleteTeam {
    return Intl.message(
      'Are you sure you want to delete this team?',
      name: 'confirmDeleteTeam',
      desc: '',
      args: [],
    );
  }

  /// `Schedule already generated`
  String get scheduleAlreadyGenerated {
    return Intl.message(
      'Schedule already generated',
      name: 'scheduleAlreadyGenerated',
      desc: '',
      args: [],
    );
  }

  /// `You cannot add, edit, or delete teams after generating the schedule.`
  String get cannotModifyTeamsAfterSchedule {
    return Intl.message(
      'You cannot add, edit, or delete teams after generating the schedule.',
      name: 'cannotModifyTeamsAfterSchedule',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `No matches yet`
  String get noMatchesYet {
    return Intl.message(
      'No matches yet',
      name: 'noMatchesYet',
      desc: '',
      args: [],
    );
  }

  /// `Add at least two teams to generate the schedule.`
  String get addTwoTeamsToGenerateSchedule {
    return Intl.message(
      'Add at least two teams to generate the schedule.',
      name: 'addTwoTeamsToGenerateSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Generating...`
  String get generating {
    return Intl.message(
      'Generating...',
      name: 'generating',
      desc: '',
      args: [],
    );
  }

  /// `Generate Schedule`
  String get generateSchedule {
    return Intl.message(
      'Generate Schedule',
      name: 'generateSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `{count} matches`
  String matchesCount(int count) {
    return Intl.message(
      '$count matches',
      name: 'matchesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Round {number}`
  String roundTitle(int number) {
    return Intl.message(
      'Round $number',
      name: 'roundTitle',
      desc: '',
      args: [number],
    );
  }

  /// `Unknown team`
  String get unknownTeam {
    return Intl.message(
      'Unknown team',
      name: 'unknownTeam',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message('Finished', name: 'finished', desc: '', args: []);
  }

  /// `Scheduled`
  String get scheduled {
    return Intl.message('Scheduled', name: 'scheduled', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
