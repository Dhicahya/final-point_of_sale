import 'dart:io';
import 'package:finalproject_sanber/logic/inventory_bloc/inventory_bloc.dart';
import 'package:finalproject_sanber/models/product_model.dart';
import 'package:finalproject_sanber/shared/theme.dart';
import 'package:finalproject_sanber/ui/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toastification/toastification.dart'; // Import ToastMessage class

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventory',
          style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: regular),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: blueColor, // Removes the back button
      ),
      body: Container(
        color: whiteColor,
        child: BlocListener<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventoryLoaded) {
              ToastMessage(
                context: context,
                type: ToastificationType.success,
                message: 'Data successfully loaded',
              ).toastCustom();
            } else if (state is InventoryError) {
              ToastMessage(
                context: context,
                type: ToastificationType.error,
                message: state.message,
              ).toastCustom();
            }
          },
          child: BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, state) {
              if (state is InventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is InventoryError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is InventoryLoaded) {
                return ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Card(
                      color: blueColor,
                      margin: const EdgeInsets.all(8.0),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        leading: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(product.name,
                            style: whiteTextStyle.copyWith(fontWeight: bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Stock: ${product.stock}',
                              style: whiteTextStyle,
                            ),
                            Text(
                              'Price: \Rp ${product.price.toStringAsFixed(2)}',
                              style: whiteTextStyle,
                            ), // Display price
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: whiteColor,
                          ),
                          onPressed: () {
                            context
                                .read<InventoryBloc>()
                                .add(DeleteProduct(product.id));
                          },
                        ),
                        onTap: () {
                          _showProductDialog(context, product);
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No products available.'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: () {
          _showAddProductDialog(context);
        },
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final stockController = TextEditingController();
    final priceController = TextEditingController(); // Controller for price
    File? _imageFile;
    final _picker = ImagePicker();
    final _imageUrl = ValueNotifier<String?>(null);

    Future<void> _pickImage() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageUrl.value = pickedFile.path; // Update image preview
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Product',
            style: blackColorStyle,
          ),
          backgroundColor: whiteColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _imageUrl,
                builder: (context, imageUrl, child) {
                  return imageUrl == null
                      ? const Text('No image selected')
                      : Image.file(
                          File(imageUrl),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        );
                },
              ),
              TextButton(
                child: Text(
                  'Pick Image',
                  style: blueColorStyle,
                ),
                onPressed: () async {
                  await _pickImage();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: redColorStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Add',
                style: greenColorStyle,
              ),
              onPressed: () async {
                final name = nameController.text;
                final stock = int.tryParse(stockController.text);
                final price = double.tryParse(priceController.text);

                if (name.isEmpty ||
                    stock == null ||
                    stock <= 0 ||
                    price == null ||
                    price <= 0 ||
                    _imageFile == null) {
                  ToastMessage(
                    context: context,
                    type: ToastificationType.error,
                    message: 'Please fill all fields and select an image',
                  ).toastCustom();
                  return;
                }

                try {
                  // Upload image to Firebase Storage
                  final storageRef = FirebaseStorage.instance.ref();
                  final fileRef = storageRef.child(
                      'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
                  final uploadTask = fileRef.putFile(_imageFile!);
                  final snapshot = await uploadTask.whenComplete(() {});
                  final imageUrl = await snapshot.ref.getDownloadURL();

                  // Add product to Firestore
                  context.read<InventoryBloc>().add(
                        AddProduct(
                          name: name,
                          stock: stock,
                          price: price,
                          imageUrl: imageUrl,
                        ),
                      );

                  ToastMessage(
                    context: context,
                    type: ToastificationType.success,
                    message: 'Product added successfully',
                  ).toastCustom();
                } catch (e) {
                  ToastMessage(
                    context: context,
                    type: ToastificationType.error,
                    message: 'Failed to add product',
                  ).toastCustom();
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showProductDialog(BuildContext context, Product product) async {
    final nameController = TextEditingController(text: product.name);
    final stockController =
        TextEditingController(text: product.stock.toString());
    final priceController =
        TextEditingController(text: product.price.toString());
    File? _imageFile;
    final _picker = ImagePicker();
    final _imageUrl = ValueNotifier<String?>(product.imageUrl);

    Future<void> _pickImage() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageUrl.value = pickedFile.path; // Update image preview
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Product',
            style: blackColorStyle,
          ),
          backgroundColor: whiteColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextButton(
                child: Text(
                  'Pick Image',
                  style: blueColorStyle,
                ),
                onPressed: () async {
                  await _pickImage();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: redColorStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Update',
                style: greenColorStyle,
              ),
              onPressed: () async {
                final name = nameController.text;
                final stock = int.tryParse(stockController.text) ?? 0;
                final price = double.tryParse(priceController.text) ?? 0.0;

                if (name.isEmpty || stock <= 0 || price <= 0.0) {
                  ToastMessage(
                    context: context,
                    type: ToastificationType.error,
                    message: 'Please fill all fields',
                  ).toastCustom();
                  return;
                }

                try {
                  String? imageUrl = product.imageUrl;

                  if (_imageFile != null) {
                    // Upload new image to Firebase Storage
                    final storageRef = FirebaseStorage.instance.ref();
                    final fileRef = storageRef.child(
                        'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
                    final uploadTask = fileRef.putFile(_imageFile!);
                    final snapshot = await uploadTask.whenComplete(() {});
                    imageUrl = await snapshot.ref.getDownloadURL();
                  }

                  // Update product in Firestore
                  context.read<InventoryBloc>().add(
                        UpdateProduct(
                          id: product.id,
                          name: name,
                          stock: stock,
                          price: price,
                          imageUrl: imageUrl,
                        ),
                      );

                  ToastMessage(
                    context: context,
                    type: ToastificationType.success,
                    message: 'Product updated successfully',
                  ).toastCustom();
                } catch (e) {
                  ToastMessage(
                    context: context,
                    type: ToastificationType.error,
                    message: 'Failed to update product',
                  ).toastCustom();
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
