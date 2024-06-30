
import 'package:eya_clean_driver_laundry/conustant/toast_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/model/listOrderModel/ListOrderResponse.dart';
import '../../data/model/updateStatusModel/UpdateStatusResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebService.dart';
import '../../ui/screens/home/drower_screen.dart';
import '../../ui/screens/home/homeScreen/home_screen.dart';
import '../../ui/screens/orderDetails/order_details_screen.dart';

class HomeController extends GetxController {
  Repo repo = Repo(WebService());
  late double lat=30.0622723;
  late double lng=31.3274007;
  String currentAddress = '';
  var isLoading = false.obs;
  var listOrderResponse = ListOrderResponse().obs;
  var updateStatusResponse = UpdateStatusResponse().obs;
  RxList<dynamic> orderList=[].obs;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  var profileImg;
  var profileName;
  var driverId;
  var date;
  var orderStatus="";
  List<LatLng> orderAddress=[];
  // Set<Marker> markersList = {};
  //RxSet<Marker> markersList = <Marker>{}.obs;

  getData()async{
    profileImg=sharedPreferencesService.getString("picture");
    profileName=sharedPreferencesService.getString("fullName");
    driverId=sharedPreferencesService.getInt("id");
    date=sharedPreferencesService.getString("date");
  }

  getOrders(
      BuildContext context,
      String status,
      String orderId,
      String clientId,
      String bagNumber,
      String deliveryDate,
      String from,
      String to,) async {
    isLoading.value=true;
    listOrderResponse.value = await repo.listOrders(
        status, orderId, clientId, bagNumber, deliveryDate, from, to);
    if (listOrderResponse.value.success == true) {
     isLoading.value=false;
     orderList.value=listOrderResponse.value.data?.orders as List;
    } else {
      ToastClass.showCustomToast(context, listOrderResponse.value.message!, "error");
    }

  }



  updateOrderStatus(int id, String status,BuildContext context)async{
    isLoading.value=true;
    updateStatusResponse.value = await repo.updateOrderStatus(id,status);
    if(updateStatusResponse.value.success==true){
      isLoading.value=false;
      // ignore: use_build_context_synchronously
      getOrders(context,"pending","","","","","","");
      Fluttertoast.showToast(
        msg:updateStatusResponse.value.data!.status!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,backgroundColor: MyColors.MainColor
      );
    }else{
      ToastClass.showCustomToast(context, updateStatusResponse.value.message!, "error");
    }
  }

  updateOrderStatusMap(int id, String status,BuildContext context)async{
    isLoading.value=true;
    updateStatusResponse.value = await repo.updateOrderStatus(id,status);
    if(updateStatusResponse.value.success==true){
      isLoading.value=false;
      // ignore: use_build_context_synchronously
       Fluttertoast.showToast(
          msg:updateStatusResponse.value.data!.status!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,backgroundColor: MyColors.MainColor
      );
      Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DrowerScreen(index: 1,)));
    }else{
      ToastClass.showCustomToast(context, updateStatusResponse.value.message!, "error");
    }
  }

  updateOrderStatusDelivered(int id, String status,BuildContext context)async{
    isLoading.value=true;
    updateStatusResponse.value = await repo.updateOrderStatus(id,status);
    if(updateStatusResponse.value.success==true){
      isLoading.value=false;
      // ignore: use_build_context_synchronously
      getOrders(context,"finished","","","","","","");
    }else{
      ToastClass.showCustomToast(context, updateStatusResponse.value.message!, "error");
    }
  }

}