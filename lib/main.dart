import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment_gateway_with_paymob_getx/services/paymob_service.dart';
import 'models/payment_model.dart';

import 'controllers/pay_controller.dart';
import 'controllers/main_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(
    () => PaymobService().call(),
    permanent: true,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(
          () => PayController(),
          fenix: true,
          tag: 'pay',
        );
      }),
      debugShowCheckedModeBanner: false,
      title: 'بوابة دفع إلكترونية',
      locale: const Locale('ar', 'YE'),
      fallbackLocale: const Locale('en', 'UK'),
      theme: ThemeData(
        useMaterial3: true,
      ),
      getPages: [
        // main screen
        GetPage(
          name: '/main',
          page: () => const MainView(),
          binding: BindingsBuilder.put(
            () => MainController(),
            permanent: true,
          ),
        ),
        // payment page
        GetPage(
          name: '/pay',
          page: () => const PayView(),
          fullscreenDialog: true,
          transition: Transition.downToUp,
        ),
      ],
      initialRoute: '/main',
    );
  }
}

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بوابة دفع إلكترونية'),
      ),
      body: Column(
        children: [
          const Text('فائمة العناصر'),
          SizedBox(
            height: Get.height / 2.1,
            child: GridView.builder(
              itemCount: 2,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => Card(
                child: Column(
                  children: [
                    Card(
                      child: Text(
                        'العنصر ${index + 1}',
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        // onPressed: controller.pay,
                        onPressed: () {
                          Get.find<PayController>(tag: 'pay').payWithCard(
                            item: PaymentModel(
                              amount: 100,
                              billingData: BaseBillingShippingInfo(
                                country: 'The earth',
                                city: 'Somewhere',
                                email: 'amgadcyber@gmail.com',
                                firstName: 'Amgad',
                                lastName: 'Fahd',
                                postalCode: '00000',
                                phoneNumber: '+967770000000',
                                state: 'HA',
                                street: 'Hacker 101 street',
                              ),
                              cartID: '123',
                              cartDescription: 'Test Cart',
                              merchantCountryCode: 'EG',
                              currencyCode: 'EGP',
                              merchantName: "Amgad's Getaway",
                            ),
                          );
                        },
                        child: const Text('ادفع'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Payment view
class PayView extends StatelessWidget {
  const PayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
