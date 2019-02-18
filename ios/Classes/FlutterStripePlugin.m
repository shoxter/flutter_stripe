#import "FlutterStripePlugin.h"
@import Stripe;

@implementation FlutterStripePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_stripe"
            binaryMessenger:[registrar messenger]];
  FlutterStripePlugin* instance = [[FlutterStripePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"getToken" isEqualToString:call.method]) {
      NSString* key = call.arguments[@"publishableKey"];
      STPAPIClient* client = [[STPAPIClient alloc] initWithPublishableKey:key];
      STPCardParams* cardParams = [STPCardParams alloc];
      cardParams.number = call.arguments[@"cardNumber"];
      NSNumber* year = call.arguments[@"expiryYear"];
      NSNumber* month = call.arguments[@"expiryMonth"];
      cardParams.expYear = [year intValue];
      cardParams.expMonth = [month intValue];
      cardParams.cvc = call.arguments[@"cvc"];
      STPCardValidationState state = [STPCardValidator validationStateForCard:cardParams];
      if (STPCardValidationStateInvalid == state) {
          result([FlutterError errorWithCode:@"invalidCardData" message:@"Invalid Card Data" details:nil]);
      } else {
          [client createTokenWithCard:cardParams completion:^(STPToken * _Nullable token, NSError * _Nullable error) {
              if (token == nil) {
                  result([FlutterError errorWithCode:@"tokenizationException" message:@"Exception creating token" details:nil]);
              } else {
                  result(token.tokenId);
              }
          }];
      }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
