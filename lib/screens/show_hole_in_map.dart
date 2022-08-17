// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

class HoleInMap extends StatelessWidget {
  final LatLng? center;
  final String? address;
  final bool? isRepair;
  final String? holeUrl;
  final String? sender;
  HoleInMap(
      {Key? key,
      this.center,
      required this.address,
      required this.isRepair,
      required this.sender,
      this.holeUrl})
      : super(key: key);

  final List<Marker> markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(address!)),
      body: FlutterMap(
        options: MapOptions(
          keepAlive: true,
          center: center,
          zoom: 18.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(markers: [
            Marker(
              width: 50,
              height: 50,
              point: center!,
              builder: (ctx) => GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(bottom: 10, top: 20),
                            child: Text("Address : ${address!}")),
                        Container(child: Text("Report by : ${sender!}")),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image(
                            image: NetworkImage(holeUrl!),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 31.0,
                  backgroundColor: isRepair! ? Colors.green : Colors.red,
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(holeUrl!),
                  ),
                ),
              ),
            )
          ])
        ],
      ),
    );
  }
}
