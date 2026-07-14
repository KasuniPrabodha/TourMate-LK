import 'dart:math';

// NOTE: distance/time here are straight-line (Haversine) estimates using an
// average road speed — not live driving directions. Real road distance/time
// would require the Google Directions API (extra billing-enabled setup);
// this gives a reasonable estimate without that dependency.
class DistanceUtills {
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
}