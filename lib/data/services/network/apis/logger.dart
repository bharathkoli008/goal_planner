import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart'; // Ensure you have this dependency in your pubspec.yaml

class LoggingInterceptor implements Interceptor {
  final Logger _logger = Logger();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    // Log the request details
    final request = chain.request;



    // Proceed with the request
    Response<BodyType> response;
    try {
      response = await chain.proceed(request);
      // Log the response details
      _logger.i('Request Path: ${request.url} \n Query ${request.parameters}  \nRequest Body ${request.body}  \nRequest Status code ${response.statusCode}');
      _logger.v(response.body);
    } catch (error) {
      // Log the error message
      _logger.e('Error: $error');
      rethrow; // Re-throw the error to propagate it
    }

    return response; // Return the response
  }
}
