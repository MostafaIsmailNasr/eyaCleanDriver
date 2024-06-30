
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';


import '../../conustant/CompressionUtil.dart';
import '../../conustant/di.dart';
import '../../conustant/shared_preference_serv.dart';
import 'package:dio/dio.dart' as dio1;


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


class WebService {
  late dio1.Dio dio;
  late dio1.BaseOptions options;
  var baseUrl = "https://dashboard.eyalaundry.com/api";
  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();

  WebService() {
    options = dio1.BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(milliseconds: 70 * 1000),
      receiveTimeout: Duration(milliseconds: 70 * 1000),
    );
    dio = dio1.Dio(options);
  }

  Future<LoginResponse> login(String phone)async{
    try {
      var LoginUrl="/login";
      print(LoginUrl);
      var params={
        'mobile': phone,
        'refer_code':""
      };
      print(options.baseUrl+LoginUrl+params.toString());
      dio1.Response response = await dio.post(LoginUrl, data: params);
      // options: dio1.Options(
      //   headers: {
      //     "authorization": "Bearer ${token}",
      //   },
      // )
      print(response);
      if(response.statusCode==200){
        print("klkl"+LoginResponse.fromJson(response.data).toString());
        return LoginResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return LoginResponse();
      }
    }catch(e){
      print(e.toString());
      return LoginResponse();
    }
  }

  Future<UpdateTokenResponse?> UpdateToken(String token)async{
    var params;
    try {
      var HomeUrl="/update_token";
      if(Platform.isIOS){
        params={
          'ios_token': token,
        };
      }else{
        params={
          'android_token': token,
        };
      }
      print(options.baseUrl+HomeUrl+params.toString());
      dio1.Response response = await dio.post(
          HomeUrl,
          data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print("tokenre"+response.toString());
      return UpdateTokenResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return UpdateTokenResponse();
    }
  }

  Future<VerifyCodeResponse> verifyCode(String code)async{
    try {
      var LoginUrl="/verify_mobile";
      print(LoginUrl);
      var params={
        'code': code,
      };
      print(options.baseUrl+LoginUrl+params.toString());
      dio1.Response response = await dio.post(LoginUrl, data: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+VerifyCodeResponse.fromJson(response.data).toString());
        return VerifyCodeResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return VerifyCodeResponse();
      }
    }catch(e){
      print(e.toString());
      return VerifyCodeResponse();
    }
  }


  Future<ResendCodeResponse> resendCode()async{
    try {
      var LoginUrl="/resend_code";
      print(LoginUrl);
      print(options.baseUrl+LoginUrl);
      dio1.Response response = await dio.post(LoginUrl,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("tokenUser"),
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+ResendCodeResponse.fromJson(response.data).toString());
        return ResendCodeResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return ResendCodeResponse();
      }
    }catch(e){
      print(e.toString());
      return ResendCodeResponse();
    }
  }

  Future<ListOrderResponse> listOrders(
      String status,
      String orderId,
      String clientId,
      String bagNumber,
      String deliveryDate,
      String from,
      String to,)async{
    try {
      var LoginUrl="/deliveryOrders/orders";
      print(LoginUrl);
      var params={
        'status': status,
        'order_id':orderId,
        'client_id':clientId,
        'bag_number':bagNumber,
        'delivery_date':deliveryDate,
        'from':from,
        'to':to
      };
      print(options.baseUrl+LoginUrl+params.toString());
      dio1.Response response = await dio.post(LoginUrl, data: params,
      options: dio1.Options(
        headers: {
          "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
          "Locale": sharedPreferencesService.getString("lang"),
        },
      ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+ListOrderResponse.fromJson(response.data).toString());
        return ListOrderResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return ListOrderResponse();
      }
    }catch(e){
      print(e.toString());
      return ListOrderResponse();
    }
  }

  Future<NotificationResponse> getNotificationData()async{
    print("tokkk"+sharedPreferencesService.getString("tokenUser"));
    try {
      var Url="/notifications/list";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return NotificationResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return NotificationResponse();
    }
  }

  Future<AboutAsResponse> aboutUs()async{
    try {
      var Url="/common/page/driver_about_us";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return AboutAsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return AboutAsResponse();
    }
  }

  Future<SocialResponse> getSocialLinks()async{
    try {
      var Url="/common/settings?";
      print(Url);
      var params={
        'keys[]': ["contact_us","social_media_links"],
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.get(Url,queryParameters: params,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return SocialResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return SocialResponse();
    }
  }

  Future<FaqsResponse> faqs(String type)async{
    try {
      var Url="/common/faqs";
      print(Url);
      print(Url);
      var params={
        'type': type,
      };
      print(options.baseUrl+Url+params.toString());
      dio1.Response response = await dio.post(Url,data: params,
          options: dio1.Options(
            headers: {
              // "authorization": "Bearer ${sharedPreferencesService.getString(
              //     "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return FaqsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return FaqsResponse();
    }
  }

  Future<TermsAndConditionsResponse> termsAndCondition()async{
    try {
      var Url="/common/page/driver_terms_and_conditions";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              // "authorization": "Bearer ${sharedPreferencesService.getString(
              //     "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return TermsAndConditionsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return TermsAndConditionsResponse();
    }
  }

  Future<dynamic> updateProfile(File? Img,String name,String email,String mobile)async{
    try {
      var Url="/update_user";
      print(Url);
      var formData =
      dio1.FormData.fromMap({
        'name': name,
        'email': email,
        'mobile':mobile,
      });
      if(Img!=null) {
        // //[4] ADD IMAGE TO UPLOAD
        File compressedImage = await CompressionUtil.compressImage(Img.path);
        var file = await dio1.MultipartFile.fromFile(compressedImage.path,
            filename: basename(compressedImage.path),
            contentType: MediaType("avatar", "title.png"));
        formData.files.add(MapEntry('avatar', file));
      }
      print(options.baseUrl+Url+formData.files.toString());
      print(options.baseUrl+Url+formData.fields.toString());
      dio1.Response response = await dio.post(Url,data: formData,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+CompleteUserInfoResponse.fromJson(response.data).toString());
        return CompleteUserInfoResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return CompleteUserInfoResponse();
      }
    }catch(e){
      print(e.toString());
      return CompleteUserInfoResponse();
    }
  }

  Future<UpdateStatusResponse> updateOrderStatus(int id,String status)async{
    try {
      var LoginUrl="/orders/updateOrderStatus";
      print(LoginUrl);
      var param={
        'order_id': id,
        'status': status
      };
      print(options.baseUrl+LoginUrl+param.toString());
      dio1.Response response = await dio.post(LoginUrl,data: param,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+UpdateStatusResponse.fromJson(response.data).toString());
        return UpdateStatusResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return UpdateStatusResponse();
      }
    }catch(e){
      print(e.toString());
      return UpdateStatusResponse();
    }
  }

  Future<OrderDetailsResponse> getOrderDetails(int id)async{
    try {
      var Url="/orders/show/$id";
      print(Url);
      print(options.baseUrl+Url);
      dio1.Response response = await dio.get(Url,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString(
                  "tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          )
      );
      print(response);
      return OrderDetailsResponse.fromJson(response.data);
    }catch(e){
      print(e.toString());
      return OrderDetailsResponse();
    }
  }

  Future<UpdateBagNumberResponse> updateBagNumber(String number,int id,
      File? Img1,
      File? Img2,
      File? Img3,
      )async{
    try {
      var Url="/orders/updateBag";
      var formData =
      dio1.FormData.fromMap({
        'order_id': id,
        'bag_number': number,
      });

      if(Img1!=null) {
        // //[4] ADD IMAGE TO UPLOAD
        File compressedImage1 = await CompressionUtil.compressImage(Img1.path);
        var file = await dio1.MultipartFile.fromFile(compressedImage1.path,
            filename: basename(compressedImage1.path),
            contentType: MediaType("media", "title.png"));


        formData.files.add(MapEntry('media', file));
      }
      if(Img2!=null){
        File compressedImage2 = await CompressionUtil.compressImage(Img2.path);
        var file = await dio1.MultipartFile.fromFile(compressedImage2.path,
            filename: basename(compressedImage2.path),
            contentType: MediaType("media2", "title.png"));


        formData.files.add(MapEntry('media2', file));
      }
      if(Img3!=null){
        File compressedImage2 = await CompressionUtil.compressImage(Img3.path);
        var file = await dio1.MultipartFile.fromFile(compressedImage2.path,
            filename: basename(compressedImage2.path),
            contentType: MediaType("media3", "title.png"));


        formData.files.add(MapEntry('media3', file));
      }

      print(options.baseUrl+Url+formData.fields.toString());
      print(options.baseUrl+Url+formData.files.toString());
      dio1.Response response = await dio.post(Url,data: formData,
        options: dio1.Options(
          headers: {
            "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
            //"Locale": sharedPreferencesService.getString("lang"),
          },
        )
      );
      if(response.statusCode==200){
        print(UpdateBagNumberResponse.fromJson(response.data));
        return UpdateBagNumberResponse.fromJson(response.data);
      }else{
        print(response.statusMessage);
        return UpdateBagNumberResponse();
      }

    }catch(e){
      print(e.toString());
      return UpdateBagNumberResponse();
    }
  }

  Future<DeliveryCodeResponse> checkDeliverCode(int orderId,String code)async{
    try {
      var LoginUrl="/orders/checkCode";
      print(LoginUrl);
      var param={
        'order_id': orderId,
        'code': code
      };
      print(options.baseUrl+LoginUrl+param.toString());
      dio1.Response response = await dio.post(LoginUrl,data: param,
          options: dio1.Options(
            headers: {
              "authorization": "Bearer ${sharedPreferencesService.getString("tokenUser")}",
              "Locale": sharedPreferencesService.getString("lang"),
            },
          ));
      print(response);
      if(response.statusCode==200){
        print("klkl"+DeliveryCodeResponse.fromJson(response.data).toString());
        return DeliveryCodeResponse.fromJson(response.data);
      }else{
        print("klkl121"+response.statusMessage.toString());
        return DeliveryCodeResponse();
      }
    }catch(e){
      print(e.toString());
      return DeliveryCodeResponse();
    }
  }
}
