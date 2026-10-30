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

  static String m0(teamName) => "حذف ${teamName}؟";

  static String m1(count) => "عدد المباريات: ${count}";

  static String m2(age) => "العمر: ${age}";

  static String m3(count) => "عدد اللاعبين: ${count}";

  static String m4(number) => "الجولة ${number}";

  static String m5(count) => "عدد الفرق: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addPlayer": MessageLookupByLibrary.simpleMessage("إضافة لاعب"),
    "addPlayerFailed": MessageLookupByLibrary.simpleMessage(
      "تعذرت إضافة اللاعب. حاول مجددًا.",
    ),
    "addTeam": MessageLookupByLibrary.simpleMessage("إضافة فريق"),
    "addTwoTeamsToGenerateSchedule": MessageLookupByLibrary.simpleMessage(
      "أضف فريقين على الأقل لإنشاء جدول المباريات.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cannotModifyTeamsAfterSchedule": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك إضافة الفرق أو تعديلها أو حذفها بعد إنشاء جدول المباريات.",
    ),
    "confirmDeletePlayer": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذا لاعب ؟",
    ),
    "confirmDeleteTeam": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذا الفريق؟",
    ),
    "create": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "deletePlayer": MessageLookupByLibrary.simpleMessage("حذف اللاعب"),
    "deleteTeamTitle": m0,
    "duplicateTeamName": MessageLookupByLibrary.simpleMessage(
      "يوجد فريق بهذا الاسم في هذه البطولة بالفعل.",
    ),
    "editPlayer": MessageLookupByLibrary.simpleMessage("تعديل لاعب"),
    "editTeam": MessageLookupByLibrary.simpleMessage("تعديل فريق"),
    "finished": MessageLookupByLibrary.simpleMessage("انتهت"),
    "generateSchedule": MessageLookupByLibrary.simpleMessage(
      "إنشاء جدول المباريات",
    ),
    "generating": MessageLookupByLibrary.simpleMessage("جارٍ إنشاء الجدول..."),
    "invalidPlayerAge": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون العمر بين 1 و99.",
    ),
    "matchesCount": m1,
    "noMatchesYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد مباريات حتى الآن",
    ),
    "noPlayersYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد لاعبون حتى الآن",
    ),
    "noTeamYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد لاعبون حتى الآن",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("حسنًا"),
    "pageHomeTitle": MessageLookupByLibrary.simpleMessage("مدير الدوري"),
    "playerAge": m2,
    "playerAgeOptional": MessageLookupByLibrary.simpleMessage(
      "العمر (اختياري)",
    ),
    "playerAgeText": MessageLookupByLibrary.simpleMessage("العمر"),
    "playerName": MessageLookupByLibrary.simpleMessage("اسم اللاعب"),
    "playerNameRequired": MessageLookupByLibrary.simpleMessage(
      "اسم اللاعب مطلوب.",
    ),
    "players": MessageLookupByLibrary.simpleMessage("اللاعبون"),
    "playersCount": m3,
    "refresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "roundTitle": m4,
    "saveChanges": MessageLookupByLibrary.simpleMessage("حفظ التغييرات"),
    "scheduleAlreadyGenerated": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء جدول المباريات بالفعل",
    ),
    "scheduled": MessageLookupByLibrary.simpleMessage("مجدولة"),
    "teamName": MessageLookupByLibrary.simpleMessage("اسم الفريق"),
    "teamNameRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم الفريق.",
    ),
    "teamsCount": m5,
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ غير متوقع.",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
    "unknownTeam": MessageLookupByLibrary.simpleMessage("فريق غير معروف"),
    "updatePlayerFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديث اللاعب. حاول مجددًا.",
    ),
  };
}
