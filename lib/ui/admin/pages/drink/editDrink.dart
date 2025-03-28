import 'dart:io';

import 'package:coffee_app/models/drink.dart';
import 'package:coffee_app/models/tool.dart';
import 'package:coffee_app/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';


class EditDrink extends StatefulWidget {
  static const routeName = '/edit_drink';

  EditDrink(
    Drink? drink, {
    super.key,
    required String id,
  }) {
    if (drink == null) {
      this.drink = Drink(
        id: null,
        name: '',
        caffeine: '',
        description: '',
        origin: '',
        imageUrl: '',
        ingredients: '',
        toolId: [],
      );
    } else {
      this.drink = drink;
    }
  }

  late final Drink drink;

  @override
  State<EditDrink> createState() => _EditDrinkState();
}

class _EditDrinkState extends State<EditDrink> {
  final _editForm = GlobalKey<FormState>();
  late Drink _editedDrink;

  late List<Tool> _tools = [];
  late List<String> selectedToolId;

  @override
  void initState() {
    super.initState();
    _editedDrink = widget.drink;
    selectedToolId = List<String>.from(widget.drink.toolId);
    print("Selected toolId on Edit: $selectedToolId");
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTools());
  }

  Future<void> _saveFormDrink() async {
    final isValid =
        _editForm.currentState!.validate() && _editedDrink.hasDrinkImage();

    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();
    try {
      final drinkManager = context.read<DrinkManager>();
      if (_editedDrink.id != null && _editedDrink.id!.isNotEmpty) {
        await drinkManager.updateDrink(_editedDrink);
      } else {
        await drinkManager.addDrink(_editedDrink);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Drink saved successfully!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green.shade200,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      debugPrint('Error saving form: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Error!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.red.shade200,
        ),
      );
    }
  }

  Future<void> _loadTools() async {
    try {
      final toolManager = context.read<ToolManager>();
      await toolManager.fetchTool();
      if (!mounted) return;

      setState(() {
        _tools = toolManager.items;

        selectedToolId = _editedDrink.toolId.where((id) {
          return _tools.any((tool) => tool.id == id);
        }).toList();
      });
    } catch (error) {
      print('Error loading tools: $error');
    }
  }

  Future<void> showErrorDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.error),
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ActionButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Edit Drink",
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
        actions: <Widget>[
          ThemeButton(
            changeThemeMode: (isBright) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _editForm,
            child: ListView(
              children: <Widget>[
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 18),
                ),
                _buildNameField(),
                const SizedBox(height: 20),
                const Text(
                  'Origin',
                  style: TextStyle(fontSize: 18),
                ),
                _buildOriginField(),
                const SizedBox(height: 20),
                const Text(
                  'Tool',
                  style: TextStyle(fontSize: 18),
                ),
                _buildToolField(),
                const SizedBox(height: 20),
                const Text(
                  'Caffeine',
                  style: TextStyle(fontSize: 18),
                ),
                _builCaffeineField(),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18),
                ),
                _buildDescriptionField(),
                const SizedBox(height: 20),
                const Text(
                  'Ingredient',
                  style: TextStyle(fontSize: 18),
                ),
                _buildIngredientsField(),
                const SizedBox(height: 20),
                const Text(
                  'Image',
                  style: TextStyle(fontSize: 18),
                ),
                _buildDrinkPreview(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: _saveFormDrink,
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _editedDrink.name,
      decoration: _inputDecoration('Enter name'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter name.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDrink = _editedDrink.copyWith(name: value);
      },
    );
  }

  MultiSelectDialogField<String> _buildToolField() {
    if (_tools.isEmpty) {
      return MultiSelectDialogField<String>(
        items: [],
        title: const Text("Select Tools"),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        onConfirm: (values) {},
      );
    }

    return MultiSelectDialogField<String>(
      items: _tools
          .where((tool) => tool.id != null)
          .map((tool) => MultiSelectItem<String>(tool.id!, tool.name))
          .toList(),
      title: const Text("Select Tools"),
      selectedColor: Colors.blue,
      initialValue: selectedToolId,
      onConfirm: (values) {
        setState(() {
          selectedToolId = List<String>.from(values);
          _editedDrink = _editedDrink.copyWith(toolId: selectedToolId);
        });
      },
    );
  }

  TextFormField _buildOriginField() {
    return TextFormField(
      initialValue: _editedDrink.origin,
      decoration: _inputDecoration('Enter origin'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter origin.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDrink = _editedDrink.copyWith(origin: value);
      },
    );
  }

  TextFormField _builCaffeineField() {
    return TextFormField(
      initialValue: _editedDrink.caffeine,
      decoration: _inputDecoration('Enter caffeine'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter caffeine.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDrink = _editedDrink.copyWith(caffeine: value);
      },
    );
  }

  TextFormField _buildIngredientsField() {
    return TextFormField(
      initialValue: _editedDrink.ingredients,
      decoration: _inputDecoration('Enter ingredients'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter ingredients.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDrink = _editedDrink.copyWith(ingredients: value);
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _editedDrink.description,
      decoration: _inputDecoration('Enter description'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter description.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDrink = _editedDrink.copyWith(description: value);
      },
    );
  }

  TextButton _buildImagePickerButton() {
    return TextButton.icon(
      icon: const Icon(Icons.image),
      label: const Text('Pick Image'),
      onPressed: () async {
        final imagePicker = ImagePicker();
        try {
          final imageFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (imageFile == null) {
            return;
          }
          setState(() {
            _editedDrink =
                _editedDrink.copyWith(drinkImage: File(imageFile.path));
          });
        } catch (error) {
          if (mounted) {
            showErrorDialog(context, 'Something went wrong.');
          }
        }
      },
    );
  }

  Widget _buildDrinkPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: !_editedDrink.hasDrinkImage()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editedDrink.drinkImage == null
                      ? Image.network(
                          _editedDrink.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editedDrink.drinkImage!,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: SizedBox(height: 100, child: _buildImagePickerButton()),
        ),
      ],
    );
  }
}
