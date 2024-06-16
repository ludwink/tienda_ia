import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/home_page.dart';
import 'presentation/product_details.dart';
import 'presentation/products_page.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tienda IA',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      initialRoute: "/",
      routes: {
        '/': (context) => const HomePage(),
        "/products": (context) => const ProductsPage(),
        "/details": (context) => const ProductDetailsScreen(),
      },
    );
  }
}
