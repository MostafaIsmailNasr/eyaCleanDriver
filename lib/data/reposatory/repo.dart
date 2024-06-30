
import 'dart:io';

import '../model/aboutUsModel/AboutAsResponse.dart';
import '../model/auth/loginModel/LoginResponse.dart';
import '../model/auth/verifyCodeModel/VerifyCodeResponse.dart';
import '../model/auth/verifyCodeModel/resendModel/ResendCodeResponse.dart';
import '../model/completeUserInfoModel/CompleteUserInfoResponse.dart';
import '../model/deliveryCodeModel/DeliveryCodeResponse.dart';
import '../model/faqsModel/FaqsResponse.dart';
import '../model/listOrderModel/ListOrderResponse.dart';
import '../model/notificationModel/NotificationResponse.dart';
import '../model/orderDetailsModel/OrderDetailsResponse.dart';
import '../model/socialModel/SocialResponse.dart';
import '../model/termsAndConditionsModel/TermsAndConditionsResponse.dart';
import '../model/updateBagNumberModel/UpdateBagNumberResponse.dart';
import '../model/updateStatusModel/UpdateStatusResponse.dart';
import '../model/updateTokenModel/UpdateTokenResponse.dart';

import '../web_service/WebService.dart';

class Repo {
  WebService webService;

  Repo(this.webService);

  Future<LoginResponse> login(String phone,)async{
    final login=await webService.login(phone);
    return login;
  }

  Future<UpdateTokenResponse?> UpdateToken(String token)async{
    final tokenFir=await webService.UpdateToken(token);
    return tokenFir;
  }

  Future<VerifyCodeResponse> verifyCode(String code)async{
    final verify=await webService.verifyCode(code);
    return verify;
  }

  Future<ResendCodeResponse> resendCode()async{
    final resend=await webService.resendCode();
    return resend;
  }

  Future<ListOrderResponse> listOrders(
      String status,
      String orderId,
      String clientId,
      String bagNumber,
      String deliveryDate,
      String from,
      String to,)async{
    final listOrder=await webService.listOrders(
        status,
        orderId, clientId, bagNumber, deliveryDate, from, to);
    return listOrder;
  }

  Future<NotificationResponse> getNotificationData()async{
    final notification=await webService.getNotificationData();
    return notification;
  }

  Future<AboutAsResponse> aboutUs()async{
    final about=await webService.aboutUs();
    return about;
  }

  Future<SocialResponse> getSocialLinks()async{
    final social=await webService.getSocialLinks();
    return social;
  }

  Future<FaqsResponse> faqs(String type)async{
    final faqs=await webService.faqs(type);
    return faqs;
  }

  Future<TermsAndConditionsResponse> termsAndCondition()async{
    final terms=await webService.termsAndCondition();
    return terms;
  }

  Future<CompleteUserInfoResponse> updateProfile(File? Img,String name,String email,String mobile)async{
    final update=await webService.updateProfile(Img, name, email, mobile);
    return update;
  }

  Future<UpdateStatusResponse> updateOrderStatus(int id,String status)async{
    final updateStatus=await webService.updateOrderStatus(id,status);
    return updateStatus;
  }

  Future<OrderDetailsResponse> getOrderDetails(int id)async{
    final orderDetails=await webService.getOrderDetails(id);
    return orderDetails;
  }

  Future<UpdateBagNumberResponse> updateBagNumber(String number,int id,
      File? Img1,
      File? Img2,
      File? Img3,
      )async{
    final bagNumber=await webService.updateBagNumber(number,id,Img1,Img2,Img3);
    return bagNumber;
  }

  Future<DeliveryCodeResponse> checkDeliverCode(int orderId,String code)async{
    final deliverCode=await webService.checkDeliverCode(orderId,code);
    return deliverCode;
  }

}