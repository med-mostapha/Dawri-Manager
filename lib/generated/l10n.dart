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

  /// `Reopen Match?`
  String get reopenMatchTitle {
    return Intl.message(
      'Reopen Match?',
      name: 'reopenMatchTitle',
      desc: '',
      args: [],
    );
  }

  /// `Finish Match?`
  String get finishMatchTitle {
    return Intl.message(
      'Finish Match?',
      name: 'finishMatchTitle',
      desc: '',
      args: [],
    );
  }

  /// `This match will become editable again.`
  String get reopenMatchMessage {
    return Intl.message(
      'This match will become editable again.',
      name: 'reopenMatchMessage',
      desc: '',
      args: [],
    );
  }

  /// `The result will count in the standings and top scorers.`
  String get finishMatchMessage {
    return Intl.message(
      'The result will count in the standings and top scorers.',
      name: 'finishMatchMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reopen`
  String get reopen {
    return Intl.message('Reopen', name: 'reopen', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Invalid match ID.`
  String get invalidMatchId {
    return Intl.message(
      'Invalid match ID.',
      name: 'invalidMatchId',
      desc: '',
      args: [],
    );
  }

  /// `Match status was not changed. Please refresh.`
  String get matchStatusNotChanged {
    return Intl.message(
      'Match status was not changed. Please refresh.',
      name: 'matchStatusNotChanged',
      desc: '',
      args: [],
    );
  }

  /// `Match reopened.`
  String get matchReopened {
    return Intl.message(
      'Match reopened.',
      name: 'matchReopened',
      desc: '',
      args: [],
    );
  }

  /// `Match finished.`
  String get matchFinished {
    return Intl.message(
      'Match finished.',
      name: 'matchFinished',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update match status.`
  String get updateMatchStatusFailed {
    return Intl.message(
      'Failed to update match status.',
      name: 'updateMatchStatusFailed',
      desc: '',
      args: [],
    );
  }

  /// `Match Details`
  String get matchDetails {
    return Intl.message(
      'Match Details',
      name: 'matchDetails',
      desc: '',
      args: [],
    );
  }

  /// `Reopen the match before adding goals.`
  String get reopenMatchBeforeAddingGoals {
    return Intl.message(
      'Reopen the match before adding goals.',
      name: 'reopenMatchBeforeAddingGoals',
      desc: '',
      args: [],
    );
  }

  /// `Add Goal`
  String get addGoal {
    return Intl.message('Add Goal', name: 'addGoal', desc: '', args: []);
  }

  /// `Goals`
  String get goals {
    return Intl.message('Goals', name: 'goals', desc: '', args: []);
  }

  /// `{count} goals`
  String goalsCount(Object count) {
    return Intl.message(
      '$count goals',
      name: 'goalsCount',
      desc: '',
      args: [count],
    );
  }

  /// `No goals recorded yet.`
  String get noGoalsRecordedYet {
    return Intl.message(
      'No goals recorded yet.',
      name: 'noGoalsRecordedYet',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Unknown player`
  String get unknownPlayer {
    return Intl.message(
      'Unknown player',
      name: 'unknownPlayer',
      desc: '',
      args: [],
    );
  }

  /// `Delete Goal?`
  String get deleteGoalTitle {
    return Intl.message(
      'Delete Goal?',
      name: 'deleteGoalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this goal?`
  String get confirmDeleteGoal {
    return Intl.message(
      'Are you sure you want to delete this goal?',
      name: 'confirmDeleteGoal',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Failed to delete goal.`
  String get deleteGoalFailed {
    return Intl.message(
      'Failed to delete goal.',
      name: 'deleteGoalFailed',
      desc: '',
      args: [],
    );
  }

  /// `Could not find both teams.`
  String get couldNotFindBothTeams {
    return Intl.message(
      'Could not find both teams.',
      name: 'couldNotFindBothTeams',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load teams.`
  String get failedToLoadTeams {
    return Intl.message(
      'Failed to load teams.',
      name: 'failedToLoadTeams',
      desc: '',
      args: [],
    );
  }

  /// `Edit Goal`
  String get editGoal {
    return Intl.message('Edit Goal', name: 'editGoal', desc: '', args: []);
  }

  /// `Save Goal`
  String get saveGoal {
    return Intl.message('Save Goal', name: 'saveGoal', desc: '', args: []);
  }

  /// `Update Goal`
  String get updateGoal {
    return Intl.message('Update Goal', name: 'updateGoal', desc: '', args: []);
  }

  /// `Team`
  String get team {
    return Intl.message('Team', name: 'team', desc: '', args: []);
  }

  /// `Player`
  String get player {
    return Intl.message('Player', name: 'player', desc: '', args: []);
  }

  /// `Select a team first`
  String get selectTeamFirst {
    return Intl.message(
      'Select a team first',
      name: 'selectTeamFirst',
      desc: '',
      args: [],
    );
  }

  /// `Select a player`
  String get selectPlayer {
    return Intl.message(
      'Select a player',
      name: 'selectPlayer',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get minute {
    return Intl.message('Minute', name: 'minute', desc: '', args: []);
  }

  /// `Failed to load players.`
  String get failedToLoadPlayers {
    return Intl.message(
      'Failed to load players.',
      name: 'failedToLoadPlayers',
      desc: '',
      args: [],
    );
  }

  /// `Please select a team.`
  String get pleaseSelectTeam {
    return Intl.message(
      'Please select a team.',
      name: 'pleaseSelectTeam',
      desc: '',
      args: [],
    );
  }

  /// `Please select a player.`
  String get pleaseSelectPlayer {
    return Intl.message(
      'Please select a player.',
      name: 'pleaseSelectPlayer',
      desc: '',
      args: [],
    );
  }

  /// `The match ID is missing.`
  String get matchIdMissing {
    return Intl.message(
      'The match ID is missing.',
      name: 'matchIdMissing',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save the goal.`
  String get failedToSaveGoal {
    return Intl.message(
      'Failed to save the goal.',
      name: 'failedToSaveGoal',
      desc: '',
      args: [],
    );
  }

  /// `Increase by {amount}`
  String increaseBy(int amount) {
    return Intl.message(
      'Increase by $amount',
      name: 'increaseBy',
      desc: '',
      args: [amount],
    );
  }

  /// `Decrease by {amount}`
  String decreaseBy(int amount) {
    return Intl.message(
      'Decrease by $amount',
      name: 'decreaseBy',
      desc: '',
      args: [amount],
    );
  }

  /// `No standings yet`
  String get noStandingsYet {
    return Intl.message(
      'No standings yet',
      name: 'noStandingsYet',
      desc: '',
      args: [],
    );
  }

  /// `Add teams and finish matches to see the standings.`
  String get addTeamsAndFinishMatches {
    return Intl.message(
      'Add teams and finish matches to see the standings.',
      name: 'addTeamsAndFinishMatches',
      desc: '',
      args: [],
    );
  }

  /// `Teams`
  String get teams {
    return Intl.message('Teams', name: 'teams', desc: '', args: []);
  }

  /// `Matches played`
  String get matchesPlayed {
    return Intl.message(
      'Matches played',
      name: 'matchesPlayed',
      desc: '',
      args: [],
    );
  }

  /// `Leader`
  String get leader {
    return Intl.message('Leader', name: 'leader', desc: '', args: []);
  }

  /// `P: Played  W: Won  D: Drawn  L: Lost\nGF: Goals For  GA: Goals Against  GD: Goal Difference  PTS: Points`
  String get standingsLegend {
    return Intl.message(
      'P: Played  W: Won  D: Drawn  L: Lost\nGF: Goals For  GA: Goals Against  GD: Goal Difference  PTS: Points',
      name: 'standingsLegend',
      desc: '',
      args: [],
    );
  }

  /// `Played`
  String get played {
    return Intl.message('Played', name: 'played', desc: '', args: []);
  }

  /// `Won`
  String get won {
    return Intl.message('Won', name: 'won', desc: '', args: []);
  }

  /// `Drawn`
  String get drawn {
    return Intl.message('Drawn', name: 'drawn', desc: '', args: []);
  }

  /// `Lost`
  String get lost {
    return Intl.message('Lost', name: 'lost', desc: '', args: []);
  }

  /// `For`
  String get goalsFor {
    return Intl.message('For', name: 'goalsFor', desc: '', args: []);
  }

  /// `Against`
  String get goalsAgainst {
    return Intl.message('Against', name: 'goalsAgainst', desc: '', args: []);
  }

  /// `Difference`
  String get goalDifference {
    return Intl.message(
      'Difference',
      name: 'goalDifference',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message('Points', name: 'points', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
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
