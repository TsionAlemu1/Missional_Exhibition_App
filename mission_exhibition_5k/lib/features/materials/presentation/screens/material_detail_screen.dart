import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mission_exhibition_5k/core/widgets/loading_widget.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_bloc.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_event.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_state.dart';
import 'edit_material_screen.dart';

/// Screen displaying full details of a single material
class MaterialDetailScreen extends StatelessWidget {
  final MaterialEntity material;

  const MaterialDetailScreen({super.key, required this.material});

  Color _getSectionColor() {
    const colors = {
      'Mission in Old Testament': Color(0xFF5C4033),
      'Mission in New Testament': Color(0xFF2E7D32),
      'Mission History': Color(0xFF1565C0),
      'Ethiopian Missionaries': Color(0xFFE65100),
      '10/40 Window Unreached People': Color(0xFF6A1B9A),
      'Mission in Campus': Color(0xFFB71C1C),
    };
    return colors[material.missionSection] ?? Colors.green;
  }

  IconData _getSectionIcon() {
    const icons = {
      'Mission in Old Testament': Icons.auto_stories,
      'Mission in New Testament': Icons.church,
      'Mission History': Icons.history_edu,
      'Ethiopian Missionaries': Icons.people,
      '10/40 Window Unreached People': Icons.public,
      'Mission in Campus': Icons.school,
    };
    return icons[material.missionSection] ?? Icons.explore;
  }

  @override
  Widget build(BuildContext context) {
    final Color sectionColor = _getSectionColor();
    final theme = Theme.of(context);

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
          title: const Text('Material Details'),
          backgroundColor: sectionColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        EditMaterialScreen(material: material),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        body: BlocBuilder<MaterialBloc, MaterialBlocState>(
          builder: (context, state) {
            if (state is MaterialBlocLoading) {
              return const LoadingWidget(message: 'Processing...');
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image section
                  Container(
                    height: 280,
                    color: Colors.grey[100],
                    child: material.imageUrl.isNotEmpty
                        ? Image.network(
                            material.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              _getSectionIcon(),
                              size: 64,
                              color: sectionColor.withValues(alpha: 0.5),
                            ),
                          ),
                  ),
                  // Details section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          material.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Mission section badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sectionColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getSectionIcon(),
                                size: 18,
                                color: sectionColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                material.missionSection,
                                style: TextStyle(
                                  color: sectionColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Description
                        Text(
                          'Description',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          material.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Reference price
                        if (material.price > 0)
                          Row(
                            children: [
                              Icon(Icons.attach_money,
                                  color: Colors.grey[600], size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'Reference: \$${material.price.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        if (material.id != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.tag,
                                  color: Colors.grey[600], size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'Material ID: #${material.id}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting the material
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Material'),
        content: Text(
          'Are you sure you want to delete "${material.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<MaterialBloc>()
                  .add(DeleteMaterial(material.id!));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
