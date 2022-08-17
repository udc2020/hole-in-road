// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hole_in_road/models/location_model.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class AllMapHole extends StatefulWidget {
  const AllMapHole({Key? key}) : super(key: key);
  @override
  State<AllMapHole> createState() => _AllMapHoleState();
}

class _AllMapHoleState extends State<AllMapHole> {
  final List<Marker> markers = <Marker>[];

  loc.LocationData? cPosition;
  final loc.Location location = loc.Location();

  StreamSubscription<loc.LocationData>? _locationSub;

  Stream<List<LocationItems>>? getAllHolse() => FirebaseFirestore.instance
      .collection("hole")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => LocationItems.fromJson(doc.data()))
          .toList());

  @override
  void initState() {
    _locationSub = location.onLocationChanged
        .listen((loc.LocationData? loctionInRealTime) {
      cPosition = loctionInRealTime!;

      setState(() {});
    });
    super.initState();
  }

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
        child: StreamBuilder<List<LocationItems>>(
            stream: getAllHolse(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text("We Have Some Problems "),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                final hole = snapshot.data!;
                return FlutterMap(
                  options: MapOptions(
                    keepAlive: true,
                    center: LatLng(cPosition!.latitude!, cPosition!.longitude!),
                    zoom: 13,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(markers: hole.map(markersAll).toList())
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Marker markersAll(LocationItems hole) {
    return Marker(
      width: 50,
      height: 50,
      point: LatLng(hole.latitud, hole.longitud),
      builder: (ctx) => GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Text("Address : ${hole.address}")),
                Container(child: Text("Report by : ${hole.userName}")),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(hole.urlImg!),
                  ),
                ),
              ],
            ),
          );
        },
        child: CircleAvatar(
          radius: 31.0,
          backgroundColor: hole.isRepair ? Colors.green : Colors.red,
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(hole.urlImg!),
          ),
        ),
      ),
    );
  }
}
