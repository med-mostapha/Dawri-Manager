import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/pages/home_page.dart';
import 'package:tournament_organizer/viewmodels/goal_view_model.dart';
import 'package:tournament_organizer/viewmodels/player_view_model.dart';
import 'package:tournament_organizer/viewmodels/standings_view_model.dart';
import 'package:tournament_organizer/viewmodels/team_view_model.dart';
import 'package:tournament_organizer/viewmodels/top_scorers_view_model.dart';
import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper databaseServices = DatabaseHelper.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TournamentViewModel(databaseServices),
        ),
        ChangeNotifierProvider(create: (_) => TeamViewModel(databaseServices)),
        ChangeNotifierProvider(
          create: (_) => PlayerViewModel(databaseServices),
        ),
        ChangeNotifierProvider(create: (_) => GoalViewModel(databaseServices)),
        ChangeNotifierProvider(
          create: (_) => StandingsViewModel(databaseServices),
        ),
        ChangeNotifierProvider(
          create: (_) => TopScorersViewModel(databaseServices),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: Locale('en'),
        debugShowCheckedModeBanner: false,
        title: 'Dawri Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) {
            return HomePage(title: S.of(context).pageHomeTitle);
          },
        ),
      ),
    );
  }
}
