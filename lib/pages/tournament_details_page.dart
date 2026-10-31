import 'package:flutter/material.dart';

import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/pages/tabs/matches_page.dart';
import 'package:tournament_organizer/pages/tabs/team_page.dart';
import 'package:tournament_organizer/pages/tabs/top_scorers_page.dart';
import 'package:tournament_organizer/pages/tabs/standings_page.dart';
import 'package:tournament_organizer/generated/l10n.dart';

class TournamentDetailsPage extends StatelessWidget {
  final Tournament tournament;

  const TournamentDetailsPage({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(tournament.name),
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              Tab(icon: Icon(Icons.groups_outlined), text: S.of(context).teams),
              Tab(
                icon: Icon(Icons.calendar_month_outlined),
                text: S.of(context).matches,
              ),
              Tab(
                icon: Icon(Icons.emoji_events_outlined),
                text: S.of(context).standings,
              ),
              Tab(
                icon: Icon(Icons.sports_soccer_outlined),
                text: S.of(context).topScorers,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TeamPage(tournament: tournament),
            MatchesPage(tournament: tournament),
            StandingsPage(tournament: tournament),
            TopScorersPage(tournament: tournament),
          ],
        ),
      ),
    );
  }
}
