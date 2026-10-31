// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(amount) => "Decrease by ${amount}";

  static String m1(teamName) => "Delete ${teamName}?";

  static String m2(count) => "${count} goals";

  static String m3(amount) => "Increase by ${amount}";

  static String m4(count) => "${count} matches";

  static String m5(age) => "Age: ${age}";

  static String m6(count) => "Players (${count})";

  static String m7(number) => "Round ${number}";

  static String m8(count) => "Teams (${count})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addGoal": MessageLookupByLibrary.simpleMessage("Add Goal"),
    "addPlayer": MessageLookupByLibrary.simpleMessage("Add Player"),
    "addPlayerFailed": MessageLookupByLibrary.simpleMessage(
      "Can\'t add player. Please try again.",
    ),
    "addTeam": MessageLookupByLibrary.simpleMessage("Add Team"),
    "addTeamsAndFinishMatches": MessageLookupByLibrary.simpleMessage(
      "Add teams and finish matches to see the standings.",
    ),
    "addTwoTeamsToGenerateSchedule": MessageLookupByLibrary.simpleMessage(
      "Add at least two teams to generate the schedule.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotModifyTeamsAfterSchedule": MessageLookupByLibrary.simpleMessage(
      "You cannot add, edit, or delete teams after generating the schedule.",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "confirmDeleteGoal": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this goal?",
    ),
    "confirmDeletePlayer": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this player?",
    ),
    "confirmDeleteTeam": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this team?",
    ),
    "couldNotFindBothTeams": MessageLookupByLibrary.simpleMessage(
      "Could not find both teams.",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "decreaseBy": m0,
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteGoalFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to delete goal.",
    ),
    "deleteGoalTitle": MessageLookupByLibrary.simpleMessage("Delete Goal?"),
    "deletePlayer": MessageLookupByLibrary.simpleMessage("Delete player"),
    "deleteTeamTitle": m1,
    "drawn": MessageLookupByLibrary.simpleMessage("Drawn"),
    "duplicateTeamName": MessageLookupByLibrary.simpleMessage(
      "A team with this name may already exist in this tournament.",
    ),
    "editGoal": MessageLookupByLibrary.simpleMessage("Edit Goal"),
    "editPlayer": MessageLookupByLibrary.simpleMessage("Edit Player"),
    "editTeam": MessageLookupByLibrary.simpleMessage("Edit Team"),
    "failedToLoadPlayers": MessageLookupByLibrary.simpleMessage(
      "Failed to load players.",
    ),
    "failedToLoadTeams": MessageLookupByLibrary.simpleMessage(
      "Failed to load teams.",
    ),
    "failedToSaveGoal": MessageLookupByLibrary.simpleMessage(
      "Failed to save the goal.",
    ),
    "finish": MessageLookupByLibrary.simpleMessage("Finish"),
    "finishMatchMessage": MessageLookupByLibrary.simpleMessage(
      "The result will count in the standings and top scorers.",
    ),
    "finishMatchTitle": MessageLookupByLibrary.simpleMessage("Finish Match?"),
    "finished": MessageLookupByLibrary.simpleMessage("Finished"),
    "generateSchedule": MessageLookupByLibrary.simpleMessage(
      "Generate Schedule",
    ),
    "generating": MessageLookupByLibrary.simpleMessage("Generating..."),
    "goalDifference": MessageLookupByLibrary.simpleMessage("Difference"),
    "goals": MessageLookupByLibrary.simpleMessage("Goals"),
    "goalsAgainst": MessageLookupByLibrary.simpleMessage("Against"),
    "goalsCount": m2,
    "goalsFor": MessageLookupByLibrary.simpleMessage("For"),
    "increaseBy": m3,
    "invalidMatchId": MessageLookupByLibrary.simpleMessage("Invalid match ID."),
    "invalidPlayerAge": MessageLookupByLibrary.simpleMessage(
      "Age must be between 1 and 99.",
    ),
    "leader": MessageLookupByLibrary.simpleMessage("Leader"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "lost": MessageLookupByLibrary.simpleMessage("Lost"),
    "matchDetails": MessageLookupByLibrary.simpleMessage("Match Details"),
    "matchFinished": MessageLookupByLibrary.simpleMessage("Match finished."),
    "matchIdMissing": MessageLookupByLibrary.simpleMessage(
      "The match ID is missing.",
    ),
    "matchReopened": MessageLookupByLibrary.simpleMessage("Match reopened."),
    "matchStatusNotChanged": MessageLookupByLibrary.simpleMessage(
      "Match status was not changed. Please refresh.",
    ),
    "matchesCount": m4,
    "matchesPlayed": MessageLookupByLibrary.simpleMessage("Matches played"),
    "minute": MessageLookupByLibrary.simpleMessage("Minute"),
    "noGoalsRecordedYet": MessageLookupByLibrary.simpleMessage(
      "No goals recorded yet.",
    ),
    "noGoalsScoredYet": MessageLookupByLibrary.simpleMessage(
      "No goals scored yet.",
    ),
    "noMatchesYet": MessageLookupByLibrary.simpleMessage("No matches yet"),
    "noPlayersYet": MessageLookupByLibrary.simpleMessage("No players yet"),
    "noStandingsYet": MessageLookupByLibrary.simpleMessage("No standings yet"),
    "noTeamYet": MessageLookupByLibrary.simpleMessage("No Teams Yet"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "pageHomeTitle": MessageLookupByLibrary.simpleMessage("Dawri Manager"),
    "played": MessageLookupByLibrary.simpleMessage("Played"),
    "player": MessageLookupByLibrary.simpleMessage("Player"),
    "playerAge": m5,
    "playerAgeOptional": MessageLookupByLibrary.simpleMessage("Age (optional)"),
    "playerAgeText": MessageLookupByLibrary.simpleMessage("Age"),
    "playerName": MessageLookupByLibrary.simpleMessage("Player name"),
    "playerNameRequired": MessageLookupByLibrary.simpleMessage(
      "Player name is required.",
    ),
    "players": MessageLookupByLibrary.simpleMessage("Players"),
    "playersCount": m6,
    "pleaseSelectPlayer": MessageLookupByLibrary.simpleMessage(
      "Please select a player.",
    ),
    "pleaseSelectTeam": MessageLookupByLibrary.simpleMessage(
      "Please select a team.",
    ),
    "points": MessageLookupByLibrary.simpleMessage("Points"),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "reopen": MessageLookupByLibrary.simpleMessage("Reopen"),
    "reopenMatchBeforeAddingGoals": MessageLookupByLibrary.simpleMessage(
      "Reopen the match before adding goals.",
    ),
    "reopenMatchMessage": MessageLookupByLibrary.simpleMessage(
      "This match will become editable again.",
    ),
    "reopenMatchTitle": MessageLookupByLibrary.simpleMessage("Reopen Match?"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "roundTitle": m7,
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "saveGoal": MessageLookupByLibrary.simpleMessage("Save Goal"),
    "scheduleAlreadyGenerated": MessageLookupByLibrary.simpleMessage(
      "Schedule already generated",
    ),
    "scheduled": MessageLookupByLibrary.simpleMessage("Scheduled"),
    "selectPlayer": MessageLookupByLibrary.simpleMessage("Select a player"),
    "selectTeamFirst": MessageLookupByLibrary.simpleMessage(
      "Select a team first",
    ),
    "standingsLegend": MessageLookupByLibrary.simpleMessage(
      "P: Played  W: Won  D: Drawn  L: Lost\nGF: Goals For  GA: Goals Against  GD: Goal Difference  PTS: Points",
    ),
    "team": MessageLookupByLibrary.simpleMessage("Team"),
    "teamName": MessageLookupByLibrary.simpleMessage("Team name"),
    "teamNameRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a team name.",
    ),
    "teams": MessageLookupByLibrary.simpleMessage("Teams"),
    "teamsCount": m8,
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred.",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownPlayer": MessageLookupByLibrary.simpleMessage("Unknown player"),
    "unknownTeam": MessageLookupByLibrary.simpleMessage("Unknown team"),
    "updateGoal": MessageLookupByLibrary.simpleMessage("Update Goal"),
    "updateMatchStatusFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to update match status.",
    ),
    "updatePlayerFailed": MessageLookupByLibrary.simpleMessage(
      "Can\'t update player. Please try again.",
    ),
    "won": MessageLookupByLibrary.simpleMessage("Won"),
  };
}
