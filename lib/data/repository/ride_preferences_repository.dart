import '../../model/ride/ride_pref.dart';

abstract class RidePreferencesRepository {
  Future<List<RidePreference>> getPastPreferences();

  Future<void> addPastPreference(RidePreference preference);
}
