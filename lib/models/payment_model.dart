import 'billing_data.dart';

class PaymentModel {
  final String? cartID;
  final String? cartDescription;
  final double? amount;

  final BaseBillingShippingInfo? billingData;
  final String? merchantName;

  final String? merchantCountryCode;
  final String? currencyCode;

  const PaymentModel({
    this.cartID,
    this.amount,
    this.cartDescription,
    // required this.quantity,

    this.billingData,
    this.merchantName,
    this.currencyCode,
    this.merchantCountryCode,
  });
}

/// [BaseBillingShippingInfo] is responsible with generating the billing details
class BaseBillingShippingInfo {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? apartment;
  final String? building;
  final String? shippingMethod;
  final String? city;
  final String? state;
  final String? country;
  final String? street;
  final String? floor;
  final String? postalCode;

  BaseBillingShippingInfo({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.apartment,
    this.building,
    this.shippingMethod,
    this.city,
    this.state,
    this.country,
    this.street,
    this.floor,
    this.postalCode,
  });

  /// [billingData] -- Convert to a useable method for Billing data by the [BillingData] Class

  BillingData? billingData() => BillingData(
        apartment: apartment,
        building: building,
        city: city,
        country: country,
        email: email,
        firstName: firstName,
        floor: floor,
        lastName: lastName,
        phoneNumber: phoneNumber,
        postalCode: postalCode,
        shippingMethod: shippingMethod,
        state: state,
        street: street,
      );
}

class PayMob {
  static const String acceptBaseUrl = "https://accept.paymob.com/api";

  final String authorization;
  final String order;
  final String keys;
  final String wallet;

  PayMob({
    required this.authorization,
    required this.order,
    required this.keys,
    required this.wallet,
  });

  factory PayMob.production() {
    return PayMob(
      authorization: "$acceptBaseUrl/auth/tokens",
      order: "$acceptBaseUrl/ecommerce/orders",
      keys: "$acceptBaseUrl/acceptance/payment_keys",
      wallet: "$acceptBaseUrl/acceptance/payments/pay",
    );
  }

  factory PayMob.staging() {
    // Define staging URLs here
    return PayMob(
      authorization: "$acceptBaseUrl/auth/tokens",
      order: "$acceptBaseUrl/ecommerce/orders",
      keys: "$acceptBaseUrl/acceptance/payment_keys",
      wallet: "$acceptBaseUrl/acceptance/payments/pay",
    );
  }

  factory PayMob.custom({
    required String authorization,
    required String order,
    required String keys,
    required String wallet,
  }) {
    return PayMob(
      authorization: authorization,
      order: order,
      keys: keys,
      wallet: wallet,
    );
  }
}

class PaymentPaymobResponse {
  bool success;
  String? transactionID;
  String? responseCode;
  String? message;

  PaymentPaymobResponse({
    required this.success,
    this.transactionID,
    this.responseCode,
    this.message,
  });

  factory PaymentPaymobResponse.fromJson(Map<String, dynamic> json) {
    return PaymentPaymobResponse(
      success: json['success'] == true,
      transactionID: json['id'],
      message: json['message'],
      responseCode: json['txn_response_code'],
    );
  }
}
