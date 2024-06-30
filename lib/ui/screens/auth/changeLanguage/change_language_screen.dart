
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../AppRouter.dart';
import '../../../../business/changeLanguageController/ChangeLanguageController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/di.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../conustant/shared_preference_serv.dart';
import '../../../../conustant/toast_class.dart';
import '../../../../main.dart';

class ChangeLanguageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _changeLanguageScreen();
  }
}

class _changeLanguageScreen extends State<ChangeLanguageScreen>{
  final homeController = Get.put(HomeController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  var isSelected=false;
  int? itemId=0;
  final changeLanguageController = Get.put(ChangeLanguageController());
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();


  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BGColor,
      appBar: AppBar(backgroundColor: MyColors.BGColor,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/eya_logo.svg'),
            SizedBox(height: 2.h,),
            Text('welcome_to_eya_clean_driver'.tr(),
              style: TextStyle(fontSize: 16.sp,
                  fontFamily: 'lexend_extraBold',
                  fontWeight: FontWeight.w800,
                  color: MyColors.Dark1),),
            SizedBox(height: 1.h,),
            Text('please_choose_your_language'.tr(),
              style: TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w300,
                  color: MyColors.Dark3),),
            SizedBox(height: 2.h,),
            InkWell(
              onTap: (){
                setState(() {
                  isSelected=true;
                  itemId=1;
                  changeLanguageController.lang='en';
                  sharedPreferencesService.setString("lang", changeLanguageController.lang);
                  translator.setNewLanguage(
                    context,
                    newLanguage: changeLanguageController.lang,
                    remember: true,
                  );
                  Phoenix.rebirth(context);

                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 8.h,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: MyColors.BorderColor, width: 1.0,),
                    color: Colors.white
                ),
                margin: const EdgeInsetsDirectional.only(start: 10,end: 10),
                padding:  EdgeInsets.all(1.5.h),
                child: Row(
                  children: [
                    Image(image: AssetImage('assets/en.png')),
                    SizedBox(width: 2.w,),
                    Text('english'.tr(),
                      style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'lexend_bold',
                          fontWeight: FontWeight.w700,
                          color: MyColors.Dark2),),
                    const Spacer(),
                    isSelected==true && itemId==1?SvgPicture.asset('assets/checked.svg'):SvgPicture.asset('assets/unChecked.svg'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h,),
            InkWell(
              onTap: (){
                setState(() {
                  isSelected=true;
                  itemId=2;
                  changeLanguageController.lang='ar';
                  sharedPreferencesService.setString("lang", changeLanguageController.lang);
                  translator.setNewLanguage(
                    context,
                    newLanguage: changeLanguageController.lang,
                    remember: true,
                  );
                  // Navigator.push(
                  //   context,
                  //   CupertinoPageRoute(builder: (context) =>  MyApp(appRouter: AppRouter(),)),
                  // );
                  Phoenix.rebirth(context);
                });

              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 8.h,
                margin: const EdgeInsetsDirectional.only(start: 10,end: 10),
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: MyColors.BorderColor, width: 1.0,),
                  color: Colors.white
                ),
                child: Row(
                  children: [
                    const Image(image: AssetImage('assets/ar.png')),
                    SizedBox(width: 2.w,),
                    Text('arabic'.tr(),
                      style: TextStyle(fontSize: 12.sp,
                          fontFamily: 'lexend_bold',
                          fontWeight: FontWeight.w700,
                          color: MyColors.Dark3),),
                    const Spacer(),
                    isSelected==true && itemId==2?SvgPicture.asset('assets/checked.svg'):SvgPicture.asset('assets/unChecked.svg'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h,),
            Container(
              margin: EdgeInsets.only(left: 3.h, right: 3.h),
              width: double.infinity,
              height: 8.h,
              child: TextButton(
                style: flatButtonStyle,
                onPressed: () async{
                  if(isSelected!=false){
                    if (sharedPreferencesService.getBool("islogin") == true) {
                      Navigator.pushNamedAndRemoveUntil(context,'/drower_screen',ModalRoute.withName('/drower_screen'),arguments: 0);

                    } else {
                      Navigator.pushNamed(context, "/Login_screen");
                    }
                  }else{
                    ToastClass.showCustomToast(context, 'please_choose_lang'.tr(), 'error');
                  }
                },
                child: Text('continue'.tr(),
                  style: TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_bold',
                      fontWeight: FontWeight.w700,
                      color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCurrentLocation() async {
    // Request permission to access the device's location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the scenario when the user denies permission
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the scenario when the user denies permission forever
      return;
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    homeController.lat=position.latitude;
    homeController.lng=position.longitude;

    // Convert the position into an address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the address name from the placemark
    Placemark placemark = placemarks.first;
    String address = (placemark.street! +placemark.locality!+ placemark.country!)?? '';
    //placemark.street

    // Update the UI with the current address
    setState(() {
      homeController.currentAddress = address;
    });
    print("S"+homeController.currentAddress.toString());
  }

}