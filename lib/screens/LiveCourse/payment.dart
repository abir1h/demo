import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/Module/PaymentView.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Module/ModuleController.dart';
import '../Module/ModuleView.dart';
class payment extends StatefulWidget {
  const payment({Key? key}) : super(key: key);

  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {
  TextEditingController promo=TextEditingController();
  final controller = Get.put(ModuleController());
  var UserId;
  getUserdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    setState(() {
      UserId=id;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdata();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        automaticallyImplyLeading: false, // Don't show the leading button

        backgroundColor: Colors.white, elevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title:Text(
    "Payment",
    style: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontSize: 16),
    )),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Apply Promo Code",style: TextStyle(color: Colors.black87,fontWeight:FontWeight.w700,fontSize: 18),),
        ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
              children: [
                 Expanded(
                   child:   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextFormField(
                      controller: promo,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        hintText: "Promo code",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                        ),
                        contentPadding: EdgeInsets.only(left: 20, right: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor.withOpacity(0.2), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 2.0),
                        ),
                      ),

                ),
                   ),
                 ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),color: AppColors.primaryGreen,
                  ),child:   Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(child: Text("Apply",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),),
                  ),
                ),



              ],
          ),
            ),
          Center(
            child: Text('Or',style:TextStyle(
                color: Colors.blueGrey,fontWeight: FontWeight.w700,fontSize: 18
            )),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: (){
                Get.to(()=>PaymentView(id: controller.Courseid.toString(),ammount: controller.price.toString(),userid: UserId.toString()),transition: Transition.rightToLeft,duration: Duration(milliseconds: 500));
              },
              child: Container(
                height: size.height / 18,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryyeollo),
                child: Center(
                  child: Text(
                    "Make Payment",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
