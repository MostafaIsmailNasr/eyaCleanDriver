import 'package:eya_clean_driver_laundry/conustant/my_colors.dart';
import 'package:eya_clean_driver_laundry/ui/screens/home/homeScreen/pickUpScreen/pickup_screen.dart';
import 'package:eya_clean_driver_laundry/ui/screens/home/homeScreen/urgentScreen/urgent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/homeController/HomeController.dart';

import 'dropOffScreen/dropOffScreen.dart';
import 'filterDialog/filter_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen>{
  TabBar get _tabBar => TabBar(
    indicatorColor: MyColors.MainColor,
    labelColor: MyColors.MainColor,
    indicatorSize:TabBarIndicatorSize.tab,
    unselectedLabelColor: MyColors.Dark5,
    tabs: [
      Tab(text: 'pending'.tr(),icon: SvgPicture.asset('assets/flash.svg',)),
      Tab(text: 'pickup'.tr(),icon: SvgPicture.asset('assets/delivery2.svg')),
      Tab(text: 'dropoff'.tr(),icon: SvgPicture.asset('assets/box2.svg')),
    ],
  );

  final homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: MyColors.BGColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: appCustomBar(),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Material(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
        ),
        body: TabBarView(
            children: [
              UrgentScreen(),
              PickUpScreen(),
              DropOffScreen()
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding:  EdgeInsets.only(bottom: 1.h),
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (_) =>  FilterDialog(),
              );
            },
            backgroundColor: Colors.white,
            clipBehavior: Clip.antiAlias,
            child:   SvgPicture.asset('assets/filter2.svg'),
          ),
        ),
      ),
    );
  }

  Widget appCustomBar(){
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 6.h,
          height: 6.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child:
            Image.network(
              homeController.profileImg??"",
              loadingBuilder: (context, child,
                  loadingProgress) =>
              (loadingProgress == null)
                  ? child
                  : const Center(
                  child: CircularProgressIndicator()),
            ),
          ),
        ),
        SizedBox(width: 2.w,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(homeController.profileName??"",
                style:  TextStyle(fontSize: 14.sp,
                fontFamily: 'lexend_medium',
                fontWeight: FontWeight.w500,
                color:MyColors.Dark1)),
            Row(
              children: [
                Text("# "+homeController.driverId.toString(),
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'lexend_regular',
                        fontWeight: FontWeight.w400,
                        color:MyColors.Dark3)),
                SizedBox(width: 2.w,),
                SvgPicture.asset('assets/cyrcle.svg'),
                SizedBox(width: 2.w,),
                Text(homeController.date??"",
                    style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'lexend_regular',
                        fontWeight: FontWeight.w400,
                        color:MyColors.Dark3)),
              ],
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/notificatio_screen');
            },
            child:  SvgPicture.asset('assets/notifi.svg'))//Image(image: AssetImage('assets/notifi.png'),width: 6.h,height: 6.h,)),
      ],
    );
  }

}