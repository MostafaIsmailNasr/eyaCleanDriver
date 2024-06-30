import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import '../../../../business/changeLanguageController/ChangeLanguageController.dart';
import '../../../../business/termsAndConditionController/TermsAndConditionController.dart';
import '../../../../conustant/my_colors.dart';
import 'dart:math' as math;

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  final termsAndConditionController = Get.put(TermsAndConditionController());
  final changeLanguageController = Get.put(ChangeLanguageController());
  var con=true;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));

  @override
  void initState() {
    check();
    termsAndConditionController.getTermsAndConditions();
    super.initState();
  }

  Future<void> check()async{
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BGColor,
      appBar: AppBar(
        backgroundColor: MyColors.BGColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Transform.rotate(
                angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))),
        title: Center(
          child: Text('Terms_and_Conditions'.tr(),
              style:  TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'lexend_bold',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark1)),
        ),
      ),
      body:con? Obx(() =>!termsAndConditionController.isLoading.value?
      Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Padding(
                            padding:  EdgeInsets.only(left: 2.h, right: 2.h),
                            child: Text(
                              textAlign: TextAlign.start,
                              'Welcome_to_app'.tr(),
                              style:  TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'lexend_bold',
                                  fontWeight: FontWeight.w800,
                                  color: MyColors.Dark1),
                            )),
                        Padding(
                            padding:
                            EdgeInsets.only(left: 2.h, right: 2.h, top: 1.h),
                            child: Text(
                                textAlign: TextAlign.start,
                                'by_using_our_service'.tr(),
                                style:  TextStyle(
                                    fontSize: 11.sp,
                                    fontFamily: 'lexend_regular',
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.Dark3))),
                        Container(width: MediaQuery.of(context).size.width,
                          margin: EdgeInsetsDirectional.only(end: 1.h,start: 1.h,top: 2.h),
                          height: 0.2.h,
                          color: MyColors.Dark5,),
                        SizedBox(
                          height: 2.h,
                        ),
                        //termList(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: kk(),
                        ),
                      ]))),
          SizedBox(
            height: 3.h,
          )
        ],
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainColor),)): NoIntrnet(),

    );
  }

  Widget NoIntrnet(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SvgPicture.asset('assets/no_internet.svg'),
          Image.asset('assets/no_internet.png'),
          SizedBox(height: 1.h,),
          Text('there_are_no_internet'.tr(),
            style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,color: MyColors.Dark1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h,),
          Container(
            width: double.infinity,
            height: 6.h,
            margin:  EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () async{
                await check();
                termsAndConditionController.getTermsAndConditions();
              },
              child: Text('internet'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          ),
        ],
      ),

    );
  }

  Widget kk(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 1.h,
          height: 1.h,
          decoration: const BoxDecoration(
            color: MyColors.Dark1,
            shape: BoxShape.circle,
          ),
          margin:  EdgeInsets.only(right: 1.h),
        ),
        Flexible(
          child: Html(
            data:termsAndConditionController.termsAndConditionsResponse.value.data!.content??""),
        ),
      ],
    );
  }
}
