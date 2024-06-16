// Isar
import 'package:isar/isar.dart';

part 'product.g.dart';

@collection
class Product {
  Id? isarId; // Isar will automatically generate an id for us

  String id;
  String title;
  double price;
  String description;
  int stock;
  List<String> sizes;
  String gender;
  List<String> tags;
  List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
  });
}

// Products example
final Product camisa = Product(
  id: '1',
  title: 'Camisa formal',
  price: 250.0,
  description:
      'Camisa formal para caballero de alta calidad y diseño elegante. Confeccionada con mezcla de algodón y elastano para comodidad y facilidad de movimiento. Corte slim fit, cuello clásico con varillas desmontables y puños franceses. Disponible en varios colores sólidos y patrones sutiles. Detalles de calidad: botones de nácar, costuras reforzadas, tapeta fusionada y ojal bordado a mano. Versatilidad para combinar con trajes, corbatas y accesorios. Instrucciones de cuidado: lavar a máquina en ciclo delicado, planchar a temperatura media, evitar lejía y secadora. Una prenda atemporal para elevar el guardarropa y brindar confianza y estilo.',
  stock: 10,
  sizes: ['S', 'M', 'L', 'XL'],
  gender: 'Hombre',
  tags: ['formal', 'manga larga'],
  images: [
    'camisa1.jpg',
    'camisa2.jpg',
  ],
);

final Product gorra = Product(
  id: '2',
  title: 'Gorra',
  price: 100.0,
  description:
      'Gorra de béisbol con visera curva. Disponible en varios colores. Protección solar y estilo urbano se unen en nuestras gorras de alta calidad. Ya sea que estés buscando un accesorio casual para el día a día o un toque final para tu outfit, nuestras gorras son la elección perfecta. Fabricadas con materiales duraderos y transpirables, como algodón, poliéster o mezclas, para mantenerte fresco y cómodo. Diseño clásico de 6 paneles con cierre ajustable en la parte posterior para un ajuste personalizado. Visera precurvada que brinda protección solar y un look moderno. Disponibles en una amplia gama de colores sólidos y estampados llamativos para que encuentres el estilo que mejor se adapte a ti.',
  stock: 5,
  sizes: ['Única'],
  gender: 'Unisex',
  tags: ['béisbol', 'visera curva'],
  images: [
    'gorra1.jpg',
    'gorra2.jpg',
  ],
);

final Product playera = Product(
  id: '3',
  title: 'Playera básica de colores',
  price: 130.0,
  description:
      'Playera de algodón 100%. Diseñada para un ajuste cómodo. Disponible en varios colores. Comodidad y estilo se combinan a la perfección en nuestras playeras de alta calidad. Estas prendas versátiles son esenciales para cualquier guardarropa, ofreciendo un ajuste excepcional y un look atemporal- Confeccionadas con algodón suave y duradero, o mezclas de algodón y poliéster, para una comodidad duradera. Corte clásico y moderno que se adapta a diferentes tipos de cuerpo y estilos. Cuello redondo o en V, según el modelo, para un look casual y relajado. Disponibles en una amplia variedad de colores sólidos y diseños gráficos únicos para expresar tu estilo personal.',
  stock: 20,
  sizes: ['S', 'M', 'L', 'XL'],
  gender: 'Hombre',
  tags: ['algodón', 'cuello redondo'],
  images: [
    'playera1.jpg',
    'playera2.jpg',
    'playera3.jpg',
    'playera4.jpg',
  ],
);

// final Product pantalon = Product(
//   id: '4',
//   title: 'Pantalón',
//   price: 35.75,
//   description: 'Pantalón de mezclilla clásico.',
//   stock: 15,
//   sizes: ['28', '30', '32', '34'],
//   gender: 'Hombre',
//   tags: ['mezclilla', 'clásico'],
//   images: [
//     'pantalon1.jpg',
//     'pantalon2.jpg',
//   ],
// );
