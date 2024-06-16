import 'package:get/get.dart';

import '../config/env.dart';
import '../provider/paymob_provider.dart';

/*

      apiKey ==>  Get it from dashboard Select Settings -> Account Info -> API Key 
      --------------------------------------
      integrationID ==> Get it from dashboard Select Developers -> Payment Integrations -> Online Card ID 
      --------------------------------------
      walletIntegrationId ==> Get it from dashboard Select Developers -> Payment Integrations -> Online wallet
      --------------------------------------
      iFrameID ==> Get it  from paymob Select Developers -> iframes 
      --------------------------------------

*/

class PaymobService extends GetxService {
  /// [_initPaymentGateway]  is used to initialize the payment gateway with your configurations.
  Future<bool> _initPaymentGateway({
    required int iFrameID,
    required int integrationID,
    int? walletIntegrationId,
  }) async {
    final paymob = await PaymobProvider.instance.initialize(
      apiKey: AppEnviroment.apiKey,
      iFrameID: iFrameID,
      integrationID: integrationID,
      walletIntegrationId: walletIntegrationId,
      userTokenExpiration: 3600,
    );

    return paymob;
  }

  /// [_onlineCardsGateway] -- Pass in the requird parameters for the online cards integration
  Future<PaymobService> _onlineCardsGateway() async {
    await _initPaymentGateway(
      iFrameID: 0835723,
      integrationID: 4548540, // 4548540
      walletIntegrationId: 4550816,
    );
    return this;
  }

  /// [call] -- Call To help initilize the Paymob service
  Future<PaymobService> call() async {
    await _onlineCardsGateway();
    return this;
  }
}
