import 'package:ev_admin/helper/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () async {
            QuickAlert.show(
                showCancelBtn: true,
                context: context,
                type: QuickAlertType.warning,
                text: 'Are You Sure Want To Logout?',
                cancelBtnText: "Cancle",
                onCancelBtnTap: () {
                  Navigator.pop(context);
                },
                confirmBtnText: "Logout",
                onConfirmBtnTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.off(const LoginScreen());
                });
          },
          icon: const Icon(
            Icons.logout,
            size: 50,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
