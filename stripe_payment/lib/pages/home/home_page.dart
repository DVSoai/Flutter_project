import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double amount = 10.0;
  Map<String, dynamic>? _intentPaymentData;

  Future<void> _showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      setState(() => _intentPaymentData = null);
      debugPrint("Payment successful!");
    } on StripeException catch (e) {
      debugPrint("Stripe Error: ${e.error.localizedMessage}");
      _showDialog("Payment Cancelled");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      _showDialog("Payment Failed");
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(
      String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (int.parse(amount) * 100).toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );
      final responseData = jsonDecode(response.body);
      debugPrint("Stripe Response: $responseData");
      return responseData;
    } catch (e) {
      debugPrint("Error creating payment intent: $e");
      return null;
    }
  }

  Future<void> _initializePaymentSheet(String amount, String currency) async {
    try {
      _intentPaymentData = await _createPaymentIntent(amount, currency);
      if (_intentPaymentData == null ||
          !_intentPaymentData!.containsKey('client_secret')) {
        debugPrint("Invalid Payment Intent");
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: _intentPaymentData!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Company Name Example',
        ),
      );
      _showPaymentSheet();
    } catch (e) {
      debugPrint("Error initializing payment sheet: $e");
      _showDialog("Payment Initialization Failed");
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () =>
              _initializePaymentSheet(amount.round().toString(), "USD"),
          child: Text(
            'Pay Now USD ${amount.toString()}',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
