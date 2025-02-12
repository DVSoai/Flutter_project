import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings(
      // StripeSettings(
      //   merchantId: dotenv.env['MERCHANT_ID'],
      //   androidPayMode: 'test',
      // ),
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stripe Payment',
      home: HomePage(),
    );
  }
}
