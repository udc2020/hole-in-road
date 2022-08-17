import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hole_in_road/screens/all_holes.dart';
import 'package:hole_in_road/screens/auth/google_sign_in.dart';
import 'package:hole_in_road/screens/report_hole.dart';
import 'package:hole_in_road/screens/map_shower.dart';
import 'package:hole_in_road/widgets/button.dart';

class MenuSelections extends StatefulWidget {
  const MenuSelections({Key? key}) : super(key: key);

  @override
  State<MenuSelections> createState() => _MenuSelectionsState();
}

class _MenuSelectionsState extends State<MenuSelections> {
  GoogleSignInAccount? user;

  @override
  void initState() {
    super.initState();
    user?.photoUrl != null;
    _loginSave();
  }

  Future _loginSave() async {
    user = await GoogleInApi.login();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // SizedBox(height: 40,),
          CircleAvatar(
            radius: 62,
            backgroundColor: Colors.pink,
            child: CircleAvatar(
                radius: 57,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('${user?.photoUrl}')
                // foregroundImage: AssetImage('assets/img/holeinroad.png'),
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Welcome ${user?.displayName}',
            style: const TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 20,
          ),
          Button(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Report()));
            },
            children: const [
              Text(
                'Report Hole !',
                style: TextStyle(fontSize: 21),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Button(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MapShower()));
            },
            children: const [
              Text(
                'Hole Near you ',
                style: TextStyle(fontSize: 21),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Button(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllMapHole()));
              },
              children: const [
                Text(
                  'All Holes ',
                  style: TextStyle(fontSize: 21),
                ),
              ]),
        ]),
      )),
    );
  }
}
