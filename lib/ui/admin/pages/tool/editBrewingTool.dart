import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../theme/theme.dart';
import '../../../../theme/themeProvider.dart';
import '../../../shared/dialog_utils.dart';
import 'package:coffee_app/models/tool.dart';

import 'toolManager.dart';

class EditBrewingTool extends StatefulWidget {
  static const routeName = '/edit_tool';

  EditBrewingTool(
    Tool? tool, {
    super.key,
    required String id,
  }) {
    if (tool == null) {
      this.tool = Tool(
        id: null,
        name: '',
        origin: '',
        type: '',
        material: '',
        description: '',
        imageUrl: '',
      );
    } else {
      this.tool = tool;
    }
  }

  late final Tool tool;

  @override
  State<EditBrewingTool> createState() => _EditBrewingToolState();
}

class _EditBrewingToolState extends State<EditBrewingTool> {
  final _editForm = GlobalKey<FormState>();
  late Tool _editedTool;

  @override
  void initState() {
    super.initState();
    _editedTool = widget.tool;
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

  Future<void> _saveFormTool() async {
    final isValid =
        _editForm.currentState!.validate() && _editedTool.hasFeaturedImage();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();
    try {
      final toolManager = context.read<ToolManager>();
      if (_editedTool.id != null && _editedTool.id!.isNotEmpty) {
        await toolManager.updateTool(_editedTool);
      } else {
        await toolManager.addTool(_editedTool);
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
    } catch (error) {
      debugPrint('Error saving form: $error');
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Edit Tool',
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
                'Type',
                style: TextStyle(fontSize: 18),
              ),
              _buildTypeField(),
              const SizedBox(height: 20),
              const Text(
                'Materia',
                style: TextStyle(fontSize: 18),
              ),
              _buildMaterialField(),
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
              _buildToolPreview(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: _saveFormTool,
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
      initialValue: _editedTool.name,
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
        _editedTool = _editedTool.copyWith(name: value);
      },
    );
  }

  TextFormField _buildOriginField() {
    return TextFormField(
      initialValue: _editedTool.origin,
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
        _editedTool = _editedTool.copyWith(origin: value);
      },
    );
  }

  TextFormField _buildTypeField() {
    return TextFormField(
      initialValue: _editedTool.type,
      decoration: _inputDecoration('Enter type'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter type.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTool = _editedTool.copyWith(type: value);
      },
    );
  }

  TextFormField _buildMaterialField() {
    return TextFormField(
      initialValue: _editedTool.material,
      decoration: _inputDecoration('Enter material'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter material.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTool = _editedTool.copyWith(material: value);
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _editedTool.description,
      decoration: _inputDecoration('Enter description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter description.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTool = _editedTool.copyWith(description: value);
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
          _editedTool = _editedTool.copyWith(
            toolImage: File(imageFile.path),
          );
          setState(() {});
        } catch (error) {
          if (mounted) {
            showErrorDialog(context, 'Something went wrong.');
          }
        }
      },
    );
  }

  Widget _buildToolPreview() {
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
          child: !_editedTool.hasFeaturedImage()
              ? const Center(child: Text('No Image'))
              : FittedBox(
                  child: _editedTool.toolImage == null
                      ? Image.network(
                          _editedTool.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _editedTool.toolImage!,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
            child: SizedBox(height: 100, child: _buildImagePickerButton())),
      ],
    );
  }
}
