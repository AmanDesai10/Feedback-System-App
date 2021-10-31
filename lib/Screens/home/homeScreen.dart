import 'package:feedsys/Screens/welcome.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: kPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logged in as ${widget.role}',
              style: theme.textTheme.headline6,
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove("_id");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (route) => false);
              },
              child: Container(
                color: kPrimary,
                child: Text(
                  'Logout',
                  style: theme.textTheme.headline6!.copyWith(color: kWhite),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            )
          ],
        ),
      ),
      // color: Colors.amber,
    );
  }
}
