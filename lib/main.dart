import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_organizer/database/database_helper.dart';
import 'package:tournament_organizer/pages/home_page.dart';
import 'package:tournament_organizer/viewmodels/player_view_model.dart';
import 'package:tournament_organizer/viewmodels/team_view_model.dart';
import 'package:tournament_organizer/viewmodels/tournament_view_model.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dawri Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
