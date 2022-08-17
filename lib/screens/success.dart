import 'package:flutter/material.dart';
import 'package:hole_in_road/screens/menu_screen.dart';

class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Successs!',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Container(
                  width: 300,
                  height: 100,
                  padding: const EdgeInsets.all(15.0),
                  child: const Opacity(
                    opacity: .9,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                            'Operation Complated Successfully , thank you for reporting this hole'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue,
                      elevation: 1,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MenuSelections()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.keyboard_return,
                          size: 20,
                        ),
                        Text('Return'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
