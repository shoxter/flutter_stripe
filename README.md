# flutter_stripe

A lightweight Flutter tool to tokenize credit card information for stripe

[X] iOS Support <br>
[X] Android Support

## Getting Started

USAGE:

```
FlutterStripe.getToken(
  publishableKey: "YOUR STRIPE PUBLISHABLE KEY",
  cardNumber: "CC #",
  expiryMonth: "CC Expiry Month",
  expiryYear: "CC Expiry Year",
  cvc: "CC CVC Code"
);
```

Please note that this returns `Future<String>` so you must `await` or wait for the call to resolve before getting the token.


