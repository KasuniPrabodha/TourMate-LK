class DestinationModel {
  final String coverImage;
  final String place;
  final double rate;
  final String description;
  final String category;
  final String openingHours;
  final String ticketPrice;
  final String fullDescription;
  final double latitude;
  final double longitude;

  DestinationModel({
    required this.coverImage,
    required this.place,
    required this.rate,
    required this.description,
    this.category = '',
    this.openingHours = '8:00 AM - 5:00 PM',
    this.ticketPrice = 'LKR 500 (Locals) / USD 15 (Foreigners)',
    this.fullDescription = '',
    this.latitude = 7.8731,
    this.longitude = 80.7718,
  });

  factory DestinationModel.fromMap(Map<String, dynamic> map) {
    return DestinationModel(
      coverImage: map['coverImage'] ?? '',
      place: map['place'] ?? '',
      rate: (map['rate'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      openingHours: map['openingHours'] ?? '8:00 AM - 5:00 PM',
      ticketPrice: map['ticketPrice'] ?? 'LKR 500',
      fullDescription: map['fullDescription'] ?? '',
      latitude: (map['latitude']?? 7.8731).toDouble(),
      longitude: (map['longitude']?? 80.7718).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coverImage': coverImage,
      'place': place,
      'rate': rate,
      'description': description,
      'category': category,
      'openingHours': openingHours,
      'ticketPrice': ticketPrice,
      'fullDescription': fullDescription,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
