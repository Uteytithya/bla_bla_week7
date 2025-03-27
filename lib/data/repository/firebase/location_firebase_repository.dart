import 'package:firebase_database/firebase_database.dart';
import 'package:week_3_blabla_project/data/dto/location_dto.dart';
import 'package:week_3_blabla_project/data/repository/locations_repository.dart';
import 'package:week_3_blabla_project/model/location/locations.dart';

class LocationFirebaseRepository extends LocationsRepository {
  @override
  Future<List<Location>> getLocations() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("locations");

    DatabaseEvent event = await ref.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> locations =
          event.snapshot.value as Map<dynamic, dynamic>;

      List<Location> locationList = locations.entries.map((entry) {
        return LocationDto.fromJson({
          'name': entry.value['name'],
          'country': entry.value['country'],
        });
      }).toList();

      return locationList;
    } else {
      print("No data found");
      return [];
    }
  }
}
