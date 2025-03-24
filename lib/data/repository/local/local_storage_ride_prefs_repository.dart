import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/dto/ride_preference_dto.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class LocalStorageRidePrefsRepository extends RidePreferencesRepository {
  static const String _preferenceKey = 'ride_preferences';

  Future<void> addPastPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    final List<RidePreference> pastPreferences = await getPastPreferences();

    print("🟢 Before adding: $pastPreferences");

    pastPreferences.add(preference);

    final encodedPrefs = pastPreferences.map((pref) {
      final jsonString = jsonEncode(RidePreferenceDto.toJson(pref));
      print("💾 Saving preference: $jsonString");
      return jsonString;
    }).toList();

    await prefs.setStringList(_preferenceKey, encodedPrefs);
    print("✅ Preferences saved successfully!");
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final prefsList = prefs.getStringList(_preferenceKey) ?? [];

    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }
}
