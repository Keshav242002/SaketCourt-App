import 'package:flutter/material.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import 'package:saketcourt/screens/circulars.dart';
import 'package:saketcourt/screens/event.dart';
import 'package:saketcourt/screens/impLinks.dart';
import 'package:saketcourt/screens/searchMember.dart';
import 'package:saketcourt/screens/subscriptions.dart';
import 'package:saketcourt/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';
import '../screens/profile.dart';





class NewDrawer extends StatelessWidget {
  const NewDrawer({super.key});



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[

          Center(

            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: kColorMidNightBlue,
              ),

              accountName: Text(
                glbMemName,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                glbMobNo,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('images/playstore.png'),
              ),
            ),
          ),
          DrawerTile(
            title: 'Home',
            leading: const Icon(
              Icons.home,
              color: Colors.black87,
            ),
            onPressed: () {

              Navigator.of(context).pop();
              Navigator.pushNamed(context, Dashboard.id);
            },
          ),
          DrawerTile(
            title: 'My Profile',
            leading: const Icon(
              Icons.account_circle,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, MyProfile.id);
            },
          ),
          DrawerTile(
            title: 'Search Members',
            leading: const Icon(
              Icons.search,
              color: Colors.orange,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, SearchMembers.id);

            },
          ),
          DrawerTile(
            title: 'Events',
            leading: const Icon(
              Icons.event,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, Events.id);

            },
          ),
          DrawerTile(
            title: 'My Subscriptions',
            leading: const Icon(
              Icons.subscriptions,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, Subscriptions.id);

            },
          ),
          DrawerTile(
            title: 'Circulars',
            leading: const Icon(
              Icons.book,
              color: Colors.teal,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, Circulars.id);

            },
          ),
          DrawerTile(
            title: 'Important Links',
            leading: const Icon(
              Icons.link,
              color: Colors.indigo,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, Links.id);

            },
          ),

          DrawerTile(
            title: 'Log Out',
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            onPressed: () async {

              

              // Navigate to login screen
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  DrawerTile({
    required this.title,
    required this.leading,
    required this.onPressed
  });

  final String title;
  final Icon leading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      leading: leading,
      // trailing: Icon(
      //   Icons.arrow_right,
      //   size: 24.0,
      //   color: Colors.black87,
      // ),
      onTap: onPressed,
    );
  }
}
