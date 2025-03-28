import 'dart:io';

import 'package:coffee_app/models/bean.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../../shared/dialog_utils.dart';
import 'package:coffee_app/ui/screens.dart';


class EditCoffeeBean extends StatefulWidget {
  static const routeName = '/edit_bean';

  EditCoffeeBean(
    Bean? bean, {
    super.key,
    required String id,
  }) {
    if (bean == null) {
      this.bean = Bean(
        id: null,
        name: '',
        altitude: '',
        climate: '',
        caffeine: '',
        description: '',
        origin: '',
        imageUrl: '',
      );
    } else {
      this.bean = bean;
    }
  }

  late final Bean bean;

  @override
  State<EditCoffeeBean> createState() => _EditCoffeeBeanState();
}

class _EditCoffeeBeanState extends State<EditCoffeeBean> {
  final _editForm = GlobalKey<FormState>();
  late Bean _editedBean;

  @override
  void initState() {
    _editedBean = widget.bean;
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid =
        _editForm.currentState!.validate() && _editedBean.hasBeanImage();
    if (!isValid) {
      return;
    }

    _editForm.currentState!.save();
    try {
      final beansManager = context.read<BeansManager>();
      if (_editedBean.id != null && _editedBean.id!.isNotEmpty) {
        await beansManager.updateBean(_editedBean);
      } else {
        await beansManager.addBean(_editedBean);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Bean saved successfully!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green.shade200,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      debugPrint('Error saving form: $error');
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
                  'Altitude',
                  style: TextStyle(fontSize: 18),
                ),
                _buildAltitudeField(),
                const SizedBox(height: 20),
                const Text(
                  'Caffeine',
                  style: TextStyle(fontSize: 18),
                ),
                _buildCaffeineField(),
                const SizedBox(height: 20),
                const Text(
                  'Climate',
                  style: TextStyle(fontSize: 18),
                ),
                _buildClimateField(),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18),
                ),
                _buildDescriptionField(),
                const SizedBox(height: 20),
                const Text(
                  'Image',
                  style: TextStyle(fontSize: 18),
                ),
                _buildBeanPreview(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: _saveForm,
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
      initialValue: _editedBean.name,
      decoration: _inputDecoration('Enter name'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a name.';
        }
        return null;
      },
      onSaved: (value) {
        _editedBean = _editedBean.copyWith(name: value);
      },
    );
  }

  TextFormField _buildAltitudeField() {
    return TextFormField(
      initialValue: _editedBean.altitude,
      decoration: _inputDecoration('Enter altitude'),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a altitude.';
        }

        return null;
      },
      onSaved: (value) {
        _editedBean = _editedBean.copyWith(altitude: value);
      },
    );
  }

  TextFormField _buildClimateField() {
    return TextFormField(
      initialValue: _editedBean.climate,
      decoration: _inputDecoration('Enter climate'),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a climate.';
        }

        return null;
      },
      onSaved: (value) {
        _editedBean = _editedBean.copyWith(climate: value);
      },
    );
  }

  TextFormField _buildCaffeineField() {
    return TextFormField(
      initialValue: _editedBean.caffeine,
      decoration: _inputDecoration('Enter caffeine'),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a caffeine.';
        }

        return null;
      },
      onSaved: (value) {
        _editedBean = _editedBean.copyWith(caffeine: value);
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _editedBean.description,
      decoration: _inputDecoration('Enter description'),
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        return null;
      },
      onSaved: (value) {
        _editedBean = _editedBean.copyWith(description: value);
      },
    );
  }

  TextFormField _buildOriginField() {
    return TextFormField(
      initialValue: _editedBean.origin,
      decoration: _inputDecoration('Enter origin'),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a origin.';
        }

        return null;
      },
      onSaved: (value) {
        _editedBean = _editedBean.copyWith(origin: value);
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
            _editedBean = _editedBean.copyWith(beanImage: File(imageFile.path));
          });
        } catch (error) {
          if (mounted) {
            showErrorDialog(context, 'Something went wrong.');
          }
        }
      },
    );
  }

  Widget _buildBeanPreview() {
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
          child: !_editedBean.hasBeanImage()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editedBean.beanImage == null
                      ? Image.network(
                          _editedBean.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editedBean.beanImage!,
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
