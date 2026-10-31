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

  static String m0(amount) => "إنقاص بمقدار ${amount}";

  static String m1(teamName) => "حذف ${teamName}؟";

  static String m2(name) => "حذف ${name}؟";

  static String m3(count) => "عدد الأهداف: ${count}";

  static String m4(amount) => "زيادة بمقدار ${amount}";

  static String m5(count) => "عدد المباريات: ${count}";

  static String m6(age) => "العمر: ${age}";

  static String m7(count) => "عدد اللاعبين: ${count}";

  static String m8(number) => "الجولة ${number}";

  static String m9(count) => "عدد الفرق: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addChampionship": MessageLookupByLibrary.simpleMessage("إضافة بطولة"),
    "addGoal": MessageLookupByLibrary.simpleMessage("إضافة هدف"),
    "addPlayer": MessageLookupByLibrary.simpleMessage("إضافة لاعب"),
    "addPlayerFailed": MessageLookupByLibrary.simpleMessage(
      "تعذرت إضافة اللاعب. حاول مجددًا.",
    ),
    "addTeam": MessageLookupByLibrary.simpleMessage("إضافة فريق"),
    "addTeamsAndFinishMatches": MessageLookupByLibrary.simpleMessage(
      "أضف الفرق وأنهِ المباريات لعرض الترتيب.",
    ),
    "addTwoTeamsToGenerateSchedule": MessageLookupByLibrary.simpleMessage(
      "أضف فريقين على الأقل لإنشاء جدول المباريات.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cannotModifyTeamsAfterSchedule": MessageLookupByLibrary.simpleMessage(
      "لا يمكنك إضافة الفرق أو تعديلها أو حذفها بعد إنشاء جدول المباريات.",
    ),
    "cannotSaveTournament": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ البطولة",
    ),
    "championshipName": MessageLookupByLibrary.simpleMessage("اسم البطولة"),
    "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "confirmDeleteGoal": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذا الهدف؟",
    ),
    "confirmDeleteMessage": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من أنك تريد الحذف؟",
    ),
    "confirmDeletePlayer": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذا لاعب ؟",
    ),
    "confirmDeleteTeam": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذا الفريق؟",
    ),
    "couldNotFindBothTeams": MessageLookupByLibrary.simpleMessage(
      "تعذر العثور على كلا الفريقين.",
    ),
    "create": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "decreaseBy": m0,
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "deleteChampionship": MessageLookupByLibrary.simpleMessage("حذف البطولة"),
    "deleteGoalFailed": MessageLookupByLibrary.simpleMessage("فشل حذف الهدف."),
    "deleteGoalTitle": MessageLookupByLibrary.simpleMessage("حذف الهدف؟"),
    "deletePlayer": MessageLookupByLibrary.simpleMessage("حذف اللاعب"),
    "deleteTeamTitle": m1,
    "deleteTournamentTitle": m2,
    "drawn": MessageLookupByLibrary.simpleMessage("تعادل"),
    "duplicateTeamName": MessageLookupByLibrary.simpleMessage(
      "يوجد فريق بهذا الاسم في هذه البطولة بالفعل.",
    ),
    "editChampionship": MessageLookupByLibrary.simpleMessage("تعديل البطولة"),
    "editGoal": MessageLookupByLibrary.simpleMessage("تعديل الهدف"),
    "editPlayer": MessageLookupByLibrary.simpleMessage("تعديل لاعب"),
    "editTeam": MessageLookupByLibrary.simpleMessage("تعديل فريق"),
    "enterChampionshipName": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم البطولة.",
    ),
    "failedToLoadPlayers": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل اللاعبين.",
    ),
    "failedToLoadTeams": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل الفرق.",
    ),
    "failedToSaveGoal": MessageLookupByLibrary.simpleMessage("فشل حفظ الهدف."),
    "finish": MessageLookupByLibrary.simpleMessage("إنهاء"),
    "finishMatchMessage": MessageLookupByLibrary.simpleMessage(
      "ستُحتسب النتيجة في الترتيب وقائمة الهدافين.",
    ),
    "finishMatchTitle": MessageLookupByLibrary.simpleMessage("إنهاء المباراة؟"),
    "finished": MessageLookupByLibrary.simpleMessage("انتهت"),
    "generateSchedule": MessageLookupByLibrary.simpleMessage(
      "إنشاء جدول المباريات",
    ),
    "generating": MessageLookupByLibrary.simpleMessage("جارٍ إنشاء الجدول..."),
    "goalDifference": MessageLookupByLibrary.simpleMessage("الفارق"),
    "goals": MessageLookupByLibrary.simpleMessage("الأهداف"),
    "goalsAgainst": MessageLookupByLibrary.simpleMessage("عليه"),
    "goalsCount": m3,
    "goalsFor": MessageLookupByLibrary.simpleMessage("له"),
    "homeAndAway": MessageLookupByLibrary.simpleMessage("ذهاب وإياب"),
    "homeAndAwayEnglish": MessageLookupByLibrary.simpleMessage("ذهاب وإياب"),
    "increaseBy": m4,
    "invalidMatchId": MessageLookupByLibrary.simpleMessage(
      "معرّف المباراة غير صالح.",
    ),
    "invalidPlayerAge": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون العمر بين 1 و99.",
    ),
    "leader": MessageLookupByLibrary.simpleMessage("المتصدر"),
    "loading": MessageLookupByLibrary.simpleMessage("جارٍ التحميل..."),
    "lost": MessageLookupByLibrary.simpleMessage("خسر"),
    "matchDetails": MessageLookupByLibrary.simpleMessage("تفاصيل المباراة"),
    "matchFinished": MessageLookupByLibrary.simpleMessage("تم إنهاء المباراة."),
    "matchFormat": MessageLookupByLibrary.simpleMessage("نظام المباريات"),
    "matchIdMissing": MessageLookupByLibrary.simpleMessage(
      "معرّف المباراة غير موجود.",
    ),
    "matchReopened": MessageLookupByLibrary.simpleMessage(
      "تمت إعادة فتح المباراة.",
    ),
    "matchStatusNotChanged": MessageLookupByLibrary.simpleMessage(
      "لم تتغير حالة المباراة. يرجى التحديث.",
    ),
    "matches": MessageLookupByLibrary.simpleMessage("المباريات"),
    "matchesCount": m5,
    "matchesPlayed": MessageLookupByLibrary.simpleMessage("المباريات الملعوبة"),
    "minute": MessageLookupByLibrary.simpleMessage("الدقيقة"),
    "noGoalsRecordedYet": MessageLookupByLibrary.simpleMessage(
      "لم يتم تسجيل أي أهداف حتى الآن.",
    ),
    "noGoalsScoredYet": MessageLookupByLibrary.simpleMessage(
      "لم يتم تسجيل أي أهداف حتى الآن.",
    ),
    "noMatchesYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد مباريات حتى الآن",
    ),
    "noPlayersYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد لاعبون حتى الآن",
    ),
    "noStandingsYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد ترتيب حتى الآن",
    ),
    "noTeamYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد لاعبون حتى الآن",
    ),
    "noTournamentYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد بطولات حتى الآن!",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("حسنًا"),
    "oneLeg": MessageLookupByLibrary.simpleMessage(
      "مباراة واحدة بين كل فريقين",
    ),
    "pageHomeTitle": MessageLookupByLibrary.simpleMessage("مدير الدوري"),
    "played": MessageLookupByLibrary.simpleMessage("لعب"),
    "player": MessageLookupByLibrary.simpleMessage("اللاعب"),
    "playerAge": m6,
    "playerAgeOptional": MessageLookupByLibrary.simpleMessage(
      "العمر (اختياري)",
    ),
    "playerAgeText": MessageLookupByLibrary.simpleMessage("العمر"),
    "playerName": MessageLookupByLibrary.simpleMessage("اسم اللاعب"),
    "playerNameRequired": MessageLookupByLibrary.simpleMessage(
      "اسم اللاعب مطلوب.",
    ),
    "players": MessageLookupByLibrary.simpleMessage("اللاعبون"),
    "playersCount": m7,
    "pleaseSelectPlayer": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار لاعب.",
    ),
    "pleaseSelectTeam": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار فريق.",
    ),
    "pleaseTryAgain": MessageLookupByLibrary.simpleMessage(
      "يرجى المحاولة مرة أخرى.",
    ),
    "points": MessageLookupByLibrary.simpleMessage("النقاط"),
    "refresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "refreshTournaments": MessageLookupByLibrary.simpleMessage(
      "تحديث البطولات",
    ),
    "reloadTournaments": MessageLookupByLibrary.simpleMessage(
      "إعادة تحميل البطولات",
    ),
    "reopen": MessageLookupByLibrary.simpleMessage("إعادة فتح"),
    "reopenMatchBeforeAddingGoals": MessageLookupByLibrary.simpleMessage(
      "أعد فتح المباراة قبل إضافة الأهداف.",
    ),
    "reopenMatchMessage": MessageLookupByLibrary.simpleMessage(
      "ستصبح هذه المباراة قابلة للتعديل مرة أخرى.",
    ),
    "reopenMatchTitle": MessageLookupByLibrary.simpleMessage(
      "إعادة فتح المباراة؟",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "roundTitle": m8,
    "saveChanges": MessageLookupByLibrary.simpleMessage("حفظ التغييرات"),
    "saveGoal": MessageLookupByLibrary.simpleMessage("حفظ الهدف"),
    "scheduleAlreadyGenerated": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء جدول المباريات بالفعل",
    ),
    "scheduled": MessageLookupByLibrary.simpleMessage("مجدولة"),
    "selectPlayer": MessageLookupByLibrary.simpleMessage("اختر لاعبًا"),
    "selectTeamFirst": MessageLookupByLibrary.simpleMessage(
      "اختر فريقًا أولًا",
    ),
    "singleRound": MessageLookupByLibrary.simpleMessage("ذهاب فقط"),
    "standings": MessageLookupByLibrary.simpleMessage("الترتيب"),
    "standingsLegend": MessageLookupByLibrary.simpleMessage(
      "ل: لعب  ف: فاز  ت: تعادل  خ: خسر\nله: أهداف له  عليه: أهداف عليه  ف.أ: فارق الأهداف  ن: النقاط",
    ),
    "team": MessageLookupByLibrary.simpleMessage("الفريق"),
    "teamName": MessageLookupByLibrary.simpleMessage("اسم الفريق"),
    "teamNameRequired": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال اسم الفريق.",
    ),
    "teams": MessageLookupByLibrary.simpleMessage("الفرق"),
    "teamsCount": m9,
    "topScorers": MessageLookupByLibrary.simpleMessage("الهدافون"),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ غير متوقع.",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
    "unknownPlayer": MessageLookupByLibrary.simpleMessage("لاعب غير معروف"),
    "unknownTeam": MessageLookupByLibrary.simpleMessage("فريق غير معروف"),
    "updateGoal": MessageLookupByLibrary.simpleMessage("تحديث الهدف"),
    "updateMatchStatusFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديث حالة المباراة.",
    ),
    "updatePlayerFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر تحديث اللاعب. حاول مجددًا.",
    ),
    "won": MessageLookupByLibrary.simpleMessage("فاز"),
  };
}
