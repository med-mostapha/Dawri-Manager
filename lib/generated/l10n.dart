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
