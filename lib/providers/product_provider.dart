import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database_service.dart';
import '../models/product.dart';

// This class is used to manage the state of the products
class ProductNotifier extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await _dbService.getProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<Product?> getProductById(String id) async {
    return await _dbService.getProductById(id);
  }

  Future<void> addSampleProducts() async {
    await _dbService.insertProducts();
    await fetchProducts();
  }
}

// This provider is used to access the ProductNotifier instance
final productProvider = ChangeNotifierProvider((ref) => ProductNotifier());
