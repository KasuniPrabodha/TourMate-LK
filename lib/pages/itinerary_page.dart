import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:final_project/models/destination_model.dart';
import 'package:final_project/models/trip_model.dart';
import 'package:final_project/services/trip_service.dart';
import 'package:final_project/utils/geo_utils.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';

class ItineraryPage extends StatefulWidget {
  final List<DestinationModel> places;
  final DateTime startDate;
  final DateTime endDate;
  final String travellerType;
  final String budget;
  final bool isSavedView;

  const ItineraryPage({
    super.key,
    required this.places,
    required this.startDate,
    required this.endDate,
    required this.travellerType,
    required this.budget,
    this.isSavedView = false,
  });

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  final TripService _tripService = TripService();
  GoogleMapController? _mapController;
  bool _isSaving = false;
  bool _saved = false;

  // CHANGED: Smart Itinerary Optimizer state. _orderedPlaces holds whichever
  // order is currently shown (original selection order, or the optimized
  // order) — everything below (map, segments, save) reads from this instead
  // of widget.places directly, so the whole page updates when toggled.
  late List<DestinationModel> _orderedPlaces;
  bool _isOptimized = false;

  @override
  void initState() {
    super.initState();
    _orderedPlaces = List.from(widget.places);
  }

  int get _durationDays => widget.endDate.difference(widget.startDate).inDays + 1;

  void _toggleOptimize() {
    setState(() {
      if (_isOptimized) {
        _orderedPlaces = List.from(widget.places);
        _isOptimized = false;
      } else {
        _orderedPlaces = GeoUtils.optimizeRoute(widget.places);
        _isOptimized = true;
      }
    });
    // Re-fit the map to the (possibly reordered) route.
    if (_orderedPlaces.length > 1) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(_boundsFromPlaces(), 50));
      });
    }
  }

  Set<Marker> get _markers {
    return List.generate(_orderedPlaces.length, (i) {
      final p = _orderedPlaces[i];
      return Marker(
        markerId: MarkerId(p.place),
        position: LatLng(p.latitude, p.longitude),
        infoWindow: InfoWindow(title: "${i + 1}. ${p.place}"),
      );
    }).toSet();
  }

  Set<Polyline> get _polylines {
    if (_orderedPlaces.length < 2) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _orderedPlaces.map((p) => LatLng(p.latitude, p.longitude)).toList(),
        color: const Color(0xFF134a26),
        width: 4,
      ),
    };
  }

  LatLngBounds _boundsFromPlaces() {
    final lats = _orderedPlaces.map((p) => p.latitude);
    final lngs = _orderedPlaces.map((p) => p.longitude);
    return LatLngBounds(
      southwest: LatLng(lats.reduce(min), lngs.reduce(min)),
      northeast: LatLng(lats.reduce(max), lngs.reduce(max)),
    );
  }

  List<Map<String, dynamic>> get _segments {
    final segs = <Map<String, dynamic>>[];
    for (int i = 0; i < _orderedPlaces.length - 1; i++) {
      final from = _orderedPlaces[i];
      final to = _orderedPlaces[i + 1];
      final distance = GeoUtils.distanceKm(from.latitude, from.longitude, to.latitude, to.longitude);
      final time = GeoUtils.estimateTravelTime(distance);
      segs.add({'from': from.place, 'to': to.place, 'distance': distance, 'time': time});
    }
    return segs;
  }

  Future<void> _handleSaveTrip() async {
    setState(() => _isSaving = true);
    await _tripService.saveTrip(
      TripModel(
        places: _orderedPlaces, // CHANGED: saves whichever order is currently shown
        startDate: widget.startDate,
        endDate: widget.endDate,
        travellerType: widget.travellerType,
        budget: widget.budget,
      ),
    );
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _saved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trip saved! Find it in the Trips tab.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final segments = _segments;
    final totalDistance = GeoUtils.totalRouteDistance(_orderedPlaces);
    final unoptimizedDistance = GeoUtils.totalRouteDistance(widget.places);

    return Scaffold(
      bottomNavigationBar: const CustomTabBar(currentIndex: -1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text(
          "Recommended Itinerary",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Sharing coming soon")),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top info card: dates + duration count
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text("$_durationDays Days - ${_orderedPlaces.length} Places", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 20, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text(
                          "${dateFormat.format(widget.startDate)} - ${dateFormat.format(widget.endDate)}",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (_orderedPlaces.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.flag, size: 20, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "From: ${_orderedPlaces.first.place}   →   To: ${_orderedPlaces.last.place}",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Smart Itinerary Optimizer card — only shown for a new
              // (not-yet-saved) trip with enough places to reorder.
              if (!widget.isSavedView && widget.places.length > 2)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(20, 19, 74, 38),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color.fromARGB(60, 19, 74, 38)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.route, color: Color(0xFF134a26)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOptimized ? "Optimized route" : "Total distance: ${unoptimizedDistance.toStringAsFixed(1)} km",
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF134a26)),
                            ),
                            if (_isOptimized)
                              Text(
                                "${totalDistance.toStringAsFixed(1)} km (saved ${(unoptimizedDistance - totalDistance).clamp(0, double.infinity).toStringAsFixed(1)} km)",
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleOptimize,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isOptimized ? Colors.grey.shade400 : const Color(0xFF134a26),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isOptimized ? "Reset Order" : "Optimize Route",
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Map with route
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 220,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_orderedPlaces.first.latitude, _orderedPlaces.first.longitude),
                      zoom: 8,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (_orderedPlaces.length > 1) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          _mapController?.animateCamera(CameraUpdate.newLatLngBounds(_boundsFromPlaces(), 50));
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Trip Flow", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
              const SizedBox(height: 12),

              if (segments.isEmpty)
                Text("Add at least 2 places to see distances between them.", style: TextStyle(color: Colors.grey.shade600))
              else
                ...segments.map((seg) {
                  final distance = seg['distance'] as double;
                  final time = seg['time'] as Duration;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.trip_origin, size: 14, color: Color(0xFF134a26)),
                            const SizedBox(width: 8),
                            Text("From: ${seg['from']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: SizedBox(height: 18, child: VerticalDivider(color: Colors.grey, thickness: 1)),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Text("To: ${seg['to']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.social_distance, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            Text("${distance.toStringAsFixed(1)} km", style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                            const SizedBox(width: 20),
                            Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            Text("Time: ${GeoUtils.formatDuration(time)}", style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 20),

              if (!widget.isSavedView)
                GestureDetector(
                  onTap: (_isSaving || _saved) ? null : _handleSaveTrip,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _saved ? Colors.grey.shade400 : const Color(0xFF134a26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _saved ? "Trip Saved ✓" : "Save Trip",
                              style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w800),
                            ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
