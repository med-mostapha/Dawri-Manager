// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(age) => "العمر: ${age}";

  static String m1(count) => "عدد اللاعبين: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addPlayer": MessageLookupByLibrary.simpleMessage("إضافة لاعب"),
    "addPlayerFailed": MessageLookupByLibrary.simpleMessage(
      "تعذرت إضافة اللاعب. حاول مجددًا.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "create": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "deletePlayer": MessageLookupByLibrary.simpleMessage("حذف اللاعب"),
    "editPlayer": MessageLookupByLibrary.simpleMessage("تعديل لاعب"),
    "invalidPlayerAge": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون العمر بين 1 و99.",
    ),
    "noPlayersYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد لاعبون حتى الآن",
    ),
    "pageHomeTitle": MessageLookupByLibrary.simpleMessage("مدير الدوري"),
    "playerAge": m0,
    "playerAgeOptional": MessageLookupByLibrary.simpleMessage(
      "العمر (اختياري)",
    ),
    "playerName": MessageLookupByLibrary.simpleMessage("اسم اللاعب"),
    "playerNameRequired": MessageLookupByLibrary.simpleMessage(
      "اسم اللاعب مطلوب.",
    ),
    "players": MessageLookupByLibrary.simpleMessage("اللاعبون"),
    "playersCount": m1,
    "saveChanges": MessageLookupByLibrary.simpleMessage("حفظ التغييرات"),
    "unknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
    "updatePlayerFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديث اللاعب. حاول مجددًا.",
    ),
  };
}
