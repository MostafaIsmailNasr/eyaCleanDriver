import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../../../../business/deliveryCodeController/DeliveryCodeController.dart';
import '../../../../conustant/my_colors.dart';
import '../confirmOrderImages/confirm_order_images_sheet.dart';

class DeliveryButtomSheet extends StatefulWidget{
  int orderId;
  String item;

  DeliveryButtomSheet({required this.orderId,required this.item});
  @override
  State<StatefulWidget> createState() {
    return _DeliveryButtomSheet();
  }
}

class _DeliveryButtomSheet extends State<DeliveryButtomSheet>{
  final _formKey = GlobalKey<FormState>();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  final deliveryCodeController = Get.put(DeliveryCodeController());


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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomBar(),
                SizedBox(height: 1.h,),
                enterCode(),
                SizedBox(height: 1.h,),
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
        Text('enter_delivery_code'.tr(),
          style:  TextStyle(fontSize: 12.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w700,
              color: Colors.black),
        ),
        SizedBox(height: 2.h,),
        Text('d'.tr(),
          style:  TextStyle(fontSize: 8.sp,
              fontFamily: 'lexend_regular',
              fontWeight: FontWeight.w500,
              color: MyColors.Dark3),
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
          Obx(() =>
              Visibility(
                  visible: deliveryCodeController.isVisable.value,
                  child: const CircularProgressIndicator(color: MyColors.MainColor,)
              )),
          Obx(() =>   deliveryCodeController.isVisable.value==true?
          Container()
              :SizedBox(
            width: 12.h,
            height: 6.h,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  if(widget.item=="item"){
                    deliveryCodeController.isVisable.value=true;
                    deliveryCodeController.checkDeliveryCode(context,widget.orderId);
                  }else if(widget.item=="map"){
                    deliveryCodeController.isVisable.value=true;
                    deliveryCodeController.checkDeliveryCodeMap(context,widget.orderId);
                  }
                  else{
                    deliveryCodeController.isVisable.value=true;
                    deliveryCodeController.checkDeliveryCode2(context,widget.orderId);
                  }
                }
              },
              child: Text('apply'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),

          )),
        ],
      ),
    );
  }

  Widget code (){
    return Container(
      width: 30.h,
      child: TextFormField(
        autovalidateMode:AutovalidateMode.onUserInteraction ,
        controller: deliveryCodeController.codeController,
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