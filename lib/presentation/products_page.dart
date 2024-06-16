import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ProductsPageState createState() => ProductsPageState();
}

class ProductsPageState extends ConsumerState<ProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productNotifier = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: productNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productNotifier.products.length,
              itemBuilder: (context, index) {
                final product = productNotifier.products[index];
                return ProductCard(product: product);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(productProvider.notifier).addSampleProducts();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: product.id);
      },
      child: ListTile(
        leading: Image.asset(
          'assets/img/${product.images.first}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product.title),
        subtitle: Text(
          product.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text('Q ${product.price.toStringAsFixed(2)}'),
      ),
    );
  }
}
