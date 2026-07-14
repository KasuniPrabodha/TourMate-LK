import 'package:final_project/reuse/network_place_images.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/destination_model.dart';
import 'package:final_project/services/saved_places_service.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';

class PlaceDetailPage extends StatefulWidget {
  final DestinationModel place;
  const PlaceDetailPage({super.key, required this.place});

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  final SavedPlacesService _savedPlacesService = SavedPlacesService();
  bool _isAdding = false;

  Future<void> _handleAddToTrip() async {
    setState(() => _isAdding = true);
    await _savedPlacesService.addPlace(widget.place);
    if (!mounted) return;
    setState(() => _isAdding = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.place.place} added to your saved places")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    return Scaffold(
      // CHANGED: added persistent tab bar (Home tab)
      bottomNavigationBar: const CustomTabBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              // NOTE: only one cover image is available per place right now.
              // If you add 2-3 more photos per place to assets/, this can
              // become a PageView carousel instead of a single Image.
              background: NetworkPlaceImage(fileName: place.coverImage, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.place, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 18),
                      const SizedBox(width: 6),
                      Text(place.rate.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 10),
                      Text(place.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Opening times + ticket price cards
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.access_time,
                          label: "Opening Hours",
                          value: place.openingHours,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.confirmation_number,
                          label: "Ticket Price",
                          value: place.ticketPrice,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("About", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text(
                    place.fullDescription.isNotEmpty ? place.fullDescription : place.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                  ),
                  const SizedBox(height: 30),

                  // Add to Trip button
                  GestureDetector(
                    onTap: _isAdding ? null : _handleAddToTrip,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(color: const Color(0xFF134a26), borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: _isAdding
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Add to Trip",
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Icon(icon, color: const Color(0xFF134a26), size: 22),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black)),
        ],
      ),
    );
  }
}
