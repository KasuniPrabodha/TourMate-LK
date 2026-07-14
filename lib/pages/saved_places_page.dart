import 'package:final_project/reuse/network_place_images.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/destination_model.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';
import 'package:final_project/services/saved_places_service.dart';
import 'package:final_project/pages/trip_planner_page.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  final SavedPlacesService _service = SavedPlacesService();
  final Set<String> _selectedPlaces = {};

  // CHANGED: confirmation dialog before deleting, and removes the place
  // from selection too if it was checked.
  Future<bool> _confirmDelete(String placeName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove place?"),
        content: Text("Remove \"$placeName\" from your saved places?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomTabBar(currentIndex: 2),
      body: SafeArea(
        child: StreamBuilder<List<DestinationModel>>(
          stream: _service.savedPlacesStream,
          builder: (context, snapshot) {
            final places = snapshot.data ?? [];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        "TourMate LK",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF134a26)),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Saved Places",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Container(width: 100, height: 2, decoration: const BoxDecoration(color: Color.fromARGB(255, 107, 202, 228))),
                      const SizedBox(height: 8),
                      if (places.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text("Swipe left on a place to remove it", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ),
                      const SizedBox(height: 12),

                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator())
                      else if (places.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text("No saved places yet. Add places from category pages.", style: TextStyle(color: Colors.grey.shade600)),
                        )
                      else
                        Column(
                          children: places.map((place) {
                            final isChecked = _selectedPlaces.contains(place.place);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              // CHANGED: wrapped in Dismissible for swipe-to-delete
                              child: Dismissible(
                                key: ValueKey(place.place),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (_) => _confirmDelete(place.place),
                                onDismissed: (_) {
                                  _service.removePlace(place.place);
                                  setState(() => _selectedPlaces.remove(place.place));
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                child: _SavedCard(
                                  coverImage: place.coverImage,
                                  place: place.place,
                                  description: place.description,
                                  isChecked: isChecked,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedPlaces.add(place.place);
                                      } else {
                                        _selectedPlaces.remove(place.place);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _selectedPlaces.isEmpty
                            ? null
                            : () {
                                final selected = places.where((p) => _selectedPlaces.contains(p.place)).toList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => TripPlannerPage(selectedPlaces: selected)),
                                );
                              },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedPlaces.isEmpty ? Colors.grey.shade400 : const Color(0xFF134a26),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              "Plan Trip With Selected Places",
                              style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  final String coverImage;
  final String place;
  final String description;
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;
  const _SavedCard({
    required this.coverImage,
    required this.place,
    required this.description,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              NetworkPlaceImage(fileName: coverImage, width: 50, height: 50, fit: BoxFit.cover),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(place, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      const SizedBox(height: 5),
                      Text(description, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              Checkbox(value: isChecked, activeColor: Colors.blue, onChanged: onChanged),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
