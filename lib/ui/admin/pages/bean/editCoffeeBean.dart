import 'dart:io';

import 'package:coffee_app/models/bean.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../../shared/dialog_utils.dart';
import '../../components/adminDrawer.dart';
import 'bean_manager.dart';

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
    print('Bắt đầu lưu form');

    final isValid =
        _editForm.currentState!.validate() && _editedBean.hasBeanImage();
    print('Form hợp lệ: $isValid');

    if (!isValid) {
      print('Form không hợp lệ, dừng lại.');
      return;
    }

    _editForm.currentState!.save();
    print('Dữ liệu sau khi save: $_editedBean');

    try {
      print('Gọi addBean() với dữ liệu: $_editedBean');

      final beansManager = context.read<BeansManager>();
      if (_editedBean.id != null && _editedBean.id!.isNotEmpty) {
        await beansManager.updateBean(_editedBean);
      } else {
        await beansManager.addBean(_editedBean);
        print(' Đã gọi thành công addBean() để tạo mới.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bean saved successfully!')),
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
                _buildAltitudeField(),
                _buildCaffeineField(),
                _buildClimateField(),
                _buildDescriptionField(),
                _buildOriginField(),
                _buildBeanPreview(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _editedBean.name,
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
        _editedBean = _editedBean.copyWith(name: value);
      },
    );
  }

  TextFormField _buildAltitudeField() {
    return TextFormField(
      initialValue: _editedBean.altitude,
      decoration: const InputDecoration(labelText: 'Altitude'),
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
      decoration: const InputDecoration(labelText: 'Climate'),
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
      decoration: const InputDecoration(labelText: 'Caffeine'),
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
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        // if (value.length < 10) {
        //   return 'Should be at least 10 characters long.';
        // }
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
      decoration: const InputDecoration(labelText: 'Origin'),
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
          width: 100,
          height: 100,
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
