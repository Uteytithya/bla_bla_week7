import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/data/repository/local/local_storage_ride_prefs_repository.dart';
import 'package:week_3_blabla_project/ui/provider/RidesPreferenceProvider.dart';
import 'data/repository/mock/mock_locations_repository.dart';
import 'data/repository/mock/mock_rides_repository.dart';
import 'service/locations_service.dart';
import 'service/rides_service.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';

void main() async {
  // 1 - Initialize the services
  LocationsService.initialize(MockLocationsRepository());
  RidesService.initialize(MockRidesRepository());

  // 2- Run the UI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => RidesPreferencesProvider(
                repository: LocalStorageRidePrefsRepository()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Scaffold(body: RidePrefScreen()),
      ),
    );
  }
}
