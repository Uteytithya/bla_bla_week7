import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/data/repository/locations_repository.dart';
import 'package:week_3_blabla_project/model/location/locations.dart';

class LocationProvider extends ChangeNotifier {
  List<Location> _locations = [];
  String searchQuery= '';

  final LocationsRepository repository;

  LocationProvider(this.repository) {
    _fetchLocations();
  }

  List<Location> get locations => _locations;

  List<Location> get filteredLocations => searchQuery.isEmpty
      ? _locations
      : _locations
          .where((location) =>
              location.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

  Future<void> _fetchLocations() async {
    try {
      _locations = await repository.getLocations();
      print("Fetched locations: $_locations");
      notifyListeners();
    } catch (e, stacktrace) {
      print("Error fetching locations: $e\nStackTrace: $stacktrace");
    }
  }

  Future<List<Location>> getLocationsFor(String text) async {
    return _locations
        .where((location) =>
            location.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void filterLocations(String query) {
    searchQuery= query;
    notifyListeners();
  }
}
