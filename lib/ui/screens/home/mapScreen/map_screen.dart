import 'dart:math';
import 'dart:typed_data';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sizer/sizer.dart';
import '../../../../business/changeLanguageController/ChangeLanguageController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../conustant/my_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import '../../../../conustant/toast_class.dart';
import '../../../../data/model/listOrderModel/ListOrderResponse.dart';
import '../../orderDetails/order_details_screen.dart';

class MapScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MapScreen();
  }
}

const kGoogleApiKey = 'AIzaSyCCnt7HXFCbMv-KVWNIlpCu8iLGP7RCyCU';
final homeScaffoldKey = GlobalKey<ScaffoldState>();


class _MapScreen extends State<MapScreen>with SingleTickerProviderStateMixin{
  final homeController = Get.put(HomeController());
  late  CameraPosition initialCameraPosition;
  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  var isSelected=true;
  int? itemId=1;
  int? itemId2=0;
  var address;
  final changeLanguageController = Get.put(ChangeLanguageController());
  var lat,lng;
  var selectedFlage=-1;
  BitmapDescriptor? pinLocationIcon;
  var con=true;
  final today = DateUtils.dateOnly(DateTime.now());
  var startDate="".obs;
  var endDate="".obs;
  var isVisible=false.obs;
  var isVisible2=false.obs;
  var deliveryDate="";
  var dayTextStyle;
  var weekendTextStyle ;
  var anniversaryTextStyle;
  var config;
  List<DateTime?>? _dialogCalendarPickerValue;
  AnimationController? controller;
  Animation<double>? scaleAnimation;



  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/checked.png');
  }

  @override
  void initState() {
    check();
    setCustomMapPin();
    lat=homeController.lat;
    lng=homeController.lng;
    initialCameraPosition = CameraPosition(target:LatLng(lat,  lat), zoom: 12.0);

      homeController.getOrders(context,"","","","","","","")
          .then((result) {
        _onMapTapped(homeController.listOrderResponse.value.data!.orders!);
       });

    initialCameraPosition = CameraPosition(target: LatLng(homeController.lat, homeController.lng), zoom: 12.0);
    super.initState();

    ///calender
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);
    controller!.addListener(() {
      setState(() {});
    });
    controller!.forward();
    _dialogCalendarPickerValue = [
           DateTime.now(),
    ];
    dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    weekendTextStyle = TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: MyColors.MainColor,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.friday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> check()async{
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark5,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.Dark5,
        title: GestureDetector(
          onTap: (){
            _handlePressButton();
          },
          child: Container(
            height: 7.h,
            padding: EdgeInsetsDirectional.all(2.h),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                border: Border.all(color: MyColors.Dark3, width: 1.0,),
                color: Colors.white),
            child: Location(),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              setState(() {
                isVisible2.value=true;
              });
            },
            child: Container(
                margin: EdgeInsetsDirectional.only(end: 1.h),
                child: SvgPicture.asset('assets/filter4.svg')),
          )
        ],
      ),
      body:con? Obx(() =>!homeController.isLoading.value?
      Container(
        margin: EdgeInsetsDirectional.only(top: 1.h),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markersList,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
            ),
            orderTypes(),
          ],
        ),
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainColor),))
          :NoIntrnet(),
      bottomNavigationBar: Visibility(
        visible: isVisible2.value,
        child: Container(
          margin: EdgeInsetsDirectional.only(end: 2.h,start: 2.h,bottom: 2.h),
          padding: EdgeInsetsDirectional.only(top: 1.h,end: 1.h,start: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(color: MyColors.Dark5,width: 1),
          ),
          height: 18.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('select_your_date'.tr(),
                      style:  TextStyle(fontSize: 10.sp,
                          fontFamily: 'lexend_medium',
                          fontWeight: FontWeight.w500,
                          color:MyColors.Dark1)),
                  Spacer(),
                  IconButton(onPressed: (){
                    setState(() {
                      isVisible2.value=false;
                      startDate.value="";
                      endDate.value="";
                      itemId2=0;
                      isVisible.value=false;
                    });
                  }, icon: Icon(Icons.clear),)
                ],
              ),
              Row(
                children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isSelected=true;
                        itemId2=1;
                        deliveryDate="today";
                        endDate.value="";
                        startDate.value="";
                        isVisible.value=false;
                        homeController.getOrders(context, "", "", "", "", deliveryDate,
                            startDate.value, endDate.value)
                            .then((result) {
                          _onMapTapped(homeController.listOrderResponse.value.data!.orders!);
                        });
                      });
                    },
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(color:isSelected==true && itemId2==1?MyColors.MainColor2 : MyColors.Dark5,width: 1),
                      ),
                      child: Center(
                        child: Text('today'.tr(),
                            style:  TextStyle(fontSize: 10.sp,
                                fontFamily: 'lexend_bold',
                                fontWeight: FontWeight.w500,
                                color:MyColors.Dark1)),
                      ),
                    ),
                  ),),
                  SizedBox(width: 1.h,),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isSelected=true;
                        itemId2=2;
                        deliveryDate="tomorrow";
                        endDate.value="";
                        startDate.value="";
                        isVisible.value=false;
                        homeController.getOrders(context, "", "", "", "", deliveryDate,
                            startDate.value, endDate.value)
                            .then((result) {
                          _onMapTapped(homeController.listOrderResponse.value.data!.orders!);
                        });
                      });
                    },
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(color:isSelected==true && itemId2==2?MyColors.MainColor2 : MyColors.Dark5,width: 1),

                      ),
                      child: Center(
                        child: Text('tomorrow'.tr(),
                            style:  TextStyle(fontSize: 10.sp,
                                fontFamily: 'lexend_bold',
                                fontWeight: FontWeight.w500,
                                color:MyColors.Dark1)),
                      ),
                    ),
                  ),),
                  SizedBox(width: 1.h,),
                  Expanded(child: GestureDetector(
                    onTap: ()async{
                      setState(() {
                        isSelected=true;
                        itemId2=3;
                        deliveryDate="";
                        isVisible.value=true;
                      });
                      final values = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: config,
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                        value: _dialogCalendarPickerValue!,
                        dialogBackgroundColor: Colors.white,);
                      if (values != null) {
                        // ignore: avoid_print
                        print(_getValueText(config.calendarType, values,));
                        setState(() {
                          _dialogCalendarPickerValue = values;
                          _getValueText(config.calendarType, values,);
                            homeController.getOrders(context, "", "", "", "", deliveryDate,
                                startDate.value, endDate.value)
                                .then((result) {
                              _onMapTapped(homeController.listOrderResponse.value.data!.orders!);
                              print(homeController.listOrderResponse.value.data!.orders!.length);
                            });
                        });
                      }
                    },
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(color:isSelected==true && itemId2==3?MyColors.MainColor2 : MyColors.Dark5,width: 1),

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/calendar.svg'),
                          Text('select_date'.tr(),
                              style:  TextStyle(fontSize: 10.sp,
                                  fontFamily: 'lexend_bold',
                                  fontWeight: FontWeight.w500,
                                  color:MyColors.Dark1)),
                        ],
                      ),
                    ),
                  ),)
                ],
              ),
              SizedBox(height: 1.h),
              Obx(() => Visibility(
                visible:  isVisible.value,
                child: Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(width: 2.h,),
                    Row(
                      children: [
                        Text('from_date'.tr(), style:  TextStyle(fontSize: 14.sp,
                            fontFamily: 'lexend_regular',
                            fontWeight: FontWeight.w500,
                            color: MyColors.Dark1)),
                        Text(": ${startDate.value??""}", style:  TextStyle(fontSize: 11.sp,
                            fontFamily: 'lexend_regular',
                            fontWeight: FontWeight.w500,
                            color: MyColors.Dark1)),
                      ],
                    ),
                    SizedBox(width: 10.h,),
                    Row(
                      children: [
                        Text('to_date'.tr(), style:  TextStyle(fontSize: 14.sp,
                            fontFamily: 'lexend_regular',
                            fontWeight: FontWeight.w500,
                            color: MyColors.Dark1)),
                        Text(": "+(endDate.value??""), style:  TextStyle(fontSize: 11.sp,
                            fontFamily: 'lexend_regular',
                            fontWeight: FontWeight.w500,
                            color: MyColors.Dark1)),
                      ],
                    )
                  ],
                )),
              )),

            ],
          ),
        ),
      ),
    );
  }

  Widget NoIntrnet(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SvgPicture.asset('assets/no_internet.svg'),
          Image.asset('assets/no_internet.png'),
          SizedBox(height: 1.h,),
          Text('there_are_no_internet'.tr(),
            style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,color: MyColors.Dark1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h,),
          Container(
            width: double.infinity,
            height: 6.h,
            margin:  EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () async{
                await check();
                setCustomMapPin();
                lat=homeController.lat;
                lng=homeController.lng;
                initialCameraPosition = CameraPosition(target:LatLng(lat,  lat), zoom: 12.0);

                homeController.getOrders(context,"","","","","","","")
                    .then((result) {
                  _onMapTapped(homeController.listOrderResponse.value.data!.orders!);
                });

                initialCameraPosition = CameraPosition(target: LatLng(homeController.lat, homeController.lng), zoom: 12.0);
              },
              child: Text('internet'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  Widget Location() {
    return Row(
      children: [
        SvgPicture.asset('assets/search.svg',),
        SizedBox(width: 2.w,),
        Text('search_for_your_address'.tr(), style:  TextStyle(fontSize: 11.sp,
            fontFamily: 'lexend_regular',
            fontWeight: FontWeight.w500,
            color: MyColors.Dark3)),
      ],
    );
  }
  
  Widget orderTypes(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/flash4.svg',width: 2.h,height: 2.h,color: Colors.indigo,),
            Text(
              "${'pending'.tr()} ",
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_medium',
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo),
            ),
          ],
        ),
        Row(
          children: [
            SvgPicture.asset('assets/delivery4.svg',width: 2.h,height: 2.h,),
            Text(
              "${'pickup'.tr()} ",
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_medium',
                  fontWeight: FontWeight.w500,
                  color: MyColors.STATUSEGREColor),
            ),
          ],
        ),
        Row(
          children: [
            SvgPicture.asset('assets/box4.svg',width: 2.h,height: 2.h,),
            Text(
              "${'dropoff'.tr()} ",
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_medium',
                  fontWeight: FontWeight.w500,
                  color: MyColors.STATUSEYeColor),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [Component(Component.country, "eg"),]);


    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    print("ddd" + response.errorMessage!.toString());
    ToastClass.showCustomToast(context, response.errorMessage!, 'error');
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    double latitude = detail.result.geometry!.location.lat;
    double longitude = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(
      Marker(
        markerId: const MarkerId("0"),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: detail.result.name),
      ),
    );
    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 14.0),
    );
    //address = await getAddressFromLatLng(latitude.toString(), longitude.toString());
    setState(() {
      lat=latitude.toString();
      lng=longitude.toString();
    });
    //pickUpAddress = address;
    //print("lop1" + address.toString());
  }


  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String number) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paintRect = Paint()..color = _getRandomColor();

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      const Radius.circular(50.0),
    );

    canvas.drawRRect(rect, paintRect);

    final textSpan = TextSpan(
      text: number,
      style: const TextStyle(fontSize: 20.0, color: Colors.white),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2,
          height / 2 - textPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return bytes;
  }

  Color _getRandomColor() {
    final Random random = Random();
    final int r = random.nextInt(256);
    final int g = random.nextInt(256);
    final int b = random.nextInt(256);

    return Color.fromARGB(255, r, g, b);
  }

  Future<dynamic> _onMapTapped(List<Orders> positions) async {
    setState(() {
      markersList.clear();
          markersList.add(
            Marker(
              markerId: const MarkerId('n'),
              position: LatLng(homeController.lat,homeController.lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
      for (int i = 0; i < positions.length; i++) {
        //else{
          if(positions[i].status=="pending"){
            markersList.add(
              Marker(
                onTap: (){
                  Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          OrderDetailsScreen(id: positions[i].id,from:"map")));
                },
                markerId: MarkerId('${positions[i].address!.lat!} :${positions[i].address!.lng!}'),
                position: LatLng(double.parse(positions[i].address!.lat!),double.parse(positions[i].address!.lng!)),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),//BitmapDescriptor.fromBytes(markerIcon),
                infoWindow: InfoWindow(
                  onTap: (){
                    Navigator.pushReplacement(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            OrderDetailsScreen(id: positions[i].id,from:"map")));
                  },
                  title: 'order $i',
                  snippet: 'Lat: ${positions[i].address!.lat!}, Lng: ${positions[i].address!.lng!}',
                ),
              ),
            );
          }
          else if(positions[i].status=="finished"){
            markersList.add(
              Marker(
                onTap: (){
                  Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          OrderDetailsScreen(id: positions[i].id,from:"map")));
                },
                markerId: MarkerId('${positions[i].address!.lat!} :${positions[i].address!.lng!}'),
                position: LatLng(double.parse(positions[i].address!.lat!),double.parse(positions[i].address!.lng!)),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),//BitmapDescriptor.fromBytes(markerIcon),
                infoWindow: InfoWindow(
                  onTap: (){
                    Navigator.pushReplacement(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            OrderDetailsScreen(id: positions[i].id,from:"map")));
                  },
                  title: 'order $i',
                  snippet: 'Lat: ${positions[i].address!.lat!}, Lng: ${positions[i].address!.lng!}',
                ),
              ),
            );
          }
          else if(positions[i].status=="accepted"){
            markersList.add(
              Marker(
                onTap: (){
                  Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          OrderDetailsScreen(id: positions[i].id,from:"map")));
                },
                markerId: MarkerId('${positions[i].address!.lat!} :${positions[i].address!.lng!}'),
                position: LatLng(double.parse(positions[i].address!.lat!),double.parse(positions[i].address!.lng!)),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),//BitmapDescriptor.fromBytes(markerIcon),
                infoWindow: InfoWindow(
                  onTap: (){
                    Navigator.pushReplacement(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            OrderDetailsScreen(id: positions[i].id,from:"map")));
                  },
                  title: 'order $i',
                  snippet: 'Lat: ${positions[i].address!.lat!}, Lng: ${positions[i].address!.lng!}',
                ),
              ),
            );
          }
        //}
      }
    });
  }

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        startDate.value = values[0].toString().replaceAll('00:00:00.000', '');
        endDate.value = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}
