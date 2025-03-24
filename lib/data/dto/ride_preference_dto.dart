import 'package:week_3_blabla_project/data/dto/location_dto.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class RidePreferenceDto {
  static Map<String, dynamic> toJson(RidePreference model) {
    return {
      'departure': LocationDto.toJson(model.departure),
      'arrival': LocationDto.toJson(model.arrival),
      'departure_date': model.departureDate.toIso8601String(),
      'requested_seats': model.requestedSeats
    };
  }

  static RidePreference fromJson(Map<String, dynamic> json) {
    return RidePreference(
      departure: LocationDto.fromJson(json['departure']), // Deserialize start location
      arrival: LocationDto.fromJson(json['arrival']), // Deserialize end location
      departureDate:DateTime.parse(json['departure_date']), // Deserialize dateTime
      requestedSeats: json['requested_seats'], // Deserialize passenger count
    );
  }
}
