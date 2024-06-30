import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';


import '../../../../../business/homeController/HomeController.dart';
import '../../../../../conustant/my_colors.dart';

class FilterDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FilterDialog();
  }
}

class _FilterDialog extends State<FilterDialog>with SingleTickerProviderStateMixin{
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  TextEditingController RecipientName = TextEditingController();
  TextEditingController OrderNumber = TextEditingController();
  TextEditingController BagNumber = TextEditingController();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  final ButtonStyle flatButtonStyle2 = TextButton.styleFrom(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        side: BorderSide(color: MyColors.Dark3)
      ));
  var isSelected=false;
  int? itemId=0;
  var dayTextStyle;
  var weekendTextStyle ;
  var anniversaryTextStyle;
  var config;
  List<DateTime?>? _dialogCalendarPickerValue;
  final today = DateUtils.dateOnly(DateTime.now());
  var startDate="".obs;
  var endDate="".obs;
  var isVisible=false.obs;
  var deliveryDate="";
  final homeController = Get.put(HomeController());




  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);
    controller!.addListener(() {
      setState(() {});
    });
    controller!.forward();
    _dialogCalendarPickerValue = [
      DateTime.now(),
    ];
    ///calender
    dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    weekendTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

    anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: MyColors.MainColor,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.friday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            width:350,
            decoration: ShapeDecoration(
                color: const Color.fromARGB(255, 248, 244, 244),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding:  EdgeInsets.only(bottom: 2.h, top: 1.h,right: 1.h,left: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //SvgPicture.asset(Assets.poweredby),
                  SizedBox(height: 1.h),
                  Text('select_your_date'.tr(),
                      style:  TextStyle(fontSize: 11.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color:MyColors.Dark1)),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(child: GestureDetector(
                          onTap: (){
                            setState(() {
                              isSelected=true;
                              itemId=1;
                              deliveryDate="today";
                              isVisible.value=false;
                            });
                          },
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(color:isSelected==true && itemId==1?MyColors.MainColor2 : MyColors.BorderColor,width: 1),
                            ),
                            child: Center(
                              child: Text('today'.tr(),
                                  style:  TextStyle(fontSize: 10.sp,
                                      fontFamily: 'lexend_bold',
                                      fontWeight: FontWeight.w500,
                                      color:MyColors.Dark1)),
                            ),
                          ),
                        ),),
                      SizedBox(width: 1.h,),
                      Expanded(child: GestureDetector(
                          onTap: (){
                            setState(() {
                              isSelected=true;
                              itemId=2;
                              deliveryDate="tomorrow";
                              isVisible.value=false;
                            });
                          },
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(color:isSelected==true && itemId==2?MyColors.MainColor2 : MyColors.BorderColor,width: 1),

                            ),
                            child: Center(
                              child: Text('tomorrow'.tr(),
                                  style:  TextStyle(fontSize: 10.sp,
                                      fontFamily: 'lexend_bold',
                                      fontWeight: FontWeight.w500,
                                      color:MyColors.Dark1)),
                            ),
                          ),
                        ),),
                      SizedBox(width: 1.h,),
                      Expanded(child: GestureDetector(
                          onTap: ()async{
                            setState(() {
                              isSelected=true;
                              itemId=3;
                              isVisible.value=true;
                            });
                            final values = await showCalendarDatePicker2Dialog(
                              context: context,
                              config: config,
                              dialogSize: const Size(325, 400),
                              borderRadius: BorderRadius.circular(15),
                              value: _dialogCalendarPickerValue!,
                              dialogBackgroundColor: Colors.white,);
                            if (values != null) {
                              // ignore: avoid_print
                              print(_getValueText(config.calendarType, values,));
                              setState(() {
                                _dialogCalendarPickerValue = values;
                                _getValueText(config.calendarType, values,);
                              });
                            }
                          },
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(color:isSelected==true && itemId==3?MyColors.MainColor2 : MyColors.BorderColor,width: 1),

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/calendar.svg'),
                                Text('select_date'.tr(),
                                    style:  TextStyle(fontSize: 10.sp,
                                        fontFamily: 'lexend_bold',
                                        fontWeight: FontWeight.w500,
                                        color:MyColors.Dark1)),
                              ],
                            ),
                          ),
                        ),)
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Obx(() =>
                      Visibility(
                        visible: isVisible.value,
                        child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        //SizedBox(width: 2.h,),
                        Row(
                          children: [
                            Text('from_date'.tr(), style:  TextStyle(fontSize: 14.sp,
                                fontFamily: 'lexend_regular',
                                fontWeight: FontWeight.w500,
                                color: MyColors.Dark1)),
                            Text(": ${startDate.value??""}", style:  TextStyle(fontSize: 11.sp,
                                fontFamily: 'lexend_regular',
                                fontWeight: FontWeight.w500,
                                color: MyColors.Dark1)),
                          ],
                        ),
                        SizedBox(width: 10.h,),
                        Row(
                          children: [
                            Text('to_date'.tr(), style:  TextStyle(fontSize: 14.sp,
                                fontFamily: 'lexend_regular',
                                fontWeight: FontWeight.w500,
                                color: MyColors.Dark1)),
                            Text(": "+(endDate.value??""), style:  TextStyle(fontSize: 11.sp,
                                fontFamily: 'lexend_regular',
                                fontWeight: FontWeight.w500,
                                color: MyColors.Dark1)),
                          ],
                        )
                    ],
                  ),)),
                  SizedBox(height: 1.5.h),
                  Text('recipient_name'.tr(), style:  TextStyle(fontSize: 11.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: MyColors.BorderColor, width: 1.0,),
                        color: Colors.white),
                    child: recipientName(),
                  ),
                  SizedBox(height: 1.h),
                  Text('mobile'.tr(), style:  TextStyle(fontSize: 11.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: MyColors.BorderColor, width: 1.0,),
                        color: Colors.white),
                    child: orderNumber(),
                  ),
                  SizedBox(height: 1.h),
                  Text('bag_number'.tr(), style:  TextStyle(fontSize: 11.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: MyColors.BorderColor, width: 1.0,),
                        color: Colors.white),
                    child: bagNumber(),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 7.h,
                          child: TextButton(
                            style: flatButtonStyle,
                            onPressed: () async{
                              homeController.getOrders(
                                  context,
                                  homeController.orderStatus,
                                  RecipientName.text,
                                  OrderNumber.text,
                                  BagNumber.text,
                                  deliveryDate,
                                  startDate.value, endDate.value);
                              Navigator.pop(context);
                            },
                            child: Text('apply'.tr(),
                              style:  TextStyle(fontSize: 12.sp,
                                  fontFamily: 'lexend_bold',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),),
                          ),
                        ),
                      ),
                      SizedBox(width: 1.h,),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 7.h,
                          child: TextButton(
                            style: flatButtonStyle2,
                            onPressed: () async{
                              RecipientName.clear();
                              OrderNumber.clear();
                              BagNumber.clear();
                              startDate.value="";
                              endDate.value="";
                            },
                            child: Text('resets_all'.tr(),
                              style:  TextStyle(fontSize: 12.sp,
                                  fontFamily: 'lexend_bold',
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.Dark3),),
                          ),
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

  Widget recipientName (){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: RecipientName,
      maxLines: 1,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.white,style: BorderStyle.solid),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(style: BorderStyle.solid,color: Colors.white,)
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
        ) ,
      ),
      style:  TextStyle(fontSize: 12.sp,
          fontFamily: 'lexend_regular',
          fontWeight: FontWeight.w300,
          color: MyColors.Dark3),
      keyboardType: TextInputType.number,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget orderNumber (){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: OrderNumber,
      maxLines: 1,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.white,style: BorderStyle.solid),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(style: BorderStyle.solid,color: Colors.white,)
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
        ) ,
      ),
      style:  TextStyle(fontSize: 12.sp,
          fontFamily: 'lexend_regular',
          fontWeight: FontWeight.w300,
          color: MyColors.Dark3),
      keyboardType: TextInputType.number,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget bagNumber (){
    return TextFormField(
      autovalidateMode:AutovalidateMode.onUserInteraction ,
      controller: BagNumber,
      maxLines: 1,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.white,style: BorderStyle.solid),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(style: BorderStyle.solid,color: Colors.white,)
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.red,style: BorderStyle.solid),
        ) ,
      ),
      style:  TextStyle(fontSize: 12.sp,
          fontFamily: 'lexend_regular',
          fontWeight: FontWeight.w300,
          color: MyColors.Dark3),
      keyboardType: TextInputType.number,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
         startDate.value = values[0].toString().replaceAll('00:00:00.000', '');
         endDate.value = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : startDate.value;
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }


}