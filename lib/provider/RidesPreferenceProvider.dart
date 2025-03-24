import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier { 
 
  RidePreference? _currentPreference; 
  List<RidePreference> _pastPreferences = []; 
 
  final RidePreferencesRepository repository; 
 
  RidesPreferencesProvider({required this.repository}) { 
    // For now past preferences are fetched only 1 time 
    _pastPreferences = repository.getPastPreferences();
  } 
    
  RidePreference? get currentPreference => _currentPreference; 
 
  void setCurrentPreferrence(RidePreference pref) { 
     if (_currentPreference != pref) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
     }
  } 
 
  void _addPreference(RidePreference preference) {
    if (!_pastPreferences.contains(preference)) {
      _pastPreferences.add(preference);
    }
  } 
   
  // History is returned from newest to oldest preference 
  List<RidePreference> get preferencesHistory => 
_pastPreferences.reversed.toList(); 
}