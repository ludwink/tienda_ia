import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import "package:image/image.dart" as img;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  File? filePath;
  String label = '';
  double confidence = 0.0;
  int imageSize = 224;
  String productId = '';

  // Seleccionar imagen de la galería, jpg o png
  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    recognition(image);
  }

  // Tomar foto
  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;
    recognition(image);
  }

  // Reconocimiento de imagen
  void recognition(XFile image) async {
    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    // Leer imagen y redimensionar
    Uint8List imageBytes = await imageMap.readAsBytes();
    img.Image originalImg = img.decodeJpg(imageBytes)!;
    img.Image resizedImg =
        img.copyResize(originalImg, height: imageSize, width: imageSize);

    // Reconocimiento
    var recognitions = await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(resizedImg, imageSize),
      numResults: 5,
      threshold: 0.1,
    );

    // Analizar resultados
    if (recognitions == null) return;

    if (recognitions[0]['confidence'] < 0.60) {
      setState(() {
        label = "No se reconoce el producto";
        confidence = recognitions[0]['confidence'];
        productId = '';
      });
      return;
    }

    setState(() {
      confidence = (recognitions[0]['confidence']);
      label = recognitions[0]['label'].toString();
      productId = extractId(label);
    });

    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/details', arguments: productId);
  }

  String extractId(String label) {
    return label.split(RegExp(r'[- ]'))[1];
  }

  // Convertir imagen y normalizar
  Uint8List imageToByteListFloat32(img.Image image, int imgSize) {
    var convertedBytes = Float32List(1 * imgSize * imgSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < imgSize; i++) {
      for (var j = 0; j < imgSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = img.getRed(pixel).toDouble() / 255.0;
        buffer[pixelIndex++] = img.getGreen(pixel).toDouble() / 255.0;
        buffer[pixelIndex++] = img.getBlue(pixel).toDouble() / 255.0;
      }
    }

    return convertedBytes.buffer.asUint8List();
  }

  Future<void> _tfLteInit() async {
    await Tflite.loadModel(
      model: "assets/mobilenet_v2.tflite",
      labels: "assets/model_classes.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    _tfLteInit();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar producto"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, "/products"),
          ),
        ],
      ),
      body: filePath == null
          ? const Center(child: Text("Ninguna imagen seleccionada"))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                const Spacer(flex: 1),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: productId);
                  },
                  child: Card(
                    elevation: 5,
                    clipBehavior: Clip.hardEdge,
                    color: Colors.blue[50],
                    child: Column(
                      children: [
                        // Mostrar imagen
                        Image.file(
                          filePath!,
                          fit: BoxFit.contain,
                          height: 350,
                          width: 350,
                        ),
                        const SizedBox(height: 12),

                        // Etiqueta
                        Text(
                          label.split("-").last,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Exactitud
                        Text(
                          "Exactitud: ${(confidence * 100.0).toStringAsFixed(2)}%",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 3)
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => pickImageCamera(),
            child: const Icon(Icons.camera_alt_outlined),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => pickImageGallery(),
            child: const Icon(Icons.image_outlined),
          ),
        ],
      ),
    );
  }
}
