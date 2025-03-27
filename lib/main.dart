import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/data/repository/firebase/location_firebase_repository.dart';
import 'package:week_3_blabla_project/data/repository/local/local_storage_ride_prefs_repository.dart';
import 'package:week_3_blabla_project/firebase_options.dart';
import 'package:week_3_blabla_project/ui/provider/location_provider.dart';
import 'package:week_3_blabla_project/ui/provider/rides_preferences_provider.dart';
import 'data/repository/mock/mock_rides_repository.dart';
import 'service/rides_service.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';

void main() async {
  // 1 - Initialize the services
  RidesService.initialize(MockRidesRepository());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

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
                repository: LocalStorageRidePrefsRepository())),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(LocationFirebaseRepository()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Scaffold(body: RidePrefScreen()),
      ),
    );
  }
}
