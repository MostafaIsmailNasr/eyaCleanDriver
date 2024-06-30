import 'package:eya_clean_driver_laundry/conustant/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../data/model/orderDetailsModel/OrderDetailsResponse.dart';


class OrderDetailsItems extends StatelessWidget{
  OrderItems? orderItems;

  OrderDetailsItems({required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 1.h),
      child: Row(
        children: [
          Text("${orderItems!.productName}( ${orderItems!.quantity} )",
              style:  TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'lexend_medium',
                  fontWeight: FontWeight.w500,
                  color: MyColors.Dark3)),
          const Spacer(),
          Text(orderItems?.price.toString()??""+" SAR",
              style:  TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'lexend_medium',
                  fontWeight: FontWeight.w500,
                  color: MyColors.Dark1)),
        ],
      ),
    );
  }

}