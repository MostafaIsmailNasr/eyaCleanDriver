import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../conustant/di.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/model/auth/verifyCodeModel/VerifyCodeResponse.dart';
import '../../data/model/auth/verifyCodeModel/resendModel/ResendCodeResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebService.dart';

class VerifyController extends GetxController {
  Repo repo = Repo(WebService());
  var verifyCodeResponse = VerifyCodeResponse().obs;
  var resendCodeResponse = ResendCodeResponse().obs;
  var isLoading = false.obs;
  Rx<bool> isVisable = false.obs;
  bool isLogin = false;
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  var phone;
  var currentPin="";
  TextEditingController verfiyCodeController = TextEditingController();

  getphone()async{
    phone=sharedPreferencesService.getString("phone_number");
  }

  verify(BuildContext context,String currentPin) async {
    verifyCodeResponse.value = await repo.verifyCode(currentPin);
    if (verifyCodeResponse.value.success == true) {
      isLogin=true;
      sharedPreferencesService.setBool("islogin", isLogin);
      Navigator.pushNamedAndRemoveUntil(context,'/drower_screen',ModalRoute.withName('/drower_screen'),arguments: 0);
        //verfiyCodeController.clear();
      currentPin="";
    } else {
      print(verifyCodeResponse.value.message);
      //verfiyCodeController.clear();
      currentPin="";
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(verifyCodeResponse.value.message.toString()),
        ),
      );
    }
  }

  resendCode(BuildContext context) async {
    resendCodeResponse.value = await repo.resendCode();
    if (resendCodeResponse.value.success == true) {
      Fluttertoast.showToast(
        msg: resendCodeResponse.value.data!.code!.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      verfiyCodeController.clear();
      isVisable.value = false;
    } else {
      print(verifyCodeResponse.value.message);
      isVisable.value = false;
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(verifyCodeResponse.value.message.toString()),
        ),
      );
    }
  }
}