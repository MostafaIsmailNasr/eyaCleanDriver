
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../../conustant/my_colors.dart';

import '../../data/model/listOrderModel/ListOrderResponse.dart';
import '../screens/buttomSheets/deliveryButtomSheet/delivery_buttom_sheet.dart';
import '../screens/orderDetails/order_details_screen.dart';
import '../screens/buttomSheets/deliveryButtomSheet/delivery_buttom_sheet.dart';

class DropOffItem extends StatefulWidget {
  Orders? orders;

  DropOffItem({required this.orders});
  @override
  State<StatefulWidget> createState() {
    return _DropOffItem();
  }

}

class _DropOffItem extends State<DropOffItem>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OrderDetailsScreen(id: widget.orders?.id,from: ""),));
        Navigator.pushNamed(context, "/order_details_screen",arguments: "DropOff");
      },
      child: Container(
        margin:  EdgeInsetsDirectional.all(1.h),
        padding:  EdgeInsets.all(1.5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: MyColors.BorderColor, width:1.0,),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${'order_no'.tr()} ",
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark1),
                ),
                Text(
                  "#${widget.orders?.number??""}",
                  //"#${ordersList.id??""}",
                  style: TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark1),
                ),
                const Spacer(),
                Container(
                  width: 15.w,
                  //height: 3.h,
                  padding: EdgeInsetsDirectional.all(1.h),
                  decoration: BoxDecoration(
                    color: MyColors.MainColor2,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      widget.orders?.type??"",
                      //ordersList.typeLang??"",
                      style:  TextStyle(fontSize: 8.sp,
                          fontFamily: 'lexend_light',
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset('assets/moneys.svg',width: 3.w,height: 3.h,),
                SizedBox(width: 2.w,),
                Text(
                  widget.orders?.payment??"",
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark2),
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset('assets/map.svg',width: 3.w,height: 3.h,),
                SizedBox(width: 2.w,),
                SizedBox(
                  width: 30.h,
                  child: Text(
                    widget.orders?.address?.streetName??"",
                    style: TextStyle(fontSize: 10.sp,
                        fontFamily: 'lexend_regular',
                        fontWeight: FontWeight.w400,
                        color: MyColors.Dark2),maxLines: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h,),
            /*Row(
            Row(
              children: [
                SvgPicture.asset('assets/dollar_square.svg',width: 3.w,height: 3.h,),
                SizedBox(width: 2.w,),
                Text(
                  "nears - 10km",
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark2),
                ),
              ],
            ),
            SizedBox(height: 1.h,),*/
            SizedBox(height: 1.h,),
            Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/bag_detailes.svg'),
                    SizedBox(width: 1.h,),
                    Text('bag_number'.tr(),
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'lexend_medium',
                            fontWeight: FontWeight.w500,
                            color: MyColors.Dark3)),
                  ],
                ),
                SizedBox(width: 1.h,),
                Text(widget.orders?.bagNumber.toString()??"",
                    style:  TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'lexend_medium',
                        fontWeight: FontWeight.w500,
                        color: MyColors.Dark1)),
              ],
            ),
            SizedBox(height: 1.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'drop_off_date'.tr(),
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'lexend_light',
                      fontWeight: FontWeight.w300,
                      color: MyColors.Dark3),
                ),
                Text(
                  widget.orders?.receivedDate??"",
                  style:  TextStyle(fontSize: 10.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark2),
                ),
              ],
            ),
            SizedBox(height: 1.h,),
            Container(
              width: double.infinity,
              height: 6.h,
              margin:  EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
              child: TextButton(
                style: flatButtonStyle,
                onPressed: () {
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

                          child: DeliveryButtomSheet(orderId: widget.orders!.id!,item: "item",)));
                },
                child: Text(
                   'delivered'.tr(),
                  style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_bold',
                      fontWeight: FontWeight.w700,
                      color:Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}