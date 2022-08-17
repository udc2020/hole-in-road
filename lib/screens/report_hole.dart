import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hole_in_road/screens/send_hole.dart';
import 'package:hole_in_road/shared/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  File? cameraImage;
  String? imgUrl;
  String? pathImage;
  File? tmp;

  Future pickImage(ImageSource source) async {
    try {
      final camera = await ImagePicker().pickImage(source: source);
      if (camera == null) return;
      final temp = File(camera.path);
      tmp = temp;

      final pathImages = 'img/${camera.name}';
      pathImage = pathImages;

      debugPrint(pathImages);
      // uploadImage(pathImages, temp);
      setState(() => cameraImage = temp);
    } on PlatformException catch (e) {
      debugPrint('Fiald to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          user,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () => pickImage(ImageSource.camera),
          ),
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 9,
              child: cameraImage != null
                  ? SizedBox(
                      width: double.infinity, child: Image.file(cameraImage!))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Capture New ',
                          style: TextStyle(fontSize: 27, color: Colors.black38),
                        ),
                        Icon(
                          Icons.camera_alt,
                          size: 35,
                          color: Colors.black38,
                        )
                      ],
                    ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: cameraImage == null
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SandHole(
                                    imgCamera: Image.file(cameraImage!),
                                    pathImage: pathImage,
                                    fileImage: tmp),
                              ));
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Capture Hole',
                        style: TextStyle(fontSize: 20.00),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.camera,
                        size: 20,
                      ),
                    ],
                  )),
            ),
          ],
        )),
      ),
    );
  }
}
