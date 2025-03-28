import 'dart:io';

import 'package:coffee_app/models/store.dart';
import 'package:coffee_app/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import 'package:coffee_app/ui/screens.dart';


class EditStore extends StatefulWidget {
  static const routeName = '/edit_store';

  EditStore(
    Store? store, {
    super.key,
    required String id,
  }) {
    if (store == null) {
      this.store = Store(
        id: null,
        name: '',
        location: '',
        phone: '',
        startTime: '',
        endTime: '',
        description: '',
        imageUrl: '',
      );
    } else {
      this.store = store;
    }
  }

  late final Store store;

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final _editForm = GlobalKey<FormState>();
  late Store _editedStore;

  @override
  void initState() {
    super.initState();
    _editedStore = widget.store;
  }

  Future<void> _saveFormStore() async {
    print('Bắt đầu lưu form');

    final isValid =
        _editForm.currentState!.validate() && _editedStore.hasStoreImage();
    print('Form hợp lệ: $isValid');

    if (!isValid) {
      print('Form không hợp lệ, dừng lại.');
      return;
    }

    _editForm.currentState!.save();
    print('Dữ liệu sau khi save: $_editedStore');

    try {
      print('Gọi addStore() với dữ liệu: $_editedStore');

      final storeManager = context.read<StoreManager>();
      if (_editedStore.id != null && _editedStore.id!.isNotEmpty) {
        await storeManager.updateStore(_editedStore);
      } else {
        await storeManager.addStore(_editedStore);
        print(' Đã gọi thành công addStore() để tạo mới.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Store saved successfully!',
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
          "Edit Store",
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
                  'Location',
                  style: TextStyle(fontSize: 18),
                ),
                _buildLocationField(),
                const SizedBox(height: 20),
                const Text(
                  'Phone',
                  style: TextStyle(fontSize: 18),
                ),
                _buildPhoneField(),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18),
                ),
                _buildDescriptionField(),
                const SizedBox(height: 20),
                const Text(
                  'Start Time (HH:mm)',
                  style: TextStyle(fontSize: 18),
                ),
                _buildStartTimeField(),
                const SizedBox(height: 20),
                const Text(
                  'End Time (HH:mm)',
                  style: TextStyle(fontSize: 18),
                ),
                _buildEndTimeField(),
                const SizedBox(height: 20),
                const Text(
                  'Image',
                  style: TextStyle(fontSize: 18),
                ),
                _buildStorePreview(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: _saveFormStore,
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
      initialValue: _editedStore.name,
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
        _editedStore = _editedStore.copyWith(name: value);
      },
    );
  }

  TextFormField _buildLocationField() {
    return TextFormField(
      initialValue: _editedStore.location,
      decoration: _inputDecoration('Enter location'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter location.';
        }
        return null;
      },
      onSaved: (value) {
        _editedStore = _editedStore.copyWith(location: value);
      },
    );
  }

  TextFormField _buildPhoneField() {
    return TextFormField(
      initialValue: _editedStore.phone,
      decoration: _inputDecoration('Enter phone'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter phone.';
        }
        return null;
      },
      onSaved: (value) {
        _editedStore = _editedStore.copyWith(phone: value);
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _editedStore.description,
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
        _editedStore = _editedStore.copyWith(description: value);
      },
    );
  }

  TextFormField _buildStartTimeField() {
    return TextFormField(
      initialValue: _editedStore.startTime,
      decoration: _inputDecoration('Enter start time'),
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter start time.';
        }
        return null;
      },
      onSaved: (value) {
        _editedStore = _editedStore.copyWith(startTime: value);
      },
    );
  }

  TextFormField _buildEndTimeField() {
    return TextFormField(
      initialValue: _editedStore.endTime,
      decoration: _inputDecoration('Enter end time'),
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter end time.';
        }
        return null;
      },
      onSaved: (value) {
        _editedStore = _editedStore.copyWith(endTime: value);
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
            _editedStore =
                _editedStore.copyWith(storeImage: File(imageFile.path));
          });
        } catch (error) {
          if (mounted) {
            showErrorDialog(context, 'Something went wrong.');
          }
        }
      },
    );
  }

  Widget _buildStorePreview() {
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
          child: !_editedStore.hasStoreImage()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editedStore.storeImage == null
                      ? Image.network(
                          _editedStore.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editedStore.storeImage!,
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
