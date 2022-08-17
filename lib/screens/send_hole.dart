import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hole_in_road/models/firebase_controller.dart';
import 'package:hole_in_road/models/location_model.dart';
import 'package:hole_in_road/screens/success.dart';
import 'package:hole_in_road/shared/img_provider.dart';
import 'package:hole_in_road/shared/user_provider.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

class SandHole extends StatefulWidget {
  const SandHole(
      {Key? key,
      required this.imgCamera,
      required this.fileImage,
      required this.pathImage})
      : super(key: key);
  final Image? imgCamera;
  final String? pathImage;
  final File? fileImage;

  @override
  State<SandHole> createState() => _SandHoleState();
}

class _SandHoleState extends State<SandHole> {

  
  Position? currentPosition;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSub;
  LocationPermission? permission;
  late String user;
  late String urlImg;
  late loc.LocationData locationSend;

  String? place = '';

  @override
  void initState() {
    getLocation();
    uploadImage(widget.pathImage, widget.fileImage);
    super.initState();
  }

  Future uploadImage(path, img) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final storageUpload = ref.putFile(img);
    final snapshotImg = await storageUpload.whenComplete(() => null);

    final String url = await snapshotImg.ref.getDownloadURL();
    // ignore: use_build_context_synchronously
    Provider.of<ImagProvider>(context, listen: false).addImag(url);
    debugPrint(url);
    setState(() {});
  }

  Future getLocation() async {
    await Geolocator.requestPermission();
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _locationSub = location.onLocationChanged.handleError((onError) {
      debugPrint(onError);
      _locationSub?.cancel();
      setState(() {
        _locationSub = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      final List<Placemark> positnonMarkers = await placemarkFromCoordinates(
          currentLocation.latitude!, currentLocation.longitude!);

      place =
          '${positnonMarkers[0].street} ${positnonMarkers[1].street} ${positnonMarkers[3].street}';

      debugPrint(place);

      setState(() {
        locationSend = currentLocation;
      });
    });
  }

  Future newHole({double? lat, double? long, String? address}) async {
    final docUser = FireBaseApi.docUser('hole');

    final locationItems = LocationItems(
        id: docUser.id,
        latitud: lat!,
        longitud: long!,
        userName: user,
        address: address!,
        isRepair: false,
        distence: 0.0,
        urlImg: urlImg);

    final json = locationItems.toJson();

    await docUser.set(json);
  }

  @override
  void dispose() {
    super.dispose();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    urlImg = Provider.of<ImagProvider>(context).img;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: widget.imgCamera != null
                    ? widget.imgCamera!
                    : const FlutterLogo(),
              ),
              Expanded(
                flex: 1,
                child: Form(
                  child: Column(
                    children: [
                      const Divider(
                        height: 10,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 350,
                              child: Text(
                                'Location : $place',
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(
                              Icons.location_history,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              user,
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: place != null
                                ? () {
                                    newHole(
                                      lat: locationSend.latitude,
                                      long: locationSend.longitude,
                                      address: place,
                                    );
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Success(),
                                        ));
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Send Now',
                                  style: TextStyle(fontSize: 20.00),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.send,
                                  size: 20,
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
