class LocationItems {
  String id;
  String address;
  double latitud;
  double longitud;
  bool isRepair;
  double? distence = 0.0;
  String? userName;
  String? urlImg;

  LocationItems(
      {required this.id,
      this.address = '',
      required this.latitud,
      required this.longitud,
      this.isRepair = false,
      this.distence = 0.0,
      this.userName,
      this.urlImg});

  Map<String, dynamic> toJson() => {
        'address': address,
        'distance': distence,
        'isRepair': isRepair,
        'latitude': latitud,
        'longitude': longitud,
        'userName': userName,
        'url': urlImg,
        'id': id
      };

  static LocationItems fromJson(Map<String, dynamic> json) => LocationItems(
        id: json['id'],
        address: json['address'],
        longitud: json['longitude'],
        userName: json['userName'],
        urlImg: json['url'],
        latitud: json['latitude'],
        isRepair: json['isRepair'],
        distence: json['distance'],
      );
}
