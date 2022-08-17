import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hole_in_road/screens/menu_screen.dart';
import 'package:hole_in_road/shared/user_provider.dart';
import 'package:provider/provider.dart';

import 'google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future _signIn() async {
    try {
      //* Here We Using Google Cloud Signin Auth
      final user = await GoogleInApi.login();
      if (user == null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sign in Failed")));
        await Geolocator.requestPermission();
      } else {
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false)
            .changeUserInformation(user.displayName!);

        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MenuSelections()));
      }
    } catch (e) {
      debugPrint("We Have Some Errors in Login Form $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Image(image: AssetImage('assets/img/holeinroad.png')),
              const SizedBox(
                height: 10,
              ),
              const Text.rich(
                TextSpan(
                    text: "Welcome To Hole in Road ",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                  ),
                  onPressed: _signIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.g_mobiledata_outlined,
                        size: 30,
                      ),
                      Text('Login With Google'),
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
