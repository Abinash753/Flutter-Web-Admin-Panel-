import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_admin/helper/screen/editStation_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class StationManangemt extends StatefulWidget {
  const StationManangemt({super.key});

  @override
  State<StationManangemt> createState() => _StationManangemtState();
}

class _StationManangemtState extends State<StationManangemt> {
//key for form validation
  final _formKey = GlobalKey<FormState>();
  //

  final CollectionReference imagesCollection =
      FirebaseFirestore.instance.collection('stations');

  //store the document Id
  String getStationId = "";
  //TextEditingController for user input
  TextEditingController stationNameController = TextEditingController();
  TextEditingController stationAddressController = TextEditingController();
  TextEditingController stationContactController = TextEditingController();
  TextEditingController stationLatitudeController = TextEditingController();
  TextEditingController stationLongitudeController = TextEditingController();

  //delete user function
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('stations');
  Future<void> deleteStationData(String stationId) async {
    try {
      await _usersCollection.doc(stationId).delete();
    } catch (e) {
      print("Error deleting user data: $e");
    }
  }

//
  final FirebaseStorage _storage = FirebaseStorage.instance;
  dynamic _stationImage;
  String? fileName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //function to pick image from user input
  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _stationImage = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  //function to upload image in firebase
  _uploadStationImageToStorage(dynamic image) async {
    Reference ref = _storage.ref().child("stationImage").child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //upload to firestore function
  // uploadStationImageOnFireStorage() async {
  //   if (_stationImage != null) {
  //     String imageUrl = await _uploadStationImageToStorage(_stationImage);
  //     await _firestore.collection("stations").doc().set({
  //       "stationImage": imageUrl,
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Station"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final stations = snapshot.data?.docs;
          if (stations != null) {
            return ListView.builder(
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index].data() as Map<String, dynamic>;

                final stationName =
                    station['station_name'] ?? "Station Name not available";
                final stationAddress =
                    station['address'] ?? "Address not available";
                final stationContact =
                    station['contact'] ?? "Contact is not available";
                final stationLatitude =
                    station["latitude"] ?? "Latitude is not available";
                final stationLongitude =
                    station["longitude"] ?? "Longitude is not available";
                final stationImage =
                    station["image"] ?? "Image is not available";

                return Card(
                  elevation: 4, // Adjust the elevation as needed
                  margin:
                      const EdgeInsets.all(8), // Adjust the margin as needed
                  child: ListTile(
                    leading:
                        //serial number of the station
                        // Text(
                        //   '${index + 1}',
                        //   style: const TextStyle(
                        //       color: Colors.black, fontSize: 15),
                        // ),
                        //station image
                        // const SizedBox(
                        //   width: 0,
                        // ),
                        Container(
                      height: 120,
                      width: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          stationImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text("Image Not Available"),
                            );
                          },
                        ),
                      ),
                    ),

                    title: Center(
                      child: Text(
                        "Station Name: $stationName",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text(
                          "Address : $stationAddress",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //

                        const Divider(),
                        Text(
                          "Contact : $stationContact",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        //latitude
                        Text(
                          "Station Latitude : $stationLatitude",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //longitude
                        const Divider(),
                        //latitude
                        Text(
                          "Station Longitude : $stationLongitude",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // subtitle: Text(
                    //   userEmail,
                    //   style: const TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 15,
                    //   ),
                    // ),
                    // icons
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit icon
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: const Color.fromARGB(255, 3, 35, 243),
                          iconSize: 30,
                          padding: const EdgeInsets.all(1),
                          onPressed: () async {
                            Get.to(
                              () => UpdateStationScreen(
                                stationId: stations[index].id,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        // Delete icon
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          iconSize: 30,
                          padding: const EdgeInsets.all(1),
                          onPressed: () async {
                            //alert dialog  screen

                            QuickAlert.show(
                              showCancelBtn: true,
                              context: context,
                              type: QuickAlertType.warning,
                              text: 'Are You Sure Want To Delete ?',
                              cancelBtnText: "Cancle",
                              onCancelBtnTap: () {
                                Navigator.pop(context);
                              },
                              confirmBtnText: "Delete",
                              onConfirmBtnTap: () {
                                deleteStationData(stations[index].id);
                                // pupup message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Station Deleted !"),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          // Add a default return statement here
          return const Center(
            child: Text("No users available"),
          );
        },
      ),
      floatingActionButton: addNewStation(context),
    );
  }

  //add new station here

  FloatingActionButton addNewStation(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Center(
              child: Text(
                "Add New Station",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            //content: const Text("You have raised a Alert Dialog Box"),
            actions: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //text field for username
                    Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 215, 72),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 13),
                        child: TextFormField(
                          autofocus: true,
                          //controller
                          controller: stationNameController,
                          validator: (station_name) {
                            if (station_name == null || station_name.isEmpty) {
                              return "Station Name is Empty";
                            } else if (station_name.length <= 5) {
                              return "Station Name should be greater than 5 character";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.ev_station_outlined,
                                color: Color.fromARGB(255, 232, 19, 4),
                              ),
                              border: InputBorder.none,
                              hintText: "Station Name"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Address text field
                    Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 215, 72),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 13),
                        child: TextFormField(
                          //controller
                          controller: stationAddressController,
                          //validation
                          validator: (station_address) {
                            if (station_address == null ||
                                station_address.isEmpty) {
                              return "Station address is Empty";
                            } else if (station_address.length <= 5) {
                              return "should be greater then 5 character long";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.home,
                                color: Color.fromARGB(255, 232, 19, 4),
                              ),
                              border: InputBorder.none,
                              hintText: "Address"),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //email text contact
                    Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 215, 72),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 13),
                        child: TextFormField(
                          //controller
                          controller: stationContactController,
                          //validation
                          validator: (stationContact) {
                            if (stationContact == null ||
                                stationContact.isEmpty) {
                              return "Contact Field  Is Empty";
                            } else if (stationContact.length != 10) {
                              return "Length Should Be Standard";
                            } else {
                              return null;
                            }
                          },

                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Color.fromARGB(255, 232, 19, 4),
                              ),
                              border: InputBorder.none,
                              hintText: "Contact"),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Latitude for username
                    Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 215, 72),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 13),
                        child: TextFormField(
                          autofocus: true,
                          //controller
                          controller: stationLatitudeController,
                          //validation
                          validator: (latitude) {
                            if (latitude == null || latitude.isEmpty) {
                              return "Latitude Field  Is Empty";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.map,
                                color: Color.fromARGB(255, 232, 19, 4),
                              ),
                              border: InputBorder.none,
                              hintText: "Latitude"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Longitude textfield
                    Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 215, 72),
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 13),
                        child: TextFormField(
                          autofocus: true,
                          //controller
                          controller: stationLongitudeController,
                          //validation
                          validator: (latitude) {
                            if (latitude == null || latitude.isEmpty) {
                              return "Longitude Field  Is Empty";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.map,
                                color: Color.fromARGB(255, 232, 19, 4),
                              ),
                              border: InputBorder.none,
                              hintText: "Longitude"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //pickImage
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // pick image function
                              _pickImage();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 96, 202, 86),
                              onPrimary: Colors.black,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Upload Station Image',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 150,
                          width: 140,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 210, 210),
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _stationImage != null
                              ? Image.memory(_stationImage)
                              : const Center(
                                  child: Text("Add New Station"),
                                ),
                        ),
                        // Expanded(
                        //   child: Container(
                        //       height: 150,
                        //       decoration: BoxDecoration(
                        //           border: Border.all(),
                        //           color:
                        //               const Color.fromARGB(255, 101, 182, 104)),
                        //       child: _stationImage != null
                        //           ? Image.memory(_stationImage)
                        //           : const Center(
                        //               child: Text("Add New Station"),
                        //             )),
                        // ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //add user button
                    Container(
                      height: 50,
                      width: 400.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          //getting user infor fron textediting controllers
                          var stationName = stationNameController.text.trim();
                          var stationAddress =
                              stationAddressController.text.trim();
                          var stationContact =
                              stationContactController.text.trim();
                          var stationLatitude =
                              stationLongitudeController.text.trim();
                          var stationLongitude =
                              stationLongitudeController.text.trim();
                          if (_formKey.currentState!.validate()) {
                            //uploadStationImageOnFireStorage();
                            try {
                              //code to store station list on firebase collection
                              if (_stationImage != null) {
                                String imageUrl =
                                    await _uploadStationImageToStorage(
                                        _stationImage);
                                await _firestore
                                    .collection("stations")
                                    .doc()
                                    .set({
                                  "station_name": stationName,
                                  "contact": stationContact,
                                  "address": stationAddress,
                                  "latitude": stationLatitude,
                                  "longitude": stationLongitude,
                                  "image": imageUrl,
                                });
                              }
                              // await FirebaseFirestore.instance
                              //     .collection("stations")
                              //     .add({
                              //   "stationId": getStationId,
                              //   "station_name": stationName,
                              //   "address": stationAddress,
                              //   "contact": stationContact,
                              //   "latitude": stationLatitude,
                              //   "longitude": stationLongitude,
                              // });

                              Navigator.pop(context);
                              //pupup message after inserting station
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "New Station Created Successfully !!"),
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 232, 19, 4), // Background color
                          onPrimary: Colors.grey, // Text color
                          elevation: 4, // Button elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Button border radius
                          ),
                        ),
                        child: const Text('Add User',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const CreateNewUserScreen(),
        //   ),
        //  );
        // Get.to(() => CreateNewUserScreen);
      },
      child: Image.asset("assets/add_user2.png"),
    );
  }
}
