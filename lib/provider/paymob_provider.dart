import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/billing_data.dart';
import '../models/payment_model.dart';
import '../views/payment/iframe_view.dart';

class PaymobProvider extends GetConnect {
  // Necessary properties for managing Paymob instance
  /// from dashboard Select Settings -> Account Info -> API Key
  late String _authKey;
  late String _authToken;
  late String _paymentKey;
  late String _iFrameURL;
  late String _walletURL;
  late int _iFrameID;

  /// from dashboard Select Developers -> Payment Integrations -> Online Card ID

  late int _integrationId;

  /// from dashboard Select Developers -> Payment Integrations -> Online wallet

  late int _walletIntegrationId;

  /// from paymob Select Developers -> iframes

  late int _orderId;

  /// userTokenExpiration the expiration time for user token in seconds (3600 by default and max )

  late int _userTokenExpiration;
  bool _isInitialized = false;
  static PaymobProvider instance = PaymobProvider(); // Singleton instance
  PayMob constants = PayMob.production();

  // Initialize Paymob instance.
  // apiKey: API key for authentication
  // integrationID: Integration ID for card payments
  // walletIntegrationId: Integration ID for wallet payments
  // iFrameID: ID for iFrame
  // userTokenExpiration: Expiration time for user token
  Future<bool> initialize({
    /// from dashboard Select Settings -> Account Info -> API Key
    required String apiKey,

    /// from dashboard Select Developers -> Payment Integrations -> Online Card ID
    int? integrationID,

    /// from dashboard Select Developers -> Payment Integrations -> Online wallet
    int? walletIntegrationId,

    /// from paymob Select Developers -> iframes
    required int iFrameID,

    /// userTokenExpiration the expiration time for user token in seconds (3600 by default and max )
    int userTokenExpiration = 3600,
  }) async {
    if (_isInitialized) {
      return true;
    }
    // Initialize properties
    _authKey = apiKey;
    _integrationId = integrationID!;
    _walletIntegrationId = walletIntegrationId!;
    _iFrameID = iFrameID;
    _iFrameURL =
        'https://accept.paymobsolutions.com/api/acceptance/iframes/$_iFrameID?payment_token=';
    _isInitialized = true;
    _userTokenExpiration = userTokenExpiration;
    return _isInitialized;
  }

  var headers = {'Content-Type': 'application/json'};

  // Get API Key from the server.
  Future<String> _getApiKey() async {
    // Prepare request body
    Map<String, dynamic> requestBody = {"api_key": _authKey};
    final requestBodyJson = requestBody;
    // Send POST request to get API key
    Response response = await post(
      constants.authorization,
      requestBodyJson,
      headers: headers,
    );
    // debugPrint('${response.body}');
    // Process response
    // if(response. == null) {
    //   throw "Error";
    // }
    try {
      // if (response.statusCode! >= 200 && response.statusCode! < 300) {
      _authToken = response.body["token"];
      // debugPrint('$_authToken');
      return _authToken;
      // } else
    } catch (e) {
      {
        throw "Error: $e";
      }
    }
  }

  // Get Order ID from the server.
  Future<int> _getOrderId(double amount, String currency) async {
    // Prepare request body
    Map<String, dynamic> requestBody = {
      "auth_token": _authToken,
      "delivery_needed": "false",
      "amount_cents": "${amount * 100}",
      "currency": currency,
      "items": []
    };
    final requestBodyJson = requestBody;
    // Send POST request to get order ID
    Response response =
        await post(constants.order, requestBodyJson, headers: headers);
    // debugPrint('${response.body}');
    // Process response
    if (response.statusCode! >= 200) {
      _orderId = response.body["id"];
      //  debugPrint('${_orderId}');
      return _orderId;
    } else {
      throw "Error";
    }
  }

  // Request a payment token.
  Future<String> _requestToken({
    required double amount,
    required String currency,
    required String integrationId,
    required BillingData billingData,
  }) async {
    // Prepare request body
    Map<String, dynamic> requestBody = {
      "auth_token": _authToken,
      "expiration": _userTokenExpiration,
      "amount_cents": "${amount * 100}",
      "order_id": _orderId,
      "billing_data": billingData.toJson(),
      "currency": currency,
      "integration_id": integrationId,
      "lock_order_when_paid": "false"
    };
    final requestBodyJson = requestBody;

    // Send POST request to get payment token
    Response response =
        await post(constants.keys, requestBodyJson, headers: headers);

    // Process response
    if (response.statusCode! >= 200) {
      _paymentKey = response.body["token"];
      return _paymentKey;
    } else {
      throw "Error";
    }
  }

  // Request wallet URL for payment.
  Future<String> _requestUrlWallet({
    required String number,
  }) async {
    // Prepare request body
    Map<String, dynamic> requestBody = {
      "source": {"identifier": number, "subtype": "WALLET"},
      "payment_token": _paymentKey // token obtained in step 3
    };
    final requestBodyJson = requestBody;
    // Send POST request to get wallet URL
    Response response =
        await post(constants.wallet, requestBodyJson, headers: headers);
    // Process response
    if (response.statusCode! >= 200) {
      _walletURL = response.body["redirect_url"];
      return _walletURL;
    } else {
      throw "Error";
    }
  }

  // Initiate payment with a card.
  Future payWithCard({
    required BuildContext context,
    required String currency,
    required double amount,
    void Function(PaymentPaymobResponse response)? onPayment,
    BillingData? billingData,
  }) async {
    await _getApiKey();
    await _getOrderId(amount, currency);
    await _requestToken(
        integrationId: _integrationId.toString(),
        amount: amount,
        currency: currency,
        billingData: billingData ?? BillingData());
    if (context.mounted) {
      final response = await PaymobIFrame.show(
        context: context,
        redirectURL: "$_iFrameURL$_paymentKey",
        onPayment: onPayment,
      );
      return response;
    }
    return null;
  }

  // Initiate payment with a wallet.
  Future payWithWallet({
    required BuildContext context,
    required String currency,
    required String number,
    required double amount,
    void Function(PaymentPaymobResponse response)? onPayment,
    BillingData? billingData,
  }) async {
    await _getApiKey();
    await _getOrderId(amount, currency);
    await _requestToken(
        integrationId: _walletIntegrationId.toString(),
        amount: amount,
        currency: currency,
        billingData: billingData ?? BillingData());
    await _requestUrlWallet(number: number);
    if (context.mounted) {
      final response = await PaymobIFrame.show(
        context: context,
        redirectURL: _walletURL,
        onPayment: onPayment,
      );
      return response;
    }
    return null;
  }
}
