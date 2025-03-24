import 'dart:io';

import 'package:coffee_app/models/drink.dart';
import 'package:coffee_app/ui/admin/pages/drink/drink_manager.dart';
import 'package:coffee_app/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../../auth/auth_manager.dart';
import '../../components/adminDrawer.dart';

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
        ingredients: [],
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

  @override
  void initState() {
    super.initState();
    _editedDrink = widget.drink;
  }

  Future<void> _saveFormDrink() async {
    print('Bắt đầu lưu form');

    final isValid =
        _editForm.currentState!.validate() && _editedDrink.hasDrinkImage();
    print('Form hợp lệ: $isValid');

    if (!isValid) {
      print('Form không hợp lệ, dừng lại.');
      return;
    }

    final userId = context.read<AuthManager>().user?.id;
    final toolId = _editedDrink.toolId;

    if (userId == null || toolId == null) {
      print('userId hoặc toolId đang null, dừng lại.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID hoặc Tool ID không hợp lệ!')),
      );
      return;
    }

    _editForm.currentState!.save();
    print('Dữ liệu sau khi save: $_editedDrink');

    try {
      print('Gọi addDrink() với dữ liệu: $_editedDrink');

      final drinkManager = context.read<DrinkManager>();
      if (_editedDrink.id != null && _editedDrink.id!.isNotEmpty) {
        await drinkManager.updateDrink(_editedDrink, userId, toolId);
        print('Drink đã được cập nhật.');
      } else {
        await drinkManager.addDrink(_editedDrink, userId, toolId);
        print('Drink mới đã được tạo.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Drink saved successfully!')),
      );
      Navigator.pop(context);
    } catch (error) {
      debugPrint('Error saving form: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi lưu Drink!')),
      );
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
        actions: <Widget>[
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
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _editForm,
            child: ListView(
              children: <Widget>[
                _buildNameField(),
                _buildOriginField(),
                _builCaffeineField(),
                _buildDescriptionField(),
                _buildIngredientsField(),
                _buildDrinkPreview(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _editedDrink.name,
      decoration: const InputDecoration(labelText: 'Name'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a name.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDrink = _editedDrink.copyWith(name: value);
      },
    );
  }

  TextFormField _buildOriginField() {
    return TextFormField(
      initialValue: _editedDrink.origin,
      decoration: const InputDecoration(labelText: 'Origin'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a origin.';
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
      decoration: const InputDecoration(labelText: 'Caffeine'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a caffeine.';
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
      initialValue: _editedDrink.ingredients.join(", "),
      decoration:
          const InputDecoration(labelText: 'Ingredients (comma-separated)'),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please provide ingredients.';
        }
        return null;
      },
      onSaved: (value) {
        final ingredientsList = value!.split(',').map((e) => e.trim()).toList();
        _editedDrink = _editedDrink.copyWith(ingredients: ingredientsList);
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _editedDrink.description,
      decoration: const InputDecoration(labelText: 'Description'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a description.';
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
            _editedDrink = _editedDrink.copyWith(drinkImage: File(imageFile.path));
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
          width: 100,
          height: 100,
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
