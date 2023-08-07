import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:saur_dealer/model/customer_model.dart';
import 'package:saur_dealer/model/list_model/customer_list_model.dart';
import 'package:saur_dealer/model/list_model/dealer_list_model.dart';

import '../main.dart';
import '../model/list_model/warranty_request_list.dart';
import '../model/user_model.dart';
import '../utils/api.dart';
import '../utils/enum.dart';
import '../utils/preference_key.dart';
import 'snakbar_service.dart';

enum ApiStatus { ideal, loading, success, failed }

class ApiProvider extends ChangeNotifier {
  ApiStatus? status = ApiStatus.ideal;
  late Dio _dio;
  static ApiProvider instance = ApiProvider();
  ApiProvider() {
    _dio = Dio();
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
  }

  Future<bool> createUser(UserModel user) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Map<String, dynamic> requestBody = {
        "dealerName": user.dealerName,
        "password": user.password,
        "mobileNo": user.mobileNo,
        "status": user.status,
        "email": user.email,
        "address": {
          "addressLine1": user.address?.addressLine1,
          "addressLine2": user.address?.addressLine2,
          "city": user.address?.city,
          "state": user.address?.state,
          "country": "India",
          "zipCode": user.address?.zipCode
        },
        "image": user.image,
        "lastLogin": user.lastLogin,
        "businessName": user.businessName,
        "businessAddress": user.businessAddress,
        "gstNumber": user.gstNumber
      };

      log('request : ${json.encode(requestBody)}');
      Response response = await _dio.post(
        Api.users,
        data: json.encode(requestBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        UserModel user = UserModel.fromMap(response.data['data']);
        prefs.setInt(SharedpreferenceKey.userId, user.dealerId ?? 0);
        if (user.status == UserStatus.ACTIVE.name) {
          status = ApiStatus.success;
          notifyListeners();
        } else {
          status = ApiStatus.failed;
          notifyListeners();
        }
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<bool> login(String email, String password) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Map<String, dynamic> map = {'email': email, 'password': password};
      log('Request : ${json.encode(map)}');
      Response response = await _dio.post(
        Api.login,
        data: json.encode(map),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        UserModel user = UserModel.fromMap(response.data['data']);
        prefs.setInt(SharedpreferenceKey.userId, user.dealerId ?? 0);
        if (user.status == UserStatus.ACTIVE.name) {
          status = ApiStatus.success;
          notifyListeners();
          return true;
        } else {
          status = ApiStatus.failed;
          notifyListeners();
          SnackBarService.instance.showSnackBarError(
              'You profile is inactive. Please contact admin or wait for 24 hours.');
          return false;
        }
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<bool> updateUser(Map<String, dynamic> user, int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.put(
        '${Api.users}/$id',
        data: json.encode(user),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        UserModel user = UserModel.fromMap(response.data['data']);
        prefs.setInt(SharedpreferenceKey.userId, user.dealerId ?? 0);
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<UserModel?> getDealerById(int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    UserModel? userModel;
    try {
      Response response = await _dio.get(
        '${Api.users}/$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        userModel = UserModel.fromMap(response.data['data']);
        status = ApiStatus.success;
        notifyListeners();
        return userModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return userModel;
  }

  Future<DealerListModel?> getAllDealer(int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    DealerListModel? list;
    try {
      Response response = await _dio.get(
        '${Api.users}/$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        list = DealerListModel.fromMap(response.data);
        status = ApiStatus.success;
        notifyListeners();
        return list;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return list;
  }

  Future<WarrantyRequestList?> getWarrantyRequestListByCustomerId(
      int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    WarrantyRequestList? list;
    try {
      Response response = await _dio.get(
        Api.requestWarranty,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        list = WarrantyRequestList.fromMap(response.data);
        status = ApiStatus.success;
        notifyListeners();
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return list;
  }


  Future<WarrantyRequestList?> getWarrantyRequestListByDealerId(
      int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    WarrantyRequestList? list;
    try {
      Response response = await _dio.get(
        '${Api.requestWarranty}/dealer/$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        list = WarrantyRequestList.fromMap(response.data);
        status = ApiStatus.success;
        notifyListeners();
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return list;
  }

  Future<bool> createNewWarrantyRequest(Map<String, dynamic> reqBody) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      debugPrint(json.encode(reqBody));
      Response response = await _dio.post(
        Api.requestWarranty,
        data: json.encode(reqBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data['message'] ?? '';
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance.showSnackBarError('Error :$resBody');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<CustomerListModel?> getCustomerByPhone(String phone) async {
    status = ApiStatus.loading;
    notifyListeners();
    CustomerListModel? userModel;
    try {
      Response response = await _dio.get(
        '${Api.customers}/?mobileNo=$phone',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        userModel = CustomerListModel.fromMap(response.data);
        status = ApiStatus.success;
        notifyListeners();
        return userModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();

      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return userModel;
  }

  Future<bool> sendOtp(String phone, String otp) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.get(
        Api.buildOtpUrl(phone, otp),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        SnackBarService.instance.showSnackBarInfo('OTP sent');
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<DealerListModel?> getDealerMobileNumber(String phone) async {
    status = ApiStatus.loading;
    notifyListeners();
    DealerListModel? list;
    try {
      Response response = await _dio.get(
        '${Api.users}/?mobileNo=$phone',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        list = DealerListModel.fromMap(response.data);
        status = ApiStatus.success;
        notifyListeners();
        return list;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return list;
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    CustomerModel? userModel;
    try {
      Response response = await _dio.get(
        '${Api.users}/$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        userModel = CustomerModel.fromMap(response.data['data']);
        status = ApiStatus.success;
        notifyListeners();
        return userModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return userModel;
  }
}
