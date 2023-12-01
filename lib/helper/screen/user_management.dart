import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import 'editUser_screen.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({Key? key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  //TextEditcontroller
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  //
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> deleteUserData(String userUid) async {
    try {
      await _usersCollection.doc(userUid).delete();
    } catch (e) {
      print("Error deleting user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/add_user2.png"),
        title: const Text("Manage User"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data?.docs;
          if (users != null) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index].data() as Map<String, dynamic>;
                final username = user['username'] ?? "Name not available";
                final userEmail = user['userEmail'] ?? "Email not available";
                final userContact =
                    user['userContact'] ?? "Contact is not available";
                final userId = user["userId"];

                return Card(
                  elevation: 4, // Adjust the elevation as needed
                  margin:
                      const EdgeInsets.all(8), // Adjust the margin as needed
                  child: ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    title: Center(
                      child: Text(
                        "Name: $username",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text(
                          "Email : $userEmail",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //

                        const Divider(),
                        Text(
                          "Contact : $userContact",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
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
                              () => UpdateUserProfile(
                                userId: userId,
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
                                  deleteUserData(
                                      users[index].id); // pupup message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("User Deleted !"),
                                    ),
                                  );

                                  Navigator.pop(context);
                                });
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
    );
  }
} //





// floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (ctx) => AlertDialog(
//               title: Center(child: Text("Add New User")),
//               //content: const Text("You have raised a Alert Dialog Box"),
//               actions: <Widget>[
//                 Column(
//                   children: [
//                     //text field for username
//                     Container(
//                       height: 50,
//                       width: 400,
//                       decoration: BoxDecoration(
//                           color: const Color(0xFFF1F1F1),
//                           borderRadius: BorderRadius.circular(9)),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8, right: 13),
//                         child: TextFormField(
//                           autofocus: true,
//                           //controller
//                           controller: usernameController,
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                           decoration: const InputDecoration(
//                               prefixIcon: Icon(
//                                 Icons.person,
//                                 color: Colors.green,
//                               ),
//                               border: InputBorder.none,
//                               hintText: "Username"),
//                           keyboardType: TextInputType.text,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     //email text field
//                     Container(
//                       height: 50,
//                       width: 400,
//                       decoration: BoxDecoration(
//                           color: const Color(0xFFF1F1F1),
//                           borderRadius: BorderRadius.circular(9)),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8, right: 13),
//                         child: TextFormField(
//                           //controller
//                           controller: emailController,
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                           decoration: const InputDecoration(
//                               prefixIcon: Icon(
//                                 Icons.email,
//                                 color: Colors.green,
//                               ),
//                               border: InputBorder.none,
//                               hintText: "Email"),
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     //email text contact
//                     Container(
//                       height: 50,
//                       width: 400,
//                       decoration: BoxDecoration(
//                           color: const Color(0xFFF1F1F1),
//                           borderRadius: BorderRadius.circular(9)),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8, right: 13),
//                         child: TextFormField(
//                           //controller
//                           controller: contactController,

//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                           decoration: const InputDecoration(
//                               prefixIcon: Icon(
//                                 Icons.phone,
//                                 color: Colors.green,
//                               ),
//                               border: InputBorder.none,
//                               hintText: "Contact"),
//                           keyboardType: TextInputType.phone,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     //add user button
//                     Container(
//                       height: 50,
//                       width: 400.0,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           //getting user infor fron textediting controllers
//                           var userName = usernameController.text.trim();
//                           var userEmail = emailController.text.trim();
//                           var userContact = contactController.text.trim();

//                           try {
//                             // code to store user data on firebase collection
//                             await FirebaseFirestore.instance
//                                 .collection("users")
//                                 .add({
//                               "createdAt": DateTime.now(),
//                               "username": userName,
//                               "userEmail": userEmail,
//                               "userContact": userContact,
//                               "userId": ""
//                             });
//                           } catch (e) {
//                             print("Error$e");
//                           }
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.green, // Background color
//                           onPrimary: Colors.grey, // Text color
//                           elevation: 4, // Button elevation
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                                 8.0), // Button border radius
//                           ),
//                         ),
//                         child: const Text('Add User',
//                             style:
//                                 TextStyle(fontSize: 20, color: Colors.white)),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );

//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => const CreateNewUserScreen(),
//           //   ),
//           //  );
//           // Get.to(() => CreateNewUserScreen);
//         },
//         child: Image.asset("assets/add_user2.png"),
//       ),