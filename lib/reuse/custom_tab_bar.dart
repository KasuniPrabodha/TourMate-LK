import 'package:flutter/material.dart';
import 'package:final_project/pages/home_page.dart';
import 'package:final_project/pages/explore.dart';
import 'package:final_project/pages/saved_places_page.dart';
import 'package:final_project/pages/my_trips_page.dart';

// Used as a Scaffold's bottomNavigationBar, which Flutter keeps fixed at
// the bottom of the screen regardless of scrolling in the body above it —
// this is what makes it "sticky/persistent" per your requirement.
class CustomTabBar extends StatelessWidget {
  // CHANGED: -1 means "no tab is the current page" — used by pages like
  // itinerary_page that are reached via push but aren't themselves one of
  // the 4 main tab destinations. In that case every tab tap navigates,
  // instead of the old behavior of silently ignoring a tap on "Trips".
  final int currentIndex; // 0=Home, 1=Explore, 2=Saved, 3=Trips, -1=none
  const CustomTabBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (currentIndex != -1 && index == currentIndex) return;
    Widget page;
    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const MapSearchPage();
        break;
      case 2:
        page = const SavedPlacesPage();
        break;
      case 3:
        page = const MyTripsPage();
        break;
      default:
        page = const HomePage();
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": Icons.home, "label": "Home"},
      {"icon": Icons.explore, "label": "Explore"},
      {"icon": Icons.bookmark, "label": "Saved"},
      {"icon": Icons.card_travel, "label": "Trips"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = index == currentIndex;
              final color = isActive ? const Color(0xFF134a26) : Colors.grey;
              return GestureDetector(
                onTap: () => _onTap(context, index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[index]["icon"] as IconData, color: color),
                    const SizedBox(height: 2),
                    Text(
                      items[index]["label"] as String,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
