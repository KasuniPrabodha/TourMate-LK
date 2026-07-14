import 'package:final_project/models/destination_model.dart';

class TripModel {
  final String? id;
  final List<DestinationModel> places;
  final DateTime startDate;
  final DateTime endDate;
  final String travellerType;
  final String budget;

  TripModel({
    this.id,
    required this.places,
    required this.startDate,
    required this.endDate,
    required this.travellerType,
    required this.budget,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;

  Map<String, dynamic> toMap() {
    return {
      'places': places.map((p) => p.toMap()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'travellerType': travellerType,
      'budget': budget,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory TripModel.fromMap(String id, Map<String, dynamic> map) {
    return TripModel(
      id: id,
      places: (map['places'] as List<dynamic>? ?? [])
          .map((p) => DestinationModel.fromMap(Map<String, dynamic>.from(p)))
          .toList(),
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(map['endDate'] ?? '') ?? DateTime.now(),
      travellerType: map['travellerType'] ?? 'Solo',
      budget: map['budget'] ?? 'Budget',
    );
  }
}