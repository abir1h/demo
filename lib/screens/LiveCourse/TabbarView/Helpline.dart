import 'package:flutter/material.dart';
import 'package:learning_school_bd/utils/colors.dart';
class HelpLine extends StatefulWidget {
  const HelpLine({Key? key}) : super(key: key);

  @override
  State<HelpLine> createState() => _HelpLineState();
}

class _HelpLineState extends State<HelpLine> {
  List iamges=['assets/images/c3.png','assets/images/c1.png','assets/images/c2.png',];
  bool desmore=false;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text('Help Line',style: TextStyle(
              fontSize: 16,fontWeight: FontWeight.w600
          ),),                              SizedBox(height: 15,),
          Divider(),
          SizedBox(height: 15,),

          Text("For any quires regarding this batch , call"),
          Row(
            children: [
              Text("+8801676772959 ",style: TextStyle(color: AppColors.orange),),
              Text("From 10AM To 10PM ."),

            ],
          ), SizedBox(height: 20,),

          /*Text("Job Opportunities at the end of the course",style: TextStyle(color: AppColors.primaryprice_text,fontWeight: FontWeight.w700,fontSize: 20),),
          SizedBox(
            height: size.height/7,
            width: size.width,
            child: ListView.builder(
              shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: iamges.length,
                itemBuilder: (_,index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height/7,
                  width: size.width/2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:AssetImage(iamges[index]),
                      fit: BoxFit.fill
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 15,),*/
          Text('Payment',style: TextStyle(
              fontSize: 16,fontWeight: FontWeight.w600
          ),),                              SizedBox(height: 15,),
          Divider(),
          SizedBox(height: 15,),
          Text("If you want to join live batch and make payment-\n1. Click on the Join Live Batch button\n2. Select your batch schedule\n3. Click on the Purchase button\n4. Select the payment method at your convenience\n5. Complete the payment\nAt the end of the process you will get a message and your batch will show up in your dashboard. Start the course according to your study plan.")



        ],
      ),
    );
  }
}
