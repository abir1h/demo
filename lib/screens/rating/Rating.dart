import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_school_bd/screens/MainHome/Main-Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Appurl.dart';
import '../../utils/colors.dart';
import 'package:http/http.dart'as http;
class Rating extends StatefulWidget {
  final String id;
  const Rating({Key? key,required this.id}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  var avgRating = 0.0;
  var food=0.0;
  var service=0.0;
  var ambiance=0.0;
  var price=0.0;
  ImagePicker picker = ImagePicker();
  var _image;
  Future takephoto_camera() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
    });
    //return image;
  } Future takephoto_gallary() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
    //return image;
  }
  Widget bottomSheetProfileEdit() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ignore: deprecated_member_use
              TextButton.icon(
                icon: Icon(Icons.camera),
                label: Text("Camera"),
                onPressed: () {
                  takephoto_camera();
                  Navigator.pop(context);
                },
              ),
              // ignore: deprecated_member_use
              TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text("Gallery"),
                  onPressed: () {
                    takephoto_gallary();
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }
  bool isrequsted=false;

  Future withdraw(String food,String service,String ambiance,String pricing,String reviewText,String avg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.ratingPost+widget.id),
    );
    request.fields.addAll({
      // 'location':location,
      "food_rating":food,
      "service_rating":service,
      "ambiance_rating":ambiance,
      "price_rating":pricing,
      "review_details":reviewText,
      "overall_rating":avg,



    });


    if (_image != null) {
      request.files.add(
          await http.MultipartFile.fromPath(
              'image', _image.path));
    }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {


          setState(() {
            isrequsted = false;
          });
          Fluttertoast.showToast(
              msg: "Rating Submitted Succefully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Get.to(()=>Main_home());
/*
          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: worker_profile()));
*/

        } else {
          setState(() {
            isrequsted = false;
          });
          print("Fail! ");
          print(response.body.toString());
          Fluttertoast.showToast(
              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;
        }
      });
    });
  }

  TextEditingController review=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.orange,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const CircleAvatar(
              radius: 5,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Your Experience",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: isrequsted==false?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Rate Your Experience',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
              ),
            ),
            Center(
              child: RatingBarIndicator(
                rating: avgRating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 50.0,
                direction: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,

                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.greenLight,
                          child: SvgPicture.asset('assets/images/food.svg'),
                        ),
                        Text(
                          'Food',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: AppColors.green,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          food=rating;
                          avgRating=(rating+service+ambiance+price)/4;
                        });
                        print(avgRating);

                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: Column(

                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.ora,
                          child: SvgPicture.asset('assets/images/service.svg'),
                        ),
                        Text(
                          'Service',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: AppColors.oragd,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          service=rating;
                          avgRating=(food+rating+ambiance+price)/4;
                        });

                        },
                    ),
                  )
                ],
              ),
            ), SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,

                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.ambiance,
                          child: SvgPicture.asset('assets/images/group.svg',),
                        ),
                        Text(
                          'Ambience',
                          style: TextStyle(color: Colors.grey,fontSize: 12),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: AppColors.ambiancedark,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          ambiance=rating;
                          avgRating=(food+service+rating+price)/4;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,

                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.pricing,
                          child: SvgPicture.asset('assets/images/price.svg',),
                        ),
                        Text(
                          'Pricing',
                          style: TextStyle(color: Colors.grey,fontSize: 12),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: AppColors.pricingdark,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          price=rating;
                          avgRating=(food+service+ambiance+rating)/4;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Write Your Review',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height/6,
                width: size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),

                      spreadRadius: 2,

                      blurRadius: 4,

                      offset: const Offset(
                          0, 0), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        AppColors.ge,
                        Colors.white
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: review,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "Write here",
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(.5)),
                        border:InputBorder.none
                    ),
                  ),
                ),
              ),
            ),
            _image!=null?Padding(
              padding: const EdgeInsets.only(left: 18.0,top: 10,bottom: 5),
              child: Row(
                children: [
                  Image.file(

                    _image,
                    fit: BoxFit.cover,height: 80,width: 80,

                  ),
                  IconButton(onPressed: (){setState(() {
                    _image=null;
                  });}, icon: Icon(Icons.close))
                ],
              ),
            ):Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                      context: (context),
                      builder: (builder) => bottomSheetProfileEdit());
                },
                child: Container(
                  height: 30,width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(.5))
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.file_upload_outlined,color: Colors.grey,),
                      Text("   Upload Picture",style: TextStyle(color: Colors.grey,fontSize: 12),)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  if(food==0){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please give food rating',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else  if(service==0){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please give service rating',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else  if(ambiance==0){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please give ambiance rating',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else  if(price==0){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please give pricing rating',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else  if(_image==null){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Data Missing',
                      desc: 'Please upload a picture',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                  }else{
                    setState(() {
                      isrequsted=true;
                    });
                    withdraw(

                        food.toString(), service.toString(), ambiance.toString(), price.toString(), review.text.isNotEmpty?review.text:'',avgRating.toString());
                  }
                },
                child: Container(
                  height: size.height/25,width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.orange),

                  ),child: Center(
                  child: Text("Submit",style: TextStyle(color: Colors.orange,fontSize: 16),),
                ),
                ),
              ),
            ),
            SizedBox(height: 50,),
          ],
        ):Column(
          children: [
            SizedBox(height: size.height/2.5,),
            Center(
              child: SpinKitCircle(
                color: Colors.orange,
                size: 35,
              ),
            ),Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Please wait...',style: TextStyle(color: Colors.orange),),
            ),)
          ],
        ),
      ),
    ));
  }
}
