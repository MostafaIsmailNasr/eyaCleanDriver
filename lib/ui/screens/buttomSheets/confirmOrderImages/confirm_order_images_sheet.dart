import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:eya_clean_driver_laundry/conustant/toast_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';


import '../../../../business/bagNumberController/BagNumberController.dart';
import '../../../../business/homeController/HomeController.dart';

import '../../../../conustant/my_colors.dart';
import '../confirmButtomSheet/confirm_buttom_sheet.dart';

class ConfirmOrderImagesSheet extends StatefulWidget{
  String code;
  int id;
  String item;

  ConfirmOrderImagesSheet({required this.code,required this.id,required this.item});


  @override
  State<StatefulWidget> createState() {
    return _ConfirmOrderImagesSheet();
  }
}

class _ConfirmOrderImagesSheet extends State<ConfirmOrderImagesSheet>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  final bagNumberController = Get.put(BagNumberController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: 2.h,left: 2.h,top: 1.h,bottom: 1.h),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBar(),
              SizedBox(height: 1.h,),
              enterImgs(),
              SizedBox(height: 1.h,),
              Text('make_sure_visible'.tr(),style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark2)),
              SizedBox(height: 1.h,),
              Center(
                child: Obx(() =>
                    Visibility(
                        visible: bagNumberController.isVisable.value,
                        child: const CircularProgressIndicator(color: MyColors.MainColor,)
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 8.h,
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    if(bagNumberController.image1!=null||bagNumberController.image2!=null||bagNumberController.image3!=null){
                      bagNumberController.isVisable.value=true;
                      if(widget.item=="item"){
                        bagNumberController.updateBagNumber2(context,widget.code,widget.id);
                      }else if(widget.item=="map"){
                        bagNumberController.updateBagNumberMap(context,widget.code,widget.id);
                      }
                      else{
                        bagNumberController.updateBagNumber(context,widget.code,widget.id);
                      }
                    }else{
                     ToastClass.showCustomToast(context, 'please_enter_three_img'.tr(), "error");
                    }
                  },
                  child: Text('confirm'.tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'lexend_bold',
                        fontWeight: FontWeight.w700,
                        color: Colors.white),),
                ),
              )
              /*Center(
                child: Obx(() =>
                    Visibility(
                        visible: createOrderController.isVisable
                            .value,
                        child: const CircularProgressIndicator(color: MyColors.MainColor,)
                    )),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
  Widget CustomBar(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h,),
        Text('bag_number'.tr(),
          style:  TextStyle(fontSize: 11.sp,
              fontFamily: 'lexend_medium',
              fontWeight: FontWeight.w500,
              color: MyColors.Dark2),
        ),
        SizedBox(height: 1.h,),
        Text(widget.code,
          style:  TextStyle(fontSize: 18.sp,
              fontFamily: 'lexend_medium',
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        SizedBox(height: 1.h,),
      ],
    );
  }

  Widget enterImgs(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            width:MediaQuery.of(context).size.width,
            height: 18.h,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  //uploadImage(source: ImageSource.gallery);
                  uploadImage1();
                });
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(15),
                color: MyColors.MainColor2,//color of dotted/dash line
                strokeWidth: 1, //thickness of dash/dots
                dashPattern: const [10,6],
                child:bagNumberController.image1!=null? Stack(
                  //alignment: Alignment.topRight,
                  children: [
                    Container(
                      height:18.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image:DecorationImage(image: FileImage(bagNumberController.image1!),fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                            onTap: (){
                              setState(() {
                                bagNumberController.image1=null;
                              });
                            },
                            child: SvgPicture.asset('assets/close4.svg',width: 5.h,height: 3.5.h,)))
                  ],
                ):
                Container(
                  height:18.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:MyColors.MainColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //const SizedBox(width: 29,height: 21,child: Image(image: AssetImage('assets/up.png'))),
                        Text(
                          'Add_photo'.tr(),
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'lexend_medium',
                              fontWeight: FontWeight.w500,
                              color: MyColors.Dark2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 18.h,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  uploadImage2();
                });
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(15),
                color: MyColors.MainColor2,//color of dotted/dash line
                strokeWidth: 1, //thickness of dash/dots
                dashPattern: const [10,6],
                child:bagNumberController.image2!=null? Stack(
                  children: [
                    Container(
                      height:18.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image:DecorationImage(image: FileImage(bagNumberController.image2!),fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                            onTap: (){
                              setState(() {
                                bagNumberController.image2=null;
                              });
                            },
                            child: SvgPicture.asset('assets/close4.svg',width: 5.h,height: 3.5.h,)))
                  ],
                ):
                Container(
                  height:18.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:MyColors.MainColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //const SizedBox(width: 29,height: 21,child: Image(image: AssetImage('assets/up.png'))),
                        Text(
                          'Add_photo'.tr(),
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'lexend_medium',
                              fontWeight: FontWeight.w500,
                              color: MyColors.Dark2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 18.h,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  uploadImage3();
                });
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(15),
                color: MyColors.MainColor2,//color of dotted/dash line
                strokeWidth: 1, //thickness of dash/dots
                dashPattern: const [10,6],
                child:bagNumberController.image3!=null? Stack(
                  children: [
                    Container(
                      height:18.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image:DecorationImage(image: FileImage(bagNumberController.image3!),fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                            onTap: (){
                              setState(() {
                                bagNumberController.image3=null;
                              });
                            },
                            child: SvgPicture.asset('assets/close4.svg',width: 5.h,height: 3.5.h,)))
                  ],
                ):
                Container(
                  height:18.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:MyColors.MainColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //const SizedBox(width: 29,height: 21,child: Image(image: AssetImage('assets/up.png'))),
                        Text(
                          'Add_photo'.tr(),
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'lexend_medium',
                              fontWeight: FontWeight.w500,
                              color: MyColors.Dark2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> uploadImage1() async {
    final picker = ImagePicker();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('upload_image'.tr(),style:  TextStyle(fontSize: 16.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w800,
              color: MyColors.Dark1)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('camera'.tr(),style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark2)),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      //File imageFile = File(pickedImage.path);
                      setState(() {
                        bagNumberController.image1=File(pickedImage!.path);
                      });
                    }
                  },
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  child: Text('gallery'.tr(),
                      style:  TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark2)),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      //File imageFile = File(pickedImage.path);
                      setState(() {
                        bagNumberController.image1=File(pickedImage!.path);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadImage2() async {
    final picker = ImagePicker();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('upload_image'.tr(),style:  TextStyle(fontSize: 16.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w800,
              color: MyColors.Dark1)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('camera'.tr(),style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark2)),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      //File imageFile = File(pickedImage.path);
                      setState(() {
                        bagNumberController.image2=File(pickedImage!.path);
                      });
                    }
                  },
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  child: Text('gallery'.tr(),
                      style:  TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark2)),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      //File imageFile = File(pickedImage.path);
                      setState(() {
                        bagNumberController.image2=File(pickedImage!.path);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadImage3() async {
    final picker = ImagePicker();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('upload_image'.tr(),style:  TextStyle(fontSize: 16.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w800,
              color: MyColors.Dark1)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('camera'.tr(),style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark2)),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      //File imageFile = File(pickedImage.path);
                      setState(() {
                        bagNumberController.image3=File(pickedImage!.path);
                      });
                    }
                  },
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  child: Text('gallery'.tr(),
                      style:  TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark2)),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      //File imageFile = File(pickedImage.path);
                      setState(() {
                        bagNumberController.image3=File(pickedImage!.path);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}