import 'dart:async';
import 'package:chopper/chopper.dart';

class MyRequestInterceptor implements Interceptor {
  MyRequestInterceptor(this.token);

  String token;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    // Log and apply the static token
    print('Using static token: $token');
    final request = applyHeader(chain.request, 'x-api-key', '$token');

    // Proceed with the modified request
    return await chain.proceed(request);
  }
}
