import 'package:flutter/material.dart';
import 'package:tournament_organizer/models/tournament.dart';
import 'package:tournament_organizer/pages/tabs/team_page.dart';
import 'package:tournament_organizer/widgets/build_placeholder.dart';

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
          bottom: const TabBar(
            isScrollable: true, // is change this for test

            tabs: [
              Tab(icon: Icon(Icons.groups_outlined), text: 'Teams'),
              Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Matches'),
              Tab(icon: Icon(Icons.emoji_events_outlined), text: 'Standings'),
              Tab(
                icon: Icon(Icons.sports_soccer_outlined),
                text: 'Top Scorers',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TeamPage(tournament: tournament),
            const BuildPlaceholder(
              icon: Icons.calendar_month_outlined,
              message: 'No matches yet',
            ),
            const BuildPlaceholder(
              icon: Icons.emoji_events_outlined,
              message: 'Standings will appear here',
            ),
            const BuildPlaceholder(
              icon: Icons.sports_soccer_outlined,
              message: 'Top scorers will appear here',
            ),
          ],
        ),
      ),
    );
  }
}
