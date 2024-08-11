class UserData {
  final double originLatitude;
  final double originLongitude;
  final double destLatitude;
  final double destLongitude;
  final String? polylineName;
  final double? distance;

  UserData({
    required this.originLatitude,
    required this.originLongitude,
    required this.destLatitude,
    required this.destLongitude,
    this.polylineName,
    this.distance,
  });

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      originLatitude: data['originLatitude'],
      originLongitude: data['originLongitude'],
      destLatitude: data['destLatitude'],
      destLongitude: data['destLongitude'],
      polylineName: data['polylineName'],
      distance: data['distance'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originLatitude': originLatitude,
      'originLongitude': originLongitude,
      'destLatitude': destLatitude,
      'destLongitude': destLongitude,
      'polylineName': polylineName,
      'distance': distance,
    };
  }
}
