import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';


/// Authors (avour, ...)
// Set of tools for purscliq

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';

import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';


import 'package:local_auth/local_auth.dart';

//import 'package:purscliq_business/utils/tools.dart' as tools;

import 'package:path_provider/path_provider.dart' as path_provider;

const String APP_ICON = 'assets/images/ic_launcher.png';

const String APP_VERSION = '1.0.0';
const String OneSignalId = '2452c96a-106c-461f-80a3-2b4f0abd6d83';

bool isStoreInitialized = false;

const String GOOGLE_API_KEY = 'AIzaSyBlKVRsgWSGoPYB5sD_0XbOCLvVPY4u4bw';

Future<void> initializeStore() async {
  if (isStoreInitialized) {
    return;
  }

  if (!kIsWeb) {
    final dir = await path_provider.getApplicationSupportDirectory();
    final hiveFolder = join(dir.path); // , '.storage'
    Hive.init(hiveFolder);
  }
  isStoreInitialized = true;
}

/// Put an object in the store
Future<void> putInStore(String key, value, {String store = 'store'}) async {
  await initializeStore();
  var box = await Hive.openBox(store);
  return await box.put(key, value);
}

/// Function to put an object in the store
Future<dynamic> getFromStore(String key, {String store = 'store'}) async {
  await initializeStore();
  Box box = await Hive.openBox(store);
  return await box.get(key);
}

/// Function to put an object in the store
Future<void> removeFromStore(String key, {String store = 'store'}) async {
  await initializeStore();
  Box box = await Hive.openBox(store);
  await box.delete(key);
}

Future<void> clearStore({store = 'store'}) async {
  await initializeStore();
  Box box = await Hive.openBox(store);
  await box.clear();
}

class Validators {
// Regex func for validating a name
  static String? validateName(String value) {
    if (value.isEmpty) return 'This is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp emailExp =
        RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
    if (!emailExp.hasMatch(value.trim())) return 'Please enter a valid email';
    return null;
  }

  static String? checkFilledForm(Map<String, dynamic> value) {
    bool filled =
        (value.values.every((element) => element != null && element != ''));
    List<String> defaulters = [];
    if (!filled) {
      for (var element in value.entries) {
        if (element.value == null || element.value == '') {
          defaulters.add(element.key);
        }
      }
      // ignore: avoid_print
      print('Form Error in: $defaulters');
      return 'Please ensure the following fields are filled:\n$defaulters';
    }
    return null;
  }

  static String? validateUsername(String value) {
    if (value.isEmpty) return 'Username is required.';
    final RegExp emailExp = RegExp(r'^[\w.@+\- ]+$');
    if (!emailExp.hasMatch(value)) return 'invalid username';
    return null;
  }

  static String? isNotNull(String value) {
    return (value == null) ? 'This field is required' : null;
  }

  static String? isNotEmpty(String? value) {
    return value!.isEmpty ? 'This field is required' : null;
  }

  static String? isNotEmpty2(String value) {
    return value.isEmpty ? '' : null;
  }

  static String? isInt(String value) {
    return (int.tryParse(value) == null) ? 'Invalid Input' : null;
  }

  static String? isDouble(String value) {
    return (double.tryParse(value) == null) ? 'Invalid Input' : null;
  }

  static String? validateMobile(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}

// void showToast(String msg, {Duration duration = const Duration(seconds: 2)}) {
//   BotToast.showText(text: msg, duration: duration);
// }

// void showOverlay(String msg, {Duration duration = const Duration(seconds: 2)}) {
//   BotToast.showLoading();
// }

bool isUrl(String path) {
  if (path.startsWith('http') && path.contains('://')) {
    return true;
  } else {
    return false;
  }
}

bool dateCheck(DateTime otherDate) {
  DateTime today = DateTime.now();
  // ignore: avoid_print
  print(otherDate);

// Create a DateTime object for the date you want to compare

// Compare the two dates
  if (otherDate.isBefore(today)) {
    // ignore: avoid_print
    print('true');
    return false;
  } else if (otherDate.isAfter(today)) {
    return true;
  } else {
    return false;
  }
}

String? fixMessedUpPhoneNumber(String phoneNo, {countryCode = '+234'}) {
  phoneNo = phoneNo.replaceAll(RegExp(' '), '');
  if (phoneNo.startsWith('+')) {
    return phoneNo;
  }
  if (phoneNo.length == 11 || phoneNo.startsWith('0')) {
    phoneNo = phoneNo.substring(1);
  }
  return countryCode + phoneNo;
}

//var priceFormatter = NumberFormat('#,##0', 'en_US');
// String formatPrice(price) {
//   return priceFormatter.format(price);
// }

// var currencyFormat = NumberFormat.currency(symbol: '\u20A6', locale: 'en_NG');
// String formatPriceDetailed(price) {
//   return currencyFormat.format(price);
// }

// String parseTime(DateTime obj) {
//   return DateFormat.jm().format(obj);
// }

// String parseDate(DateTime obj) {
//   if (obj == null) return '';
//   return DateFormat.yMMMd().format(obj);
// }

// String parseFormDateTime(DateTime obj) {
//   if (obj == null) return '';
//   return DateFormat('yyyy-MM-dd').format(obj);
// }

// String parseAnalyticsDate(DateTime obj) {
//   return DateFormat('MM/dd/yyyy').format(obj);
// }

// String parseDateRange(DateTimeRange range) {
//   return '${DateFormat('MMMd').format(range.start)} - ${DateFormat('MMMd').format(range.end)}';
// }

Future showResponseDialog(BuildContext context, String info,
    {type = 'success', actionText = 'OK', VoidCallback? onComplete}) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          height: 435,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Column(
                    children: [
                      Icon(
                        (type == 'success')
                            ? Icons.check_circle
                            : Icons.cancel_rounded,
                        color: (type == 'success')
                            ? Colors.green
                            : const Color(0xFFEE3333),
                        size: 120,
                      ),
                      Text((type == 'success') ? 'Done!' : 'Error!',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontFamily: 'GilroyMedium',
                                  color: const Color.fromRGBO(0, 0, 0, 0.8))),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(info,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontFamily: 'GilroyMedium',
                                      color: Colors.black.withAlpha(200)))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

// Future<DateTime?> _selectDates(BuildContext context) async {
//   DateTime selectedDate = DateTime.now();
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: selectedDate,
//     firstDate: DateTime(1900),
//     lastDate: DateTime(2100),
//   );

//   if (picked != null && picked != selectedDate) {
//     selectedDate = picked;

//   }

//   return selectedDate;
// }

Future<DateTime?> selectDate(BuildContext context,
    {DateTime? selectedDate, DateTime? startDate, DateTime? endDate}) async {
  DateTime selectedDate = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  if (picked != null && picked != selectedDate) {
    selectedDate = picked;
  }

  return selectedDate;
}

Future<DateTime?> selectTime(BuildContext context,
    {DateTime? selectedDate, DateTime? startDate, DateTime? endDate}) async {
  DateTime start =
      startDate ?? DateTime.now().subtract(const Duration(days: 365 * 100));
  DateTime initial = selectedDate ?? DateTime.now();
  DateTime end = endDate ?? DateTime.now().add(const Duration(days: 365 * 100));

  // ignore: avoid_print
  print('Initial is: $initial');
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: start,
    lastDate: end,
  );
}

Future<T?> showScaffoldBottomSheet<T>(
    {required BuildContext context,
    String? title,
    Widget? body,
    bool? headless,
    List<Widget>? actions,
    double height = 0.7}) {
  return showBaseBottomSheet<T>(
      context: context,
      height: height,
      body: Scaffold(
          backgroundColor: Colors.white,
          appBar: (headless == true)
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.grey,
                    splashRadius: 20,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  actions: actions,
                ),
          body: Container(
              padding: const EdgeInsets.symmetric(vertical: 10), child: body)));
}

Future<T?> showBaseBottomSheet<T>(
    {required BuildContext context, Widget? body, double height = 0.7}) {
  return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      builder: (context2) {
        return Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: MediaQuery.of(context).size.height * height,
            child: body);
      });
}

Future<T?> showWrappedContentBottomSheet<T>(
    {required BuildContext context, required Widget body}) {
  return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (context2) {
        return Wrap(children: <Widget>[
          AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 25,
            backgroundColor: Colors.white,
            title: Center(
              child: Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xffD4D7DD)),
              ),
            ),
          ),
          body
        ]);
      });
}
//get current loaction of user

Future<Position?> getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are disabled
    return null;
  }

  // Request location permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();

      // Location permission not granted
      return null;
    }
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition();
  // ignore: avoid_print
  print(position);
  return position;
}

//authenticate user using biometerics

final LocalAuthentication _localAuth = LocalAuthentication();

Future<bool> _isBiometricAvailable() async {
  bool isAvailable = false;
  try {
    isAvailable = await _localAuth.canCheckBiometrics;
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
  return isAvailable;
}

Future<bool> _authenticate() async {
  bool isAuthenticated = false;
  try {
    isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(biometricOnly: true)
        // useErrorDialogs: true,
        // stickyAuth: true,
        );
  } catch (e) {
    print(e);
  }
  return isAuthenticated;
}

Future<void> biometericAttemptLogin(BuildContext context, dynamic body) async {
  bool isBiometricAvailable = await _isBiometricAvailable();
  if (isBiometricAvailable) {
    bool isAuthenticated = await _authenticate();
    if (isAuthenticated) {
      //await tools.getFromStore('fingerPrintLoginValue') != true
      // ? () {}
      // :
      // User successfully authenticated with biometrics, proceed with login
      //   AuthService().login(context, body);
    } else {
      // Authentication failed or user cancelled
      // ...
    }
  } else {
    // Biometric authentication is not available on the device
    // ...
  }
}

String generateRandomString(int length) {
  const String chars = '0123456789';
  Random rnd = Random();
  String result = '';

  for (int i = 0; i < length; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }

  return result;
}

String checkNetworkProvider(String phoneNumber) {
  // Remove any non-numeric characters from the phone number
  String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  String networkProvider;

  // Check the network provider based on the number prefix
  if (cleanedNumber.startsWith('0803') ||
      cleanedNumber.startsWith('0806') ||
      cleanedNumber.startsWith('0813') ||
      cleanedNumber.startsWith('0816') ||
      cleanedNumber.startsWith('0810') ||
      cleanedNumber.startsWith('0814') ||
      cleanedNumber.startsWith('0903')) {
    networkProvider = 'MTN';
  } else if (cleanedNumber.startsWith('0802') ||
      cleanedNumber.startsWith('0902') ||
      cleanedNumber.startsWith('0701') ||
      cleanedNumber.startsWith('0708') ||
      cleanedNumber.startsWith('0812') ||
      cleanedNumber.startsWith('0704') ||
      cleanedNumber.startsWith('0901')) {
    networkProvider = 'Airtel';
  } else if (cleanedNumber.startsWith('0805') ||
      cleanedNumber.startsWith('0807') ||
      cleanedNumber.startsWith('0815') ||
      cleanedNumber.startsWith('0811') ||
      cleanedNumber.startsWith('0705') ||
      cleanedNumber.startsWith('0905')) {
    networkProvider = 'Glo';
  } else {
    networkProvider = '9mobile';
  }
  return networkProvider;
}

//get device id

// Future<String?>? getId() async {
//   //var deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     // import 'dart:io'
//     var iosDeviceInfo = await deviceInfo.iosInfo;
//     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//   } else if (Platform.isAndroid) {
//     var androidDeviceInfo = await deviceInfo.androidInfo;
//     return androidDeviceInfo.id; // unique ID on Android
//   }
//   return null;
// }

String convertPhoneNumber(String phoneNumber) {
  // Remove any non-digit characters from the phone number
  String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Check if the cleaned number starts with "080" and replace it with "+234"
  if (cleanedNumber.startsWith('08') && cleanedNumber.length == 11) {
    return '+234${cleanedNumber.substring(2)}';
  }

  // If the number starts with "+234", don't change it
  if (cleanedNumber.startsWith('+234') && cleanedNumber.length == 13) {
    return cleanedNumber;
  }

  // If the number doesn't match any of the above conditions, return the original number
  return phoneNumber;
}

// void oneSignal(String deviceId) {
//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

//   OneSignal.initialize('4c4ff3d1-c5d5-4880-8a04-9ec46accea3c');
//   OneSignal.Notifications.requestPermission(true);

// // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission

//   OneSignal.login(deviceId);
//   print('login in');
// }

Future<String?> showDatePickerDialog(BuildContext context) async {
  DateTime selectedDate = DateTime.now();

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          //  accentColor: Colors.blue,
          colorScheme: ColorScheme.light(primary: Colors.blue),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked != selectedDate) {
    selectedDate = picked;
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return formattedDate;
  }
  return null;
}

Future<String?> pickImagePath() async {
  final ImagePicker _picker = ImagePicker();

  try {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
    
      return image.path;
    }
  } catch (e) {
    print('Error picking image: $e');
  }

  return null;
}


//delete video from phone storage 

void deleteFile(String filePath) {
  try {
    File file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
      print('File deleted successfully.');
    } else {
      print('File does not exist.');
    }
  } catch (e) {
    print('Error while deleting the file: $e');
  }
}
