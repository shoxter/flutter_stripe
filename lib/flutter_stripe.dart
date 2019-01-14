import 'dart:async';

import 'package:flutter/services.dart';

class FlutterStripe {
  static const MethodChannel _channel =
      const MethodChannel('flutter_stripe');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getToken({String cardNumber, int expiryMonth, int expiryYear, String cvc, String publishableKey}) async {
		final String token = await _channel.invokeMethod("getToken", {
			"publishableKey": publishableKey,
			"cardNumber": cardNumber,
			"expiryMonth": expiryMonth,
			"expiryYear": expiryYear,
			"cvc": cvc
		});
		return token;
	}
}
