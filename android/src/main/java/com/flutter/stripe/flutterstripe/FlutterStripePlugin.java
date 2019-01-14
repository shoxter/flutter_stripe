package com.flutter.stripe.flutterstripe;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.stripe.android.Stripe;
import com.stripe.android.TokenCallback;
import com.stripe.android.model.Card;
import com.stripe.android.model.Token;

import java.util.HashMap;

/** FlutterStripePlugin */
public class FlutterStripePlugin implements MethodCallHandler {
  static Registrar r;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    r = registrar;
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_stripe");
    channel.setMethodCallHandler(new FlutterStripePlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "getToken":
        HashMap<String, Object> arguments = (HashMap<String, Object>) call.arguments;
        Card card = new Card(
            (String) arguments.get("cardNumber"),
            (Integer) arguments.get("expiryMonth"),
            (Integer) arguments.get("expiryYear"),
            (String) arguments.get("cvc")
        );

        if (!card.validateCard()) {
          result.error("invalidCardData", "Invalid Card Data", null);
        } else {
          Stripe stripe = new Stripe(r.activeContext(), (String) arguments.get("publishableKey"));
          stripe.createToken(card, new TokenCallback() {
            @Override
            public void onError(Exception error) {
              result.error("tokenizationException", "Exception creating token", error);
            }

            @Override
            public void onSuccess(Token token) {
              result.success(token.getId());
            }
          });
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
