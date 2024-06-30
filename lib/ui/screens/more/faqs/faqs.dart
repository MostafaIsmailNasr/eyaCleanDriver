import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/changeLanguageController/ChangeLanguageController.dart';
import 'dart:math' as math;

import '../../../../business/faqsController/FaqsController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../widget/AnswerQuestionItem.dart';
import '../../../widget/QuestionsFaqs.dart';

class FaqsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FaqsScreen();
  }
}

class _FaqsScreen extends State<FaqsScreen>{
  var selectedFlage;
  var selectedFlageTime=0;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  var con=true;
  final faqsController = Get.put(FaqsController());
  final changeLanguageController = Get.put(ChangeLanguageController());

  @override
  void initState() {
    check();
    faqsController.getFaqs();
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
            child: Text('faqs'.tr(),
                style:  TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark1)),
          ),
        ),
        body:con? Obx(
              () => !faqsController.isLoading.value
              ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsetsDirectional.only(start: 2.h, end: 2.h, top: 2.h),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'how_can_we_help_you'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'lexend_bold',
                        fontWeight: FontWeight.w800,
                        color: MyColors.Dark1,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'top_questions'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'lexend_regular',
                        fontWeight: FontWeight.w400,
                        color: MyColors.Dark3,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Expanded(child: QuestionsList()),
                  ],
                ),
                QuestionsList(),
                SizedBox(height: 2.h),
                AnswerList(), // Wrap with Expanded instead of Flexible
              ],
            ),
          )
                : const Center(child: CircularProgressIndicator(color: MyColors.MainColor)),):NoIntrnet()
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
                faqsController.getFaqs();
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

  Widget QuestionsList(){
    if(faqsController.faqList.isNotEmpty){
      return GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: (2 / 1),
            crossAxisSpacing: 12,
            mainAxisSpacing: 8,
          ),
          itemCount: faqsController.faqList.length,
          itemBuilder: (context, int index) {
            return QuestionsFaqs(
                is_selected: selectedFlageTime==index,
                onTap: () {
                  setState(() {
                    selectedFlageTime=index;
                  });
                },
                allFaqs: faqsController.faqList[index]
            );
          });
    }else{
      return Container();
    }
  }

  Widget AnswerList() {
    if(faqsController.faqsResponse.value.data!.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: faqsController.faqsResponse.value.data![selectedFlageTime]
            .faqs!.length,
        itemBuilder: (context, i) {
          var faq = faqsController.faqsResponse.value.data![selectedFlageTime]
              .faqs![i];
          return AnswerQuestionItem(
            question: faq.question,
            answer: faq.answer,
          );
        },
      );
    }else{
      return Container();
    }
  }
}



