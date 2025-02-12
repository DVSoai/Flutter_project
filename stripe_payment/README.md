# stripe_payment

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Stripe Payment Integration in Flutter

This project demonstrates how to integrate Stripe payments into a Flutter application using the flutter_stripe package. It includes initializing a payment sheet, creating a payment intent, and handling payment success and failures.

📌 Prerequisites

Flutter installed on your system

A Stripe account (https://stripe.com)

Flutter environment variables (flutter_dotenv package)

A working API key from Stripe (store it in a .env file)

🛠 Setup

1️⃣ Clone the repository

git clone https://github.com/your-repo/flutter-stripe-payment.git
cd flutter-stripe-payment

2️⃣ Install dependencies

flutter pub get

3️⃣ Setup environment variables

Create a .env file in the root directory and add your Stripe Secret Key:

SECRET_KEY=your_stripe_secret_key

4️⃣ Run the app

flutter run

🚀 Features

Stripe Payment Sheet integration

Secure API call to create payment intents

Error handling with alerts

Optimized and modular code structure

📂 Project Structure

📂 lib/
├── 📄 main.dart (Entry point)
├── 📂 pages/
│ ├── 📄 home_page.dart (Handles payment integration)

📝 Usage

Open the app and click on Pay Now.

The Stripe payment sheet will appear.

Enter payment details and proceed.

Payment success or failure will be displayed.

🔗 Resources

Stripe Docs

Flutter Stripe Plugin
