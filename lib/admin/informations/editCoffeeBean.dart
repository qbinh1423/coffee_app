import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/themeProvider.dart';
import '../components/adminDrawer.dart';

class EditCoffeeBean extends StatefulWidget {
  final String beanName;
  final String imageUrl;
  final String? altitude;
  final String? climate;
  final String? caffeine;
  final String? description;

  const EditCoffeeBean({
    super.key,
    required this.beanName,
    required this.imageUrl,
    this.altitude,
    this.climate,
    this.caffeine,
    this.description,
  });

  @override
  State<EditCoffeeBean> createState() => _EditCoffeeBeanState();
}

class _EditCoffeeBeanState extends State<EditCoffeeBean> {
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  late TextEditingController _altitudeController;
  late TextEditingController _climateController;
  late TextEditingController _caffeineController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.beanName);
    _imageUrlController = TextEditingController(text: widget.imageUrl);
    _altitudeController = TextEditingController(text: widget.altitude ?? '');
    _climateController = TextEditingController(text: widget.climate ?? '');
    _caffeineController = TextEditingController(text: widget.caffeine ?? '');
    _descriptionController =
        TextEditingController(text: widget.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _altitudeController.dispose();
    _climateController.dispose();
    _caffeineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Edit Coffee Bean",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          ThemeButton(
            changeThemeMode: (isBright) {
              themeProvider.toggleTheme();
            },
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: const Admindrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if ((value == null || value.isEmpty)) {
                    return 'Please enter a coffee bean name';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter name",
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Altitude',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _altitudeController,
                validator: (value) {
                  if ((value == null || value.isEmpty)) {
                    return 'Please enter altitude';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter altitude",
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Climate',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _climateController,
                validator: (value) {
                  if ((value == null || value.isEmpty)) {
                    return 'Please enter climate';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter climate",
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Caffeine',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _caffeineController,
                validator: (value) {
                  if ((value == null || value.isEmpty)) {
                    return 'Please enter caffeine';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter caffeine",
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if ((value == null || value.isEmpty)) {
                    return 'Please enter description';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter description",
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _imageUrlController.text.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported,
                                    size: 50);
                              },
                            ),
                          )
                        : const Icon(Icons.image, size: 50),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return 'Please enter image URL';
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter image URL",
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF416FDF)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
