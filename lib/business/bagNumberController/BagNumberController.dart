
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/toast_class.dart';
import '../../data/model/updateBagNumberModel/UpdateBagNumberResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebService.dart';
import '../../ui/screens/buttomSheets/confirmButtomSheet/confirm_buttom_sheet.dart';
import '../../ui/screens/home/drower_screen.dart';
import '../homeController/HomeController.dart';

class BagNumberController extends GetxController {
  Repo repo = Repo(WebService());
  var isLoading = false.obs;
  File? image1;
  File? image2;
  File? image3;
  Rx<bool> isVisable = false.obs;
  var updateBagNumberResponse = UpdateBagNumberResponse().obs;
  final homeController = Get.put(HomeController());

  updateBagNumber(BuildContext context,String num,int id) async {
    isLoading.value=true;
    updateBagNumberResponse.value = await repo.updateBagNumber(num,id,image1,image2,image3);
    if (updateBagNumberResponse.value.success == true) {
      isLoading.value=false;
      isVisable.value = false;
      //ToastClass.showCustomToast(context, updateBagNumberResponse.value.data!.status!, "sucess");
      Navigator.pop(context);
      Navigator.pop(context);
      homeController.getOrders(context, "accepted", "", "", "", "", "", "");
      // ignore: use_build_context_synchronously
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
              child: ConfirmButtomSheet()));
      image1=null;
      image2=null;
      image3=null;
    } else {
      isVisable.value = false;
      ToastClass.showCustomToast(context, updateBagNumberResponse.value.message!, "error");
    }
  }

  updateBagNumber2(BuildContext context,String num,int id) async {
    isLoading.value=true;
    updateBagNumberResponse.value = await repo.updateBagNumber(num,id,image1,image2,image3);
    if (updateBagNumberResponse.value.success == true) {
      isLoading.value=false;
      isVisable.value = false;
      //ToastClass.showCustomToast(context, updateBagNumberResponse.value.data!.status!, "sucess");
      Navigator.pop(context);
      homeController.getOrders(context, "accepted", "", "", "", "", "", "");
      // ignore: use_build_context_synchronously
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
              child: ConfirmButtomSheet()));
      image1=null;
      image2=null;
      image3=null;
    } else {
      isVisable.value = false;
      ToastClass.showCustomToast(context, updateBagNumberResponse.value.message!, "error");
    }
  }

  updateBagNumberMap(BuildContext context,String num,int id) async {
    isLoading.value=true;
    updateBagNumberResponse.value = await repo.updateBagNumber(num,id,image1,image2,image3);
    if (updateBagNumberResponse.value.success == true) {
      isLoading.value=false;
      isVisable.value = false;
      Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DrowerScreen(index: 1,)));
      // ignore: use_build_context_synchronously
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
              child: ConfirmButtomSheet()));
      image1=null;
      image2=null;
      image3=null;
    } else {
      isVisable.value = false;
      ToastClass.showCustomToast(context, updateBagNumberResponse.value.message!, "error");
    }
  }

}