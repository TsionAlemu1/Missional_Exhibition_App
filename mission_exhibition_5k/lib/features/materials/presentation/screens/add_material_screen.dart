import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mission_exhibition_5k/core/constants/app_constants.dart';
import 'package:mission_exhibition_5k/core/widgets/loading_widget.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_bloc.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_event.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_state.dart';

/// Screen for adding a new material
class AddMaterialScreen extends StatefulWidget {
  final String? missionSection;

  const AddMaterialScreen({super.key, this.missionSection});

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  late String _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.missionSection ??
        AppConstants.missionSections.first.name;
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
          title: const Text('Add Material'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<MaterialBloc, MaterialBlocState>(
          builder: (context, state) {
            if (state is MaterialBlocLoading) {
              return const LoadingWidget(message: 'Creating material...');
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
                    // Submit button
                    ElevatedButton.icon(
                      onPressed: _onSubmit,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Save Material',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
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

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final material = MaterialEntity(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        missionSection: _selectedSection,
      );
      context.read<MaterialBloc>().add(CreateMaterial(material));
    }
  }
}
