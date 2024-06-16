import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  // vars
  final currencyCode = 'EGP';
  final merchantCountryCode = 'EG';
  final merchantName = 'بوابتي';

  // text editing controllers
  final cartDescription = TextEditingController();

  // Billing Address
  // final country = TextEditingController();
  // final city = TextEditingController();
  // final fullName = TextEditingController();
  // final phoneNumber = TextEditingController();
  // final addressLineOne = TextEditingController();
  // final state = TextEditingController();
  // final zipCode = TextEditingController();


  /// [pay] -- Pay
  // Future<void> pay()async {
  //   await Get.bottomSheet(
  //    const  BillingInfoWidget(),
  //   );
  // }
}

// class BillingInfoWidget extends StatelessWidget {
//   const BillingInfoWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width,
//       height: Get.height / 2,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.grey.shade100
//       ),
//       child: Column(children: [
//         // TextFormField(
//           // decoration: ,
//         // ),
//         // Text(
//         //   '$'
//         // )
//       ],),
//     );
//   }
// }
