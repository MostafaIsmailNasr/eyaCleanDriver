import 'dart:io';
import 'package:eya_clean_driver_laundry/ui/screens/home/drower_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../business/changeLanguageController/ChangeLanguageController.dart';
import '../../../business/homeController/HomeController.dart';
import '../../../business/orderDetailsController/OrderDetailsController.dart';
import '../../../conustant/my_colors.dart';
import 'dart:math' as math;

import '../../widget/OrderDetailsItems.dart';
import '../buttomSheets/bagNumberButtomSheet/bag_number_buttom_sheet.dart';
import '../buttomSheets/deliveryButtomSheet/delivery_buttom_sheet.dart';
import '../home/mapScreen/map_screen.dart';

class OrderDetailsScreen extends StatefulWidget{
  var id;
  var from;
  OrderDetailsScreen({required this.id,required this.from});

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailsScreen();
  }
}

class _OrderDetailsScreen extends State<OrderDetailsScreen>{
  final changeLanguageController = Get.put(ChangeLanguageController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  final orderDetailsController = Get.put(OrderDetailsController());
  final homeController = Get.put(HomeController());
  var txt;
  var con=true;

  @override
  void initState() {
    check();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
    orderDetailsController.getOrdersDetails(context, widget.id);
    });
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
    return con? Obx(() => !orderDetailsController.isLoading.value? Scaffold(
      backgroundColor: MyColors.BGColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              if(widget.from=="map"){
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        DrowerScreen(index: 1,)));
              }else{
                Navigator.pop(context);
              }
            },
            icon: Transform.rotate(
                angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))),
        title: Center(
          child: Text("${'order_no'.tr()} ${widget.id.toString()}",
              style:  TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'lexend_bold',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark1)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsetsDirectional.all(2.h),
          child: Column(
            children: [
              recipientDetails(),
              SizedBox(height: 1.5.h,),
              dropoffDetails(),
              SizedBox(height: 1.5.h,),
              orderDetails(),
              SizedBox(height: 1.5.h,),
              payment()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 10.h,
        margin: EdgeInsetsDirectional.only(start: 2.h,end: 2.h,bottom: 1.h),
        padding: EdgeInsetsDirectional.all(1.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: (){
                var phone=orderDetailsController.orderDetailsResponse.value.data?.order?.userMobile??"";
                _makePhoneCall('tel:$phone');
              },
              child: Container(
                width: 8.h,
                height: 8.h,
                //padding: EdgeInsetsDirectional.all(2.h),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50),),
                    color:MyColors.MainColor),
                child: Center(
                  child: SvgPicture.asset('assets/phone_whit.svg'),
                ),
              ),
            ),
            ///const Spacer(),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 7.h,
                margin:  EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    if(orderDetailsController.orderDetailsResponse.value.data?.order?.status=="accepted"){
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
                              child: BagNumberButtomSheet(id: orderDetailsController.orderDetailsResponse.value.data!.order!.id!,item: "map",)));
                    }
                    else if(orderDetailsController.orderDetailsResponse.value.data?.order?.status=="finished"){
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
                              child: DeliveryButtomSheet(orderId: orderDetailsController.orderDetailsResponse.value.data!.order!.id!,item: "map",)));
                    }
                    else if(orderDetailsController.orderDetailsResponse.value.data?.order?.status=="pending"){
                      if(widget.from=="map"){
                        homeController.updateOrderStatusMap(orderDetailsController.orderDetailsResponse.value.data!.order!.id!,
                            "accepted", context);

                      }else{
                        homeController.updateOrderStatus(orderDetailsController.orderDetailsResponse.value.data!.order!.id!,
                            "accepted", context);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(orderDetailsController.txt??'confirm'.tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'lexend_bold',
                        fontWeight: FontWeight.w700,
                        color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : const Scaffold(body: Center(child: CircularProgressIndicator(color: MyColors.MainColor))))
        :Scaffold(body: NoIntrnet());
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
                orderDetailsController.getOrdersDetails(context, widget.id);
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

  Widget recipientDetails(){
    return Container(
      padding: EdgeInsetsDirectional.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: MyColors.BorderColor, width:1.0,),
      ),
      child: Column(
        children: [
          Row(
            children: [
            Text('recipientDetails'.tr(),
                style:  TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            const Spacer(),
            Container(
              width: 18.w,
              //height: 3.h,
              padding: EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                color: MyColors.MainColor2,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  orderDetailsController.orderDetailsResponse.value.data?.order?.statusLang??"",
                  style:  TextStyle(fontSize: 8.sp,
                      fontFamily: 'lexend_light',
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
              ),
            ),
              SizedBox(width: 1.h,),
              Container(
                width: 18.w,
                //height: 3.h,
                padding: EdgeInsetsDirectional.all(1.h),
                decoration: BoxDecoration(
                  color: MyColors.MainColor2,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    orderDetailsController.orderDetailsResponse.value.data?.order?.typeLang??"",
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'lexend_light',
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              ),
          ],
          ),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/user_details.svg'),
                  SizedBox(width: 1.h,),
                  Text('recipient_name'.tr(),
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark3)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.userName??"",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
            ],
          ),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/phone_details.svg'),
                  SizedBox(width: 1.h,),
                  Text('contact_information'.tr(),
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark3)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.userMobile??"",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
            ],
          ),
          SizedBox(height: 1.5.h,),
          GestureDetector(
            onTap: (){
              openMap();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/map_details.svg'),
                    SizedBox(width: 1.h,),
                    Text('location'.tr(),
                        style:  TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'lexend_medium',
                            fontWeight: FontWeight.w500,
                            color: MyColors.Dark3)),
                  ],
                ),
                SizedBox(height: 1.h,),
                Text(orderDetailsController.orderDetailsResponse.value.data?.order?.addressName??"",
                    style:  TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'lexend_medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.blue)),
              ],
            ),
          ),
          SizedBox(height: 1.5.h,),
        ],
      ),
    );
  }

  Widget dropoffDetails(){
    return Container(
      padding: EdgeInsetsDirectional.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: MyColors.BorderColor, width:1.0,),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('drop_off_details'.tr(),
              style:  TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'lexend_bold',
                  fontWeight: FontWeight.w700,
                  color: Colors.black)),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/delivery_details.svg'),
                  SizedBox(width: 1.h,),
                  Text('pick_up_time'.tr(),
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark3)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.deliveryDate??"",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
            ],
          ),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/delivery_details.svg'),
                  SizedBox(width: 1.h,),
                  Text('drop_off_time'.tr(),
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark3)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.receivedDate??"",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
            ],
          ),
          SizedBox(height: 1.5.h,),
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
              const Spacer(),
              Text((orderDetailsController.orderDetailsResponse.value.data?.order?.bagNumber.toString())
                  =="null"?"":orderDetailsController.orderDetailsResponse.value.data!.order!.bagNumber.toString()!,
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark1)),
            ],
          ),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              SvgPicture.asset('assets/document_details.svg'),
              SizedBox(width: 1.h,),
              Text('notes'.tr(),
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark3)),
            ],
          ),
          SizedBox(height: 1.h,),
          Container(
            height: 10.h,
            padding: EdgeInsetsDirectional.all(1.h),
            decoration: BoxDecoration(
              color: MyColors.Dark5,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(orderDetailsController.orderDetailsResponse.value.data?.order?.notes??"",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_light',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
            ),
          ),
          SizedBox(height: 1.5.h,),
        ],
      ),
    );
  }

  Widget orderDetails(){
    return Container(
      padding: EdgeInsetsDirectional.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: MyColors.BorderColor, width:1.0,),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('orderDetails'.tr(),
              style:  TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'lexend_bold',
                  fontWeight: FontWeight.w700,
                  color: Colors.black)),
          SizedBox(height: 1.5.h,),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: orderDetailsController.orderList.length,
              itemBuilder: (context, position) {
                return OrderDetailsItems(
                   orderItems: orderDetailsController.orderList[position]
                );
              }),
          Row(
            children: [
              Text('total'.tr(),
                  style:  TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'lexend_bold',
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.total.toString()??"",
                  style:  TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'lexend_bold',
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget payment(){
    return Container(
      padding: EdgeInsetsDirectional.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: MyColors.BorderColor, width:1.0,),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('payment_info'.tr(),
              style:  TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'lexend_bold',
                  fontWeight: FontWeight.w700,
                  color: Colors.black)),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/moneys.svg'),
                  SizedBox(width: 1.h,),
                  Text('payment_method'.tr(),
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark3)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.payment??"",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark3)),
            ],
          ),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/moneys.svg'),
                  SizedBox(width: 1.h,),
                  Text('delivery_price'.tr(),
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark3)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.deliveryCost.toString()??"",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark3)),
            ],
          ),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/moneys.svg'),
                  SizedBox(width: 1.h,),
                  Text('discount'.tr(),
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color: MyColors.Dark3)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.discount.toString()??"",
                  style:  TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w500,
                      color: MyColors.Dark3)),
            ],
          ),
          SizedBox(height: 1.5.h,),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/moneys.svg'),
                  SizedBox(width: 1.h,),
                  Text('total_cost'.tr(),
                      style:  TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'lexend_extraBold',
                          fontWeight: FontWeight.w700,
                          color: MyColors.Dark1)),
                ],
              ),
              const Spacer(),
              Text(orderDetailsController.orderDetailsResponse.value.data?.order?.totalAmount.toString()??"",
                  style:  TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'lexend_medium',
                      fontWeight: FontWeight.w700,
                      color: MyColors.Dark1)),
            ],
          ),
          SizedBox(height: 1.5.h,),

        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openMap() async {
    // Replace these coordinates with your desired latitude and longitude
    double latitude = double.parse(orderDetailsController.orderDetailsResponse.value.data!.order!.addressLat!);
    double longitude = double.parse(orderDetailsController.orderDetailsResponse.value.data!.order!.addressLng!);

    String googleMapUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  void btnTxt(){
    if(orderDetailsController.orderDetailsResponse.value.data?.order?.status=="accepted"){
      txt='received'.tr();
    }else if(orderDetailsController.orderDetailsResponse.value.data?.order?.status=="finished"){
      txt='delivered'.tr();
    }else if(orderDetailsController.orderDetailsResponse.value.data?.order?.status=="pending"){
      txt='accept'.tr();
    }
  }
}