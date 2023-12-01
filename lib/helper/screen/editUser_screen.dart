import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUserProfile extends StatefulWidget {
  final String userId;
  UpdateUserProfile({super.key, required this.userId});

  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userContactController = TextEditingController();

  //String _userId = '';
  late String userId;

  @override
  void initState() {
    super.initState();
    //initialize userId from widget parameter
    userId = widget.userId;
    // Initialize Firebase and retrieve user ID
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    if (userId != null) {
      // Retrieve user information from Firestore using the 'userId'
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        setState(() {
          _userNameController.text = userSnapshot['username'] ?? "N/A";
          _userEmailController.text = userSnapshot['userEmail'] ?? "N/A";
          _userContactController.text = userSnapshot['userContact'] ?? "N/A";
        });
      }
    }
  }

  void _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'username': _userNameController.text,
          'userEmail': _userEmailController.text,
          'userContact': _userContactController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User information updated successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user information')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset("assets/back_icon.png"),
        ),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3),
        ),
      ),
      body: Center(
        child: Container(
          height: 900,
          width: 800,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //edit icon
                          // SizedBox(
                          //   width: 300,
                          //   height: 300,
                          //   child: Image(
                          //     image: AssetImage(
                          //       "assets/edit_user_icon.png",
                          //     ),
                          //   ),
                          // ),
                          Text(
                            "Edit User Info",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controler
                          controller: _userNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: Color(0xFFDA3340),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //email text field
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controller
                          controller: _userEmailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: Color(0xFFDA3340),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //contact textfield
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controller
                          controller: _userContactController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact number';
                            }
                            return null;
                          },

                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.phone,
                              color: Color(0xFFDA3340),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    //update button
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 140,
                          child: MaterialButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              onPressed: () {
                                _updateUserInfo();
                                //Get.to(() => ProfileScreen());
                              },
                              child: const Text(
                                "Update User",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        //cancle button
                        SizedBox(
                          height: 50,
                          width: 120,
                          child: MaterialButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                              onPressed: () {
                                // cancleEditUser();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//   cancleEditUser() {
//     _userNameController.text = "";
//     _userEmailController.text = "";
//     _userContactController.text = "";
//   }
}
