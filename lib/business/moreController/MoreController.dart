
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../conustant/di.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/model/updateTokenModel/UpdateTokenResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebService.dart';

class MoreController extends GetxController {
  Repo repo = Repo(WebService());
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  var name, pic,driverId,phone;
  var updateTokenResponse = UpdateTokenResponse().obs;

  //var name, pic,phone;


  getData()async{
    name=sharedPreferencesService.getString("fullName")??"";
    pic=sharedPreferencesService.getString("picture")??"";
    phone=sharedPreferencesService.getString("phone_number")??"";
    driverId=sharedPreferencesService.getInt("id")??"";
  }

  updateToken(BuildContext context) async {
    updateTokenResponse.value = (await repo.UpdateToken(""))!;
    if(updateTokenResponse.value.success==true){
      sharedPreferencesService.setBool('islogin',false);
      Navigator.pushNamedAndRemoveUntil(context,'/',ModalRoute.withName('/'));
    }
  }

}