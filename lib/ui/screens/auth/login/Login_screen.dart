import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/changeLanguageController/ChangeLanguageController.dart';
import '../../../../business/loginController/LoginController.dart';
import '../../../../conustant/my_colors.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen>{
  final loginController = Get.put(LoginController());
  final changeLanguageController = Get.put(ChangeLanguageController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BGColor,
      appBar: AppBar(
        backgroundColor: MyColors.BGColor,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Transform.rotate(
                angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))
        ),
      ),
      body: Container(
        margin:  EdgeInsetsDirectional.only(start: 2.5.h,end: 2.5.h),
        child: Center(
          child: Form(
            key:_formKey ,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15.h,child: //const Image(image: AssetImage('assets/eya_logo.png',),)
                    SvgPicture.asset('assets/eya_logo.svg')
                    ),
                  SizedBox(height: 2.h,),
                  Text('let_s_login_you_in'.tr(), style:  TextStyle(fontSize: 16.sp,
                      fontFamily: 'lexend_bold',
                      fontWeight: FontWeight.w800,
                      color: MyColors.Dark1)),
                  SizedBox(height: 1.h,),
                  Text('Log_in_with_your_phone_number'.tr(), style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w300,
                      color: MyColors.Dark3)),
                  SizedBox(height: 3.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('phone_number'.tr(), style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'lexend_regular',
                          fontWeight: FontWeight.w400,
                          color: MyColors.Dark2)),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: MyColors.BorderColor, width: 1.0,),
                            color: Colors.white),
                        child: PhoneNumber(),
                      ),
                      SizedBox(height: 2.h,),
                      Center(
                        child: Obx(() =>
                            Visibility(
                                visible: loginController.isVisable.value,
                                child: const CircularProgressIndicator(color: MyColors.MainColor,)
                            )),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.h,
                        child: TextButton(
                          style: flatButtonStyle,
                          onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              loginController.isVisable.value=true;
                               loginController.loginUse(context);
                            }
                          },
                          child: Text('continue'.tr(),
                            style:  TextStyle(fontSize: 12.sp,
                                fontFamily: 'lexend_bold',
                                fontWeight: FontWeight.w700,
                                color: Colors.white),),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget PhoneNumber (){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: loginController.PhoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_phone_number'.tr();
        }else if(!value.startsWith("05")){
          return 'phone_number_must_begin'.tr();
        } else if(value.length<10){
          return 'phone_number_must'.tr();
        }
        return null;
      },
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon:   Padding(
            padding: EdgeInsetsDirectional.fromSTEB(1.2.h,0,1.2.h,0),
            child: Image(image: const AssetImage('assets/ar.png',),width: 3.h,height: 3.h,)
        ),
        errorBorder:  const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.white,style: BorderStyle.solid),
        ),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(style: BorderStyle.solid,color: Colors.white,)
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
        ) ,
        hintText: 'enter_phone'.tr(),
        hintStyle:  TextStyle(fontSize: 12.sp,
            fontFamily: 'lexend_regular',
            fontWeight: FontWeight.w300,
            color: MyColors.Dark3),
      ),
      style:  TextStyle(fontSize: 12.sp,
          fontFamily: 'lexend_regular',
          fontWeight: FontWeight.w300,
          color: MyColors.Dark3),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

}