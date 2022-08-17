import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hole_in_road/models/location_model.dart';
import 'package:hole_in_road/models/notification.dart';
import 'package:hole_in_road/screens/show_hole_in_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class MapShower extends StatefulWidget {
  const MapShower({Key? key}) : super(key: key);

  @override
  State<MapShower> createState() => _MapShowerState();
}

class _MapShowerState extends State<MapShower> {
  double? lat, long;
  List<double>? distenceBetween;
  String? position = '';
  Position? currentPosition;

  loc.LocationData? cPosition;

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSub;

  String? address;
  double? dist;
  bool isRuning = true;

  @override
  void initState() {
    _locationSub = location.onLocationChanged
        .listen((loc.LocationData? newlocation) async {
      cPosition = newlocation;
      setState(() {});
    });

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notification'),
            content: const Text('This App Recomanded notification'),
            actions: [
              TextButton(
                  onPressed: () {
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then((_) => Navigator.pop(context));
                  },
                  child: const Text('Allow'))
            ],
          ),
        );
      }
    });

    super.initState();
  }

  double calculateDistence(lat1, long1, lat2, long2) {
    var p = 0.017453292519943295;
    var c = cos;

    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((long2 - long1) * p)) / 2;

    return 12742 * asin(sqrt(a));
  }

  Stream<List<LocationItems>> getAllHolse() => FirebaseFirestore.instance
      .collection("hole")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => LocationItems.fromJson(doc.data()))
          .toList());

  @override
  void dispose() {
    _locationSub?.cancel();
    _locationSub = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Holes Near You',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<List<LocationItems>>(
              stream: getAllHolse(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return const Center(child: Text("No Data"));
                  } else {
                    if (snapshot.data!.isEmpty) {
                      const Center(child: CircularProgressIndicator());
                    }
                    final List<LocationItems> holes = snapshot.data!;

                    // geoCurrentPositionLive();

                    for (var hole in holes) {
                      if (cPosition != null) {
                        double? distenceDouble = calculateDistence(
                            cPosition?.latitude,
                            cPosition?.longitude,
                            hole.latitud,
                            hole.longitud);
                        var distence =
                            double.parse((distenceDouble).toStringAsFixed(3));
                        hole.distence = distence;
                      }
                    }

                    holes.sort(((a, b) => a.distence!.compareTo(b.distence!)));

                    if (holes.first.distence! < 1) {
                      notifications(holes);
                    } else {
                      NotifocationApi.stop();
                    }

                    // else
                    //   NotifocationApi.stop();

                    return ListView(
                      padding: const EdgeInsets.all(10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: holes.map(listTailHole).toList(),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  notifications(List<LocationItems> hole) {
    final address = hole.first.address;
    final distence = hole.first.distence;
    NotifocationApi.detecteHole(address, distence);
  }

  Widget listTailHole(LocationItems hole) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HoleInMap(
                    center: LatLng(hole.latitud, hole.longitud),
                    address: hole.address,
                    isRepair: hole.isRepair,
                    holeUrl: hole.urlImg,
                    sender: hole.userName,
                  ),
                ));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          tileColor: hole.isRepair ? Colors.green : Colors.pink,
          title: Text(
            hole.address,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Icon(
            hole.isRepair ? Icons.check_box : Icons.dangerous_rounded,
            color: Colors.white,
          ),
          subtitle: Text(
            '${hole.distence} KM',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}
