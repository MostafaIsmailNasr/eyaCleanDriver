import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../business/homeController/HomeController.dart';
import '../../../../../conustant/my_colors.dart';
import '../../../../widget/DropOffItem.dart';
import '../../../../widget/PickUpItem.dart';
import '../../../../widget/UrgentItem.dart';
import 'package:eya_clean_driver_laundry/ui/screens/home/empty.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../widget/DropOffItem.dart';
import '../../../../widget/PickUpItem.dart';
import '../../../../widget/UrgentItem.dart';



class DropOffScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DropOffScreen();
  }
}

class _DropOffScreen extends State<DropOffScreen>{
  final homeController = Get.put(HomeController());
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  var con=true;
  @override
  void initState() {
    homeController.orderStatus="finished";
    check();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      homeController.getOrders(context,"finished","","","","","","");
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
    return con? Obx(() => !homeController.isLoading.value? pendingList(context)
        :const Center(child: CircularProgressIndicator(color: MyColors.MainColor),)):NoIntrnet();
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
                homeController.getOrders(context,"finished","","","","","","");
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

  Widget pendingList(BuildContext context){
    if(homeController.orderList.isNotEmpty){
      return RefreshIndicator(
          color: Colors.white,
          backgroundColor: MyColors.MainColor,
          strokeWidth: 4.0,
          onRefresh: () async {
        print("lpppppp");
        await check();
        con?
        homeController.getOrders(context,"finished","","","","","",""):NoIntrnet();
      },child: ListView.builder(
        //  physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: homeController.orderList.length,
          itemBuilder: (context, position) {
            return DropOffItem(
              orders: homeController.orderList[position],
            );
          }));
    }else{
      return empty();
    }
  }
}
