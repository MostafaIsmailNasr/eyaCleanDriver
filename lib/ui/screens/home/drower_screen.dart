import 'package:eya_clean_driver_laundry/conustant/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../auth/login/Login_screen.dart';
import '../more/more_screen.dart';
import 'homeScreen/home_screen.dart';
import 'mapScreen/map_screen.dart';

class DrowerScreen extends StatefulWidget{

  int? index;

  DrowerScreen({required this.index});

  @override
  State<StatefulWidget> createState() {
    return _DrowerScreen();
  }
}

class _DrowerScreen extends State<DrowerScreen>{
  int _selectedIndex = 0;
  int? selectedFlage;
  //buttom Navigation click/////
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> NavigationScreen=[
    HomeScreen(),
    MapScreen(),
    MoreScreen()
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex=widget.index??_selectedIndex;
      NavigationScreen[_selectedIndex]=_selectedIndex==1?MapScreen(): HomeScreen();

    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: MyColors.BGColor,
          child: NavigationScreen[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/home_unSelected.svg'),
              label: 'home'.tr(),
              activeIcon: SvgPicture.asset('assets/home.svg')),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/map_point.svg'),
              label: 'map'.tr(),
              activeIcon: SvgPicture.asset('assets/map_point.svg',color: MyColors.MainColor,)),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/more.svg'),
              label: 'more'.tr(),
              activeIcon: SvgPicture.asset('assets/active_more.svg')),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: MyColors.MainColor,
        onTap: _onItemTapped,
      ),
    );
  }

}