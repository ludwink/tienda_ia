import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productState = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Detalles")),
      body: FutureBuilder<Product?>(
        future: productState.getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('Producto no encontrado'));
          } else {
            return _ProductView(product: snapshot.data!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductView extends StatelessWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: product.images),
        ),
        const SizedBox(height: 10),
        Center(child: Text(product.title, style: textStyles.headlineMedium)),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

// PRODUCT INFORMATION ===================================================
class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Q ${product.price}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Stock: ${product.stock}',
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 15),

          _SizeSelector(selectedSizes: product.sizes),
          const SizedBox(height: 5),

          _GenderSelector(selectedGender: product.gender),
          const SizedBox(height: 15),

          // description
          TextField(
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Descripción'),
            controller: TextEditingController(
              text: product.description,
            ),
            maxLines: 5,
            keyboardType: TextInputType.multiline,
          ),

          // tags
          TextField(
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Tags'),
            controller: TextEditingController(text: product.tags.join(', ')),
            maxLines: 2,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}

// SIZE SELECTOR ===================================================
class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['S', 'M', 'L'];

  const _SizeSelector({required this.selectedSizes});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        emptySelectionAllowed: true,
        showSelectedIcon: false,
        selected: Set.from(selectedSizes),
        onSelectionChanged: (newSelection) {},
        multiSelectionEnabled: true,
        segments: sizes.map((size) {
          return ButtonSegment(value: size, label: Text(size));
        }).toList(),
      ),
    );
  }
}

// GENDER SELECTOR ===================================================
class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['Hombre', 'Mujer', 'Unisex'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.people,
  ];

  const _GenderSelector({required this.selectedGender});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        emptySelectionAllowed: false,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
            icon: Icon(genderIcons[genders.indexOf(size)]),
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {},
      ),
    );
  }
}

// IMAGE GALLERY ===================================================
class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Icon(Icons.image, size: 100, color: Colors.grey))
            ]
          : images.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  'assets/img/$e',
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
    );
  }
}
