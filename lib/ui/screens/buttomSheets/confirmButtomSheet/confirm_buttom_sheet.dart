import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../conustant/my_colors.dart';

class ConfirmButtomSheet extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ConfirmButtomSheet();
  }
}

class _ConfirmButtomSheet extends State<ConfirmButtomSheet>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: 2.h,left: 2.h,top: 1.h,bottom: 1.h),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.h,),
            SvgPicture.asset('assets/check_circle.svg'),
            SizedBox(height: 3.h,),
            Text('delivery_confirmed'.tr(),style:  TextStyle(fontSize: 14.sp,
                fontFamily: 'lexend_bold',
                fontWeight: FontWeight.w700,
                color: MyColors.Dark1)),
            SizedBox(height: 1.5.h,),
            Text('your_dropoff_order_has_been_successfully_confirmed'.tr(),style:  TextStyle(fontSize: 12.sp,
                fontFamily: 'lexend_regular',
                fontWeight: FontWeight.w400,
                color: MyColors.Dark3),textAlign: TextAlign.center),
            SizedBox(height: 1.5.h,),
          ],
        ),
      ),
    );
  }

}