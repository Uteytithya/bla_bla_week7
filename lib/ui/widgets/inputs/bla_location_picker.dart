import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/model/location/locations.dart';
import 'package:week_3_blabla_project/ui/provider/location_provider.dart';
import '../../theme/theme.dart';

class BlaLocationPicker extends StatelessWidget {
  const BlaLocationPicker({super.key});

  void onBackSelected(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onLocationSelected(BuildContext context, Location location) {
    Navigator.of(context).pop(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.value(
            Provider.of<LocationProvider>(context, listen: false).locations),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loader
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: \${snapshot.error}"));
          }
          return _buildLocationPicker(context);
        },
      ),
    );
  }

  Widget _buildLocationPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Consumer<LocationProvider>(
            builder: (context, provider, _) => BlaSearchBar(
              onBackPressed: () => Navigator.of(context).pop(),
              onSearchChanged: provider.filterLocations,
            ),
          ),
          Expanded(
            child: Consumer<LocationProvider>(
              builder: (context, provider, _) {
                if (provider.searchQuery.length < 2) {
                  return const SizedBox.shrink(); // Hide locations initially
                }
                if (provider.filteredLocations.isEmpty) {
                  return const Center(child: Text("No locations found."));
                }
                return ListView.builder(
                  itemCount: provider.filteredLocations.length,
                  itemBuilder: (ctx, index) => LocationTile(
                    location: provider.filteredLocations[index],
                    onSelected: (location) =>
                        Navigator.of(context).pop(location),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  final Location location;
  final Function(Location location) onSelected;

  const LocationTile(
      {super.key, required this.location, required this.onSelected});

  String get title => location.name;
  String get subTitle => location.country.name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onSelected(location),
      title: Text(title,
          style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal)),
      subtitle: Text(subTitle,
          style: BlaTextStyles.label.copyWith(color: BlaColors.textLight)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: BlaColors.iconLight,
        size: 16,
      ),
    );
  }
}

class BlaSearchBar extends StatefulWidget {
  const BlaSearchBar(
      {super.key, required this.onSearchChanged, required this.onBackPressed});

  final Function(String text) onSearchChanged;
  final VoidCallback onBackPressed;

  @override
  State<BlaSearchBar> createState() => _BlaSearchBarState();
}

class _BlaSearchBarState extends State<BlaSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool get searchIsNotEmpty => _controller.text.isNotEmpty;

  void onChanged(String newText) {
    if (newText.length >= 2) {
      widget.onSearchChanged(newText);
    } else {
      widget.onSearchChanged(""); // Clear filter if less than 2 characters
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BlaColors.backgroundAccent,
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              onPressed: widget.onBackPressed,
              icon: Icon(
                Icons.arrow_back_ios,
                color: BlaColors.iconLight,
                size: 16,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onChanged: onChanged,
              controller: _controller,
              style: TextStyle(color: BlaColors.textLight),
              decoration: InputDecoration(
                hintText: "Any city, street...",
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          searchIsNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: BlaColors.iconLight),
                  onPressed: () {
                    _controller.clear();
                    _focusNode.requestFocus();
                    onChanged("");
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
