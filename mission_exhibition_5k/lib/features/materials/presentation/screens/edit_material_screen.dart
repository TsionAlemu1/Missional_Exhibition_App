import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mission_exhibition_5k/core/constants/app_constants.dart';
import 'package:mission_exhibition_5k/core/widgets/loading_widget.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_bloc.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_event.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_state.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';


/// Screen for editing an existing material
class EditMaterialScreen extends StatefulWidget {
  final MaterialEntity material;

  const EditMaterialScreen({super.key, required this.material});

  @override
  State<EditMaterialScreen> createState() => _EditMaterialScreenState();
}

class _EditMaterialScreenState extends State<EditMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _priceController;
  late String _selectedSection;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-fill fields with existing data
    _titleController = TextEditingController(text: widget.material.title);
    _descriptionController =
        TextEditingController(text: widget.material.description);
    _imageUrlController =
        TextEditingController(text: widget.material.imageUrl);
    _priceController =
        TextEditingController(text: widget.material.price.toString());
    _selectedSection = widget.material.missionSection;

    // Add listener to rebuild when imageUrl changes so preview works reactively
    _imageUrlController.addListener(_onImageUrlChanged);
  }

  void _onImageUrlChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_onImageUrlChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _imageUrlController.text = image.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _buildImagePreview() {
    final path = _imageUrlController.text.trim();
    if (path.isEmpty) {
      return InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Upload Image from Local Machine',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                'or paste a remote URL below',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final isNetwork = path.startsWith('http') || path.startsWith('https') || path.startsWith('blob:');
    
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: isNetwork || kIsWeb
                  ? Image.network(
                      path,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.red),
                      ),
                    )
                  : Image.file(
                      File(path),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.red),
                      ),
                    ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.6),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _imageUrlController.clear();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialBloc, MaterialBlocState>(
      listener: (context, state) {
        if (state is MaterialBlocOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
        if (state is MaterialBlocError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Material'),
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<MaterialBloc, MaterialBlocState>(
          builder: (context, state) {
            if (state is MaterialBlocLoading) {
              return const LoadingWidget(message: 'Updating material...');
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Material Title',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Image Upload & Preview Section
                    _buildImagePreview(),
                    const SizedBox(height: 16),
                    // Image URL field
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image Path / URL (optional)',
                        prefixIcon: const Icon(Icons.image),
                        hintText: 'https://example.com/image.jpg',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.file_upload),
                          tooltip: 'Upload from Local Machine',
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Price field
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price (optional)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // Mission section dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSection,
                      decoration: const InputDecoration(
                        labelText: 'Mission Section',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: AppConstants.missionSections
                          .map((section) => DropdownMenuItem(
                                value: section.name,
                                child: Text(section.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedSection = value);
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    // Update button
                    ElevatedButton.icon(
                      onPressed: _onUpdate,
                      icon: const Icon(Icons.update),
                      label: const Text(
                        'Update Material',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedMaterial = MaterialEntity(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        missionSection: _selectedSection,
      );
      context
          .read<MaterialBloc>()
          .add(UpdateMaterial(widget.material.id!, updatedMaterial));
    }
  }
}
