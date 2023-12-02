import 'package:dio/dio.dart';
import 'package:payment_application_1/constants.dart';

import '../../Network/remote/dio_helper.dart';
import 'basePaymentService.dart';

class PaymentService implements IPaymentService {
  @override
  Future<Response<dynamic>> getAuthResponse() async {
    //response
    return await DioHelper.getData(
      method: authMethod,
      query: {'api_key': apiKey},
    );
  }

  @override
  Future<Response<dynamic>> getOrderResponse(
      {required Map<String, dynamic> query}) async {
    return await DioHelper.getData(method: orderRegMethod, query: query);
  }

  @override
  Future<Response<dynamic>> getPaymentkeyResponse(
      {required Map<String, dynamic> query}) async {
    return await DioHelper.getData(method: paymentKeyReqMethod, query: query);
  }
}
