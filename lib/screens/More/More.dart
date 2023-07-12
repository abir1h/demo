import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors.dart';
import '../HomePage/HomeController.dart';
import '../auth/LogIn.dart';
class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {

  @override
  Widget build(BuildContext context) { final controller = Get.put(HomePageController());
  var size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none_outlined,color: Colors.black87,),
          )
        ],
        title:Obx(()=> Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.name.value.toString(),style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 16)),
            Text(controller.phone.value.toString(),style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 12)),
          ],
        ),),
        leading:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.mainColor,
              child: Image.asset('assets/images/luser.png',height: 20,width: 20,color: Colors.white,)
          ),
        ),
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            const Divider(
              thickness: 6,
              color: AppColors.Divider,
            ),  ListTile(
              leading: Icon(Icons.settings,color: AppColors.mainColor,),
              title: Text("Settings"),
            ),
            ListTile(
              onTap: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear().then((value) => Get.to(()=>LoginView()));
              },
              leading: Icon(Icons.logout,color: AppColors.mainColor,),
              title: Text("Logout"),
            )
          ],
        ),
      ),
    ));
  }
}
