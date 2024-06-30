
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/toast_class.dart';
import '../../data/model/deliveryCodeModel/DeliveryCodeResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebService.dart';
import '../../ui/screens/home/drower_screen.dart';
import '../homeController/HomeController.dart';

class DeliveryCodeController extends GetxController {
  Repo repo = Repo(WebService());
  var isLoading = false.obs;
  Rx<bool> isVisable = false.obs;
  var deliveryCodeResponse = DeliveryCodeResponse().obs;
  final homeController = Get.put(HomeController());
  TextEditingController codeController = TextEditingController();

  checkDeliveryCode(BuildContext context,int orderId,) async {
    isLoading.value=true;
    deliveryCodeResponse.value = await repo.checkDeliverCode(orderId,codeController.text);
    if (deliveryCodeResponse.value.data?.success == "true") {
      isLoading.value=false;
      isVisable.value = false;
      Navigator.pop(context);
      ToastClass.showCustomToast(context, deliveryCodeResponse.value.data!.status!, "sucess");
      codeController.clear();
      homeController.updateOrderStatusDelivered(orderId,"delivered",context);

    } else {
      isVisable.value = false;
      Navigator.pop(context);
      codeController.clear();
      ToastClass.showCustomToast(context, deliveryCodeResponse.value.data!.status!, "error");
    }
  }

  checkDeliveryCode2(BuildContext context,int orderId,) async {
    isLoading.value=true;
    deliveryCodeResponse.value = await repo.checkDeliverCode(orderId,codeController.text);
    if (deliveryCodeResponse.value.data?.success == "true") {
      isLoading.value=false;
      isVisable.value = false;
      Navigator.pop(context);
      Navigator.pop(context);
      ToastClass.showCustomToast(context, deliveryCodeResponse.value.data!.status!, "sucess");
      codeController.clear();
      homeController.updateOrderStatusDelivered(orderId,"delivered",context);

    } else {
      isVisable.value = false;
      Navigator.pop(context);
      codeController.clear();
      ToastClass.showCustomToast(context, deliveryCodeResponse.value.data!.status!, "error");
    }
  }

  checkDeliveryCodeMap(BuildContext context,int orderId,) async {
    isLoading.value=true;
    deliveryCodeResponse.value = await repo.checkDeliverCode(orderId,codeController.text);
    if (deliveryCodeResponse.value.data?.success == "true") {
      isLoading.value=false;
      isVisable.value = false;
      ToastClass.showCustomToast(context, deliveryCodeResponse.value.data!.status!, "sucess");
      codeController.clear();
      homeController.updateOrderStatusDelivered(orderId,"delivered",context);
      Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DrowerScreen(index: 1,)));

    } else {
      isVisable.value = false;
      Navigator.pop(context);
      codeController.clear();
      ToastClass.showCustomToast(context, deliveryCodeResponse.value.data!.status!, "error");
    }
  }


}