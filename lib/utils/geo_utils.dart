import 'dart:math';
import 'package:final_project/models/destination_model.dart';

// NOTE: distance/time here are straight-line (Haversine) estimates using an
// average road speed — not live driving directions. Real road distance/time
// would require the Google Directions API (extra billing-enabled setup);
// this gives a reasonable estimate without that dependency.
class GeoUtils {
  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  static double _deg2rad(double deg) => deg * (pi / 180);

  static Duration estimateTravelTime(double distanceKm, {double avgSpeedKmh = 40}) {
    final hours = distanceKm / avgSpeedKmh;
    return Duration(minutes: (hours * 60).round());
  }

  static String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return "${h}h ${m}m";
    return "${m}m";
  }

  // CHANGED: Smart Itinerary Optimizer — reorders places using a
  // nearest-neighbor heuristic. Keeps the first place fixed as the
  // starting point (the user's first pick), then repeatedly jumps to
  // whichever remaining place is closest to the current one. This isn't
  // a perfect shortest-route solution (true optimal routing is NP-hard),
  // but it's a solid, fast approximation that noticeably cuts total
  // travel distance for typical trip sizes (a handful of places).
  static List<DestinationModel> optimizeRoute(List<DestinationModel> places) {
    if (places.length <= 2) return List.of(places);

    final remaining = List<DestinationModel>.from(places);
    final route = <DestinationModel>[];

    var current = remaining.removeAt(0);
    route.add(current);

    while (remaining.isNotEmpty) {
      remaining.sort((a, b) {
        final da = distanceKm(current.latitude, current.longitude, a.latitude, a.longitude);
        final db = distanceKm(current.latitude, current.longitude, b.latitude, b.longitude);
        return da.compareTo(db);
      });
      current = remaining.removeAt(0);
      route.add(current);
    }

    return route;
  }

  static double totalRouteDistance(List<DestinationModel> places) {
    double total = 0;
    for (int i = 0; i < places.length - 1; i++) {
      total += distanceKm(places[i].latitude, places[i].longitude, places[i + 1].latitude, places[i + 1].longitude);
    }
    return total;
  }
}
