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

  static String m0(teamName) => "Delete ${teamName}?";

  static String m1(age) => "Age: ${age}";

  static String m2(count) => "Players (${count})";

  static String m3(count) => "Teams (${count})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addPlayer": MessageLookupByLibrary.simpleMessage("Add Player"),
    "addPlayerFailed": MessageLookupByLibrary.simpleMessage(
      "Can\'t add player. Please try again.",
    ),
    "addTeam": MessageLookupByLibrary.simpleMessage("Add Team"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotModifyTeamsAfterSchedule": MessageLookupByLibrary.simpleMessage(
      "You cannot add, edit, or delete teams after generating the schedule.",
    ),
    "confirmDeletePlayer": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this player?",
    ),
    "confirmDeleteTeam": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this team?",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "deletePlayer": MessageLookupByLibrary.simpleMessage("Delete player"),
    "deleteTeamTitle": m0,
    "duplicateTeamName": MessageLookupByLibrary.simpleMessage(
      "A team with this name may already exist in this tournament.",
    ),
    "editPlayer": MessageLookupByLibrary.simpleMessage("Edit Player"),
    "editTeam": MessageLookupByLibrary.simpleMessage("Edit Team"),
    "invalidPlayerAge": MessageLookupByLibrary.simpleMessage(
      "Age must be between 1 and 99.",
    ),
    "noPlayersYet": MessageLookupByLibrary.simpleMessage("No players yet"),
    "noTeamYet": MessageLookupByLibrary.simpleMessage("No Teams Yet"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "pageHomeTitle": MessageLookupByLibrary.simpleMessage("Dawri Manager"),
    "playerAge": m1,
    "playerAgeOptional": MessageLookupByLibrary.simpleMessage("Age (optional)"),
    "playerAgeText": MessageLookupByLibrary.simpleMessage("Age"),
    "playerName": MessageLookupByLibrary.simpleMessage("Player name"),
    "playerNameRequired": MessageLookupByLibrary.simpleMessage(
      "Player name is required.",
    ),
    "players": MessageLookupByLibrary.simpleMessage("Players"),
    "playersCount": m2,
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "scheduleAlreadyGenerated": MessageLookupByLibrary.simpleMessage(
      "Schedule already generated",
    ),
    "teamName": MessageLookupByLibrary.simpleMessage("Team name"),
    "teamNameRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a team name.",
    ),
    "teamsCount": m3,
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred.",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "updatePlayerFailed": MessageLookupByLibrary.simpleMessage(
      "Can\'t update player. Please try again.",
    ),
  };
}
