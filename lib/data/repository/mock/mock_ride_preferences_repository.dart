import '../../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

class MockRidePreferencesRepository extends RidePreferencesRepository {
  @override
  Future<void> addPastPreference(RidePreference preference) {
    // TODO: implement addPastPreference
    throw UnimplementedError();
  }

  @override
  Future<List<RidePreference>> getPastPreferences() {
    // TODO: implement getPastPreferences
    throw UnimplementedError();
  }
  
}
