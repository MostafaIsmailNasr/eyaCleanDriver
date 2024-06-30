
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/orderDetailsModel/OrderDetailsResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebService.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class OrderDetailsController extends GetxController {
  Repo repo = Repo(WebService());
  var isLoading = false.obs;
  var orderDetailsResponse = OrderDetailsResponse().obs;
  RxList<dynamic> orderList=[].obs;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  var txt;

  getOrdersDetails(BuildContext context,int id) async {
    isLoading.value=true;
    orderDetailsResponse.value = await repo.getOrderDetails(id);
    if (orderDetailsResponse.value.success == true) {
      isLoading.value=false;
      orderList.value=orderDetailsResponse.value.data!.order?.orderItems??[] ;
      btnTxt();
    } else {
      ToastClass.showCustomToast(context, orderDetailsResponse.value.message!, "error");
    }
  }

  void btnTxt(){
    if(orderDetailsResponse.value.data?.order?.status=="accepted"){
      txt='received'.tr();
    }else if(orderDetailsResponse.value.data?.order?.status=="finished"){
      txt='delivered'.tr();
    }else if(orderDetailsResponse.value.data?.order?.status=="pending"){
      txt='accept'.tr();
    }
  }

}