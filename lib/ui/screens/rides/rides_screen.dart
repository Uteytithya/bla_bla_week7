import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/rides_preferences_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    final ridePrefProvider =
        Provider.of<RidesPreferencesProvider>(context, listen: false);

    // 1 - Update the current preference
    ridePrefProvider.setCurrentPreferrence(newPreference);

    // 2 - Navigate to the rides screen (with a bottom-to-top animation)
    Navigator.of(context).pop(
      AnimationUtils.createBottomToTopRoute(const RidesScreen()),
    );

    // 3 - Update the state -- TODO: Implement state management
    ridePrefProvider.setCurrentPreferrence(newPreference);
  }

  void onPreferencePressed(
      BuildContext context, RidePreference currentPreference) async {
    RidePreference? newPreference =
        await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (!context.mounted || newPreference == null) {
      return;
    }

    final ridePrefProvider =
        Provider.of<RidesPreferencesProvider>(context, listen: false);

    // Update preference
    ridePrefProvider.setCurrentPreferrence(newPreference);
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    final ridePrefProvider = Provider.of<RidesPreferencesProvider>(context);
    RidePreference? currentPreference = ridePrefProvider.currentPreference;

    if (currentPreference == null) {
      return const Center(child: CircularProgressIndicator());
    }

    RideFilter currentFilter = RideFilter();
    List<Ride> matchingRides =
        RidesService.instance.getRidesFor(currentPreference, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () =>
                  onPreferencePressed(context, currentPreference),
              onFilterPressed: onFilterPressed,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                  ride: matchingRides[index],
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
