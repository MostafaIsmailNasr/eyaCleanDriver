import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../conustant/my_colors.dart';
import '../confirmOrderImages/confirm_order_images_sheet.dart';

class BagNumberButtomSheet extends StatefulWidget{
  int id;
  String? item;
  BagNumberButtomSheet({required this.id,required this.item});

  @override
  State<StatefulWidget> createState() {
    return _BagNumberButtomSheet();
  }
}

class _BagNumberButtomSheet extends State<BagNumberButtomSheet>{
  final _formKey = GlobalKey<FormState>();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: 2.h,left: 2.h,top: 1.h,bottom: 1.h),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomBar(),
                SizedBox(height: 1.h,),
                enterCode(),
                SizedBox(height: 1.h,),
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
      ),
    );
  }
  Widget CustomBar(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h,),
        Text('enter_bag_number'.tr(),
          style:  TextStyle(fontSize: 12.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w700,
              color: Colors.black),
        ),
        SizedBox(height: 2.h,),
      ],
    );
  }

  Widget enterCode(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 8.h,
      child: Row(
        children: [
          code(),
          const Spacer(),
          // Obx(() =>
          //     Visibility(
          //         visible: createOrderController.isVisable.value,
          //         child: const CircularProgressIndicator(color: MyColors.MainColor,)
          //     )),
          /*Obx(() =>   createOrderController.isVisable.value==true?
          Container()
              :SizedBox(
            width: 12.h,
            height: 6.h,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  createOrderController.isVisable.value=true;
                  createOrderController.validateCopune(context);
                }
              },
              child: Text('apply'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          ))*/
          SizedBox(
            width: 12.h,
            height: 6.h,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  Navigator.pop(context);
                  showModalBottomSheet<void>(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: ConfirmOrderImagesSheet(code: codeController.text,id: widget.id,item:widget.item!)));
                }
              },
              child: Text('apply'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }

  Widget code (){
    return Container(
      width: 30.h,
      child: TextFormField(
        autovalidateMode:AutovalidateMode.onUserInteraction ,
        controller: codeController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'please_enter_code'.tr();
          }
          return null;
        },
        maxLines: 1,
        decoration: const InputDecoration(
          errorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: MyColors.MainColor2,style: BorderStyle.solid),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(style: BorderStyle.solid,color: MyColors.MainColor2,)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
          ) ,
        ),
        style:  TextStyle(fontSize: 11.sp,
            fontFamily: 'lexend_regular',
            fontWeight: FontWeight.w300,
            color: MyColors.Dark3),
        keyboardType: TextInputType.number,
      ),
    );
  }
}