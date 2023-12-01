import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ev_admin/helper/helper.dart';
import 'package:ev_admin/helper/screen/login_screen.dart';
import 'package:ev_admin/helper/screen/setting_page.dart';
import 'package:ev_admin/helper/screen/station_management.dart';
import 'package:ev_admin/helper/screen/user_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    //content for home tab
    Container(
      color: Color.fromARGB(255, 192, 188, 188),
      alignment: Alignment.center,
      child: const Text(
        "Welcom to Admin Panel",
        style: Helper.pageTitle,
      ),
    ),
    //user management
    const StationManangemt(),
    // for station management
    const UserManagement(),
    //for setting page
    const SettingPage(),
  ];
  int _selectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Dashboard ",
          ),
          //logo
          leading: Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Container(
              height: 100,
              child: Lottie.asset(
                "assets/splash.json",
                // height: 100,
                // width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),

          actions: [
            IconButton(
              onPressed: () {
                logoutFunction(context);
                // AwesomeDialog(
                //         context: context,
                //         dialogType: DialogType.warning,
                //         animType: AnimType.topSlide,
                //         desc: "Are your sure want to delete? ",
                //         //actions to perform on cancle and ok buttons
                //         btnCancelOnPress: () {
                //           // Navigator.pop(context);
                //         },
                //         btnOkOnPress: () {
                //           //delete function
                //         })
                //     .show();
              },
              icon: Container(
                padding: const EdgeInsets.only(right: 40),
                child: const Icon(
                  CupertinoIcons.profile_circled,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        //button navigationbar
        bottomNavigationBar: MediaQuery.of(context).size.width < 640
            ? BottomNavigationBar(
                currentIndex: _selectedScreen,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.green,
                //called when one tab is selected
                onTap: (int index) {
                  setState(() {
                    _selectedScreen = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), label: "Manage Station"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Manage User"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                ],
              )
            : null,
        body: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 640)
              NavigationRail(
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedScreen = index;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list),
                      label: Text("Manage Station"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text("Manage User"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text("Profile"),
                    ),
                  ],
                  //decorarion of side bar icons
                  labelType: NavigationRailLabelType.all,
                  selectedLabelTextStyle: const TextStyle(color: Colors.green),
                  unselectedLabelTextStyle: const TextStyle(color: Colors.red),
                  //

                  selectedIndex: _selectedScreen),
            Expanded(child: _screens[_selectedScreen]),
          ],
        ));
  }
}

//logout function
AwesomeDialog logoutFunction(BuildContext context) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      desc: "Are your sure want to logout? ",
      //actions to perform on cancle and ok buttons
      btnCancelOnPress: () {
        Get.to(() => const HomeScreen());
      },
      btnOkOnPress: () {
        //logout function
        FirebaseAuth.instance.signOut();
        Get.off(() => const LoginScreen());
        signOut();
      });
}

// Function to log the user out
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    Get.off(() => const LoginScreen());
  } catch (e) {
    print("Error signing out: $e");
    // Handle errors if sign-out fails.
  }
}
