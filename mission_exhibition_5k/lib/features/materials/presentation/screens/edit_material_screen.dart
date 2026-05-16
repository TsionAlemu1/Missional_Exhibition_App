import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mission_exhibition_5k/core/constants/app_constants.dart';
import 'package:mission_exhibition_5k/core/widgets/loading_widget.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_bloc.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_event.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_state.dart';

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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    super.dispose();
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
                    // Image URL field
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL (optional)',
                        prefixIcon: Icon(Icons.image),
                        hintText: 'https://example.com/image.jpg',
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
