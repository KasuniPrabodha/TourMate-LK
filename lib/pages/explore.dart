import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';
import 'package:final_project/data/home_data.dart';
import 'package:final_project/models/destination_model.dart';
import 'package:final_project/pages/place_detail_page.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  DestinationModel? _selectedPlace;

  // Sri Lanka center, roughly.
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(7.8731, 80.7718),
    zoom: 7.2,
  );

  // CHANGED: no markers by default — only the searched place gets a pin,
  // and only if it matches a place already saved in the database.
  Set<Marker> get _markers {
    if (_selectedPlace == null) return {};
    final place = _selectedPlace!;
    return {
      Marker(
        markerId: MarkerId(place.place),
        position: LatLng(place.latitude, place.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: place.place, snippet: place.description),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailPage(place: place)));
        },
      ),
    };
  }

  void _handleSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    // Only searches places already in the database, matching by name,
    // as required — no free-form geocoding.
    final match = destinations.where((d) => d.place.toLowerCase().contains(query)).toList();

    if (match.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Place not found. Try a name already in the app (e.g. Sigiriya, Yala).")),
      );
      return;
    }

    final place = match.first;
    setState(() => _selectedPlace = place);
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(place.latitude, place.longitude), zoom: 13)),
    );
  }

  void _resetToOverview() {
    setState(() => _selectedPlace = null);
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomTabBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 12),
              child: Text(
                "Dashboard & Map Search",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.grey),
                      onPressed: _handleSearch,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (_) => _handleSearch(),
                        decoration: const InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location, color: Color(0xFF134a26)),
                      onPressed: _resetToOverview,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
