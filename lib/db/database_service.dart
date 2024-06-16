import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/product.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = openIsar();
  }

  // Insertar registros
  Future<void> insertProducts() async {
    final isar = await db;

    // Verifica si ya existen productos en la base de datos
    final existingProducts = await isar.products.count();
    if (existingProducts > 0) return;

    await isar.writeTxn(() async {
      await isar.products.putAll([playera, camisa, gorra]);
    });
  }

  // Obtener registros
  Future<List<Product>> getProducts() async {
    final isar = await db;

    return isar.products.where().findAll();
  }

  // Buscar por ID
  Future<Product?> getProductById(String id) async {
    final isar = await db;

    return isar.products.filter().idEqualTo(id).findFirst();
  }

  Future<Isar> openIsar() async {
    // Instalar path_provider para obtener el directorio de la aplicación
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([ProductSchema], directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }
}
