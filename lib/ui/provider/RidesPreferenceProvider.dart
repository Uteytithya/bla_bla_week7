import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>> pastPreferences = AsyncValue.loading();

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    _fetchPastPreferences();
  }

  void _fetchPastPreferences() async {
    try {
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      print("Fetched preferences: $pastPrefs");
      pastPreferences = AsyncValue.success(pastPrefs);
    } catch (e, stacktrace) {
      print("Error fetching preferences: $e\nStackTrace: $stacktrace"); // Debug
      pastPreferences = AsyncValue.error(e);
    }
    notifyListeners();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreferrence(RidePreference pref) async {
    if (_currentPreference != pref) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  void _addPreference(RidePreference preference) async {
    if (pastPreferences.data != null &&
        !pastPreferences.data!.contains(preference)) {
      await repository.addPastPreference(preference);
      _fetchPastPreferences();
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory {
    return pastPreferences.data?.reversed.toList() ?? [];
  }
}
