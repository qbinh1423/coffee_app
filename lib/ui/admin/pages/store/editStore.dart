import 'dart:io';

import 'package:coffee_app/models/store.dart';
import 'package:coffee_app/ui/admin/pages/store/store_manager.dart';
import 'package:coffee_app/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../components/adminDrawer.dart';

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
        const SnackBar(content: Text('Store saved successfully!')),
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
        actions: <Widget> [
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
                _buildNameField(),
                _buildLocationField(),
                _buildPhoneField(),
                _buildDescriptionField(),
                _buildStartTimeField(),
                _buildEndTimeField(),
                _buildStorePreview(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _editedStore.name,
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
        _editedStore = _editedStore.copyWith(name: value);
      },
    );
  }

  TextFormField _buildLocationField() {
    return TextFormField(
      initialValue: _editedStore.location,
      decoration: const InputDecoration(labelText: 'Location'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a location.';
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
      decoration: const InputDecoration(labelText: 'Phone'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a phone.';
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
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long.';
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
      decoration: const InputDecoration(labelText: 'Start Time (HH:mm)'),
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a start time.';
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
      decoration: const InputDecoration(labelText: 'End Time (HH:mm)'),
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide an end time.';
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
            _editedStore = _editedStore.copyWith(storeImage: File(imageFile.path));
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
          width: 100,
          height: 100,
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
