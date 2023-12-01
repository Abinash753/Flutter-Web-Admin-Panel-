import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateStationScreen extends StatefulWidget {
  final String stationId;
  UpdateStationScreen({super.key, required this.stationId});

  @override
  _UpdateStationScreenState createState() => _UpdateStationScreenState();
}

class _UpdateStationScreenState extends State<UpdateStationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stationNameController = TextEditingController();
  final _stationAddressController = TextEditingController();
  final _stationContactController = TextEditingController();
  final _stationLatitudeController = TextEditingController();
  final _stationLongitudeController = TextEditingController();

  //String _userId = '';
  late String stationId;

  @override
  void initState() {
    super.initState();
    //initialize userId from widget parameter
    stationId = widget.stationId;

    // Initialize Firebase and retrieve user ID
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    // Retrieve user information from Firestore using the 'userId'
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('stations')
        .doc(stationId)
        .get();
    if (userSnapshot.exists) {
      setState(() {
        _stationNameController.text = userSnapshot['station_name'] ?? "N/A";
        _stationAddressController.text = userSnapshot['address'] ?? "N/A";
        _stationContactController.text = userSnapshot['contact'] ?? "N/A";
        _stationLatitudeController.text = userSnapshot['latitude'] ?? "N/A";
        _stationLongitudeController.text = userSnapshot['longitude'] ?? "N/A";
      });
    }
  }

  void _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('stations')
            .doc(stationId)
            .update({
          'station_name': _stationNameController.text,
          'address': _stationAddressController.text,
          'contact': _stationContactController.text,
          'latitude': _stationLatitudeController.text,
          'longitude': _stationLongitudeController.text
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Station information updated successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating user information')),
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
          "Edit Station ",
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
                            "Edit Station Info",
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
                    //station name textform field
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controler
                          controller: _stationNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Station Name Required';
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
                    //station Address field
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controller
                          controller: _stationAddressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Station address required';
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
                    //station contact field
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controller
                          controller: _stationContactController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter station contact number';
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
                      height: 20,
                    ),
                    //station latitude textfiled
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controller
                          controller: _stationLatitudeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter station latitude';
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
                      height: 10,
                    ),
                    //station longitude textfiled
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 13),
                        child: TextFormField(
                          //controller
                          controller: _stationLongitudeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter station longitude';
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
                      height: 40,
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
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Update Station ",
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
}
