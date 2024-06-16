import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../models/payment_model.dart';
import '../provider/paymob_provider.dart';

class PayController extends GetxController {
  // instances
  final _paymob = PaymobProvider.instance;

  /// [cancelPaymentProcess] -- Cancel And Close the payment Screen
  // void cancelPaymentProcess() {}

  /// [payWithCard] -- Pay using Card
  Future<void> payWithCard({
    required PaymentModel item,
    
  }) async {
    // Initiates a payment with a card using the PaymobProvider instance
    // if (_paymob.isClosed) {
    //   Get.snackbar(
    //     'Error',
    //     'Payment service is not initialized',
    //     backgroundColor: Colors.redAccent,
    //   );
    //   return;
    // }

    await _paymob.payWithCard(
      context: Get.context!,
      currency: item.currencyCode ?? "EGP",
      amount: item.amount ?? 0,
      billingData: item.billingData?.billingData(),
      // Optional callback function invoked when the payment process is completed
      onPayment: (response) {
        // Checks if the payment was successful
        if (response.success == true) {
          // If successful, displays a snackbar with the success message
          Get.snackbar(
            'Success',
            '${response.message}',
            backgroundColor: Colors.tealAccent,
          );
        } else {
          Get.snackbar(
            'Error',
            '${response.message} -- Response Code ${response.responseCode}',
            backgroundColor: Colors.redAccent,
          );
        }
      },
    );
  }

  @override
  void onInit() {
    // Call the paymob service and put in memory

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    // cancelPaymentProcess();
    super.onClose();
  }
}
