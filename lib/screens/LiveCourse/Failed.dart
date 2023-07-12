import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:learning_school_bd/screens/MainHome.dart';
import 'package:learning_school_bd/utils/colors.dart';
import 'package:lottie/lottie.dart';

class PaymentFaild extends StatefulWidget {
  const PaymentFaild({Key? key}) : super(key: key);

  @override
  State<PaymentFaild> createState() => _PaymentFaildState();
}

class _PaymentFaildState extends State<PaymentFaild> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/complete.json',height: size.height/4,),
          Center(child: Text('Payment Failed!',style: TextStyle(color: AppColors.blackpanther,fontWeight: FontWeight.w800,fontSize: 26),),),
          SizedBox(height: 10,),
          Center(child: Text('Your payment has been failed',style: TextStyle(color: AppColors.blackpanther,fontWeight: FontWeight.w400,fontSize: 16),),),
          SizedBox(height: 20,),

          InkWell(
            onTap: (){
              Get.to(()=>Main_home(indexof: 0));
            },
            child: Container(width: size.width/3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.green
              ),child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Okay",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),),
              ),
            ),
          )



        ],
      ),

    ));
  }
}
