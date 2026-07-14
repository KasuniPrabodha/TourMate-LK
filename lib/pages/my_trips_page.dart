import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';
import 'package:final_project/models/trip_model.dart';
import 'package:final_project/services/trip_service.dart';
import 'package:final_project/pages/itinerary_page.dart';

class MyTripsPage extends StatelessWidget {
  const MyTripsPage({super.key});

  // CHANGED: confirmation dialog before deleting a trip
  Future<bool> _confirmDelete(BuildContext context, TripModel trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete trip?"),
        content: Text("Delete this ${trip.durationDays}-day trip? This can't be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final tripService = TripService();
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      bottomNavigationBar: const CustomTabBar(currentIndex: 3),
      body: SafeArea(
        child: StreamBuilder<List<TripModel>>(
          stream: tripService.tripsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final trips = snapshot.data ?? [];
            if (trips.isEmpty) {
              return Center(
                child: Text("No trips saved yet", style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final placeNames = trip.places.map((p) => p.place).join(", ");
                // CHANGED: wrapped in Dismissible for swipe-to-delete
                return Dismissible(
                  key: ValueKey(trip.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(context, trip),
                  onDismissed: (_) => tripService.deleteTrip(trip.id!),
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItineraryPage(
                            places: trip.places,
                            startDate: trip.startDate,
                            endDate: trip.endDate,
                            travellerType: trip.travellerType,
                            budget: trip.budget,
                            isSavedView: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.card_travel, color: Color(0xFF134a26)),
                              const SizedBox(width: 10),
                              Text(
                                "${trip.durationDays} Days Trip",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            placeNames,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _Tag(text: trip.travellerType),
                              const SizedBox(width: 8),
                              _Tag(text: trip.budget),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color.fromARGB(30, 19, 74, 38), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF134a26))),
    );
  }
}
