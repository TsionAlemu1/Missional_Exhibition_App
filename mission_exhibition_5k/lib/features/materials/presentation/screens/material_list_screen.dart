import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mission_exhibition_5k/core/widgets/empty_state_widget.dart';
import 'package:mission_exhibition_5k/core/widgets/error_widget.dart';
import 'package:mission_exhibition_5k/core/widgets/loading_widget.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_bloc.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_event.dart';
import 'package:mission_exhibition_5k/features/materials/presentation/bloc/material_state.dart';
import 'add_material_screen.dart';
import 'material_detail_screen.dart';

/// Screen that lists materials filtered by mission section
class MaterialListScreen extends StatefulWidget {
  final String missionSection;

  const MaterialListScreen({super.key, required this.missionSection});

  @override
  State<MaterialListScreen> createState() => _MaterialListScreenState();
}

class _MaterialListScreenState extends State<MaterialListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch materials for this section on load
    context
        .read<MaterialBloc>()
        .add(FetchMaterials(missionSection: widget.missionSection));
  }

  Color _getSectionColor() {
    final index = _getSectionIndex();
    if (index != -1) {
      return _sectionColors[index];
    }
    return Colors.green;
  }

  int _getSectionIndex() {
    for (int i = 0; i < _sectionNames.length; i++) {
      if (_sectionNames[i] == widget.missionSection) return i;
    }
    return -1;
  }

  static const List<String> _sectionNames = [
    'Mission in Old Testament',
    'Mission in New Testament',
    'Mission History',
    'Ethiopian Missionaries',
    '10/40 Window Unreached People',
    'Mission in Campus',
  ];

  static const List<Color> _sectionColors = [
    Color(0xFF5C4033),
    Color(0xFF2E7D32),
    Color(0xFF1565C0),
    Color(0xFFE65100),
    Color(0xFF6A1B9A),
    Color(0xFFB71C1C),
  ];

  @override
  Widget build(BuildContext context) {
    final Color sectionColor = _getSectionColor();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.missionSection,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: sectionColor,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<MaterialBloc, MaterialBlocState>(
        listener: (context, state) {
          if (state is MaterialBlocError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is MaterialBlocOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MaterialBlocLoading) {
            return const LoadingWidget(message: 'Loading materials...');
          }
          if (state is MaterialBlocError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context
                    .read<MaterialBloc>()
                    .add(FetchMaterials(missionSection: widget.missionSection));
              },
            );
          }
          if (state is MaterialsBlocLoaded) {
            if (state.materials.isEmpty) {
              return EmptyStateWidget(
                title: 'No Materials Yet',
                subtitle:
                    'No materials found for ${widget.missionSection}. Tap + to add one.',
                icon: Icons.library_books_outlined,
                action: ElevatedButton.icon(
                  onPressed: () => _navigateToAdd(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Material'),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<MaterialBloc>()
                    .add(FetchMaterials(missionSection: widget.missionSection));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.materials.length,
                itemBuilder: (context, index) {
                  final material = state.materials[index];
                  return _MaterialCard(
                    material: material,
                    sectionColor: sectionColor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              MaterialDetailScreen(material: material),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: sectionColor,
        foregroundColor: Colors.white,
        onPressed: () => _navigateToAdd(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddMaterialScreen(missionSection: widget.missionSection),
      ),
    );
  }
}

/// Individual material card in the list
class _MaterialCard extends StatelessWidget {
  final dynamic material;
  final Color sectionColor;
  final VoidCallback onTap;

  const _MaterialCard({
    required this.material,
    required this.sectionColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey[100],
                  child: material.imageUrl.isNotEmpty
                      ? Image.network(
                          material.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        )
                      : Icon(
                          Icons.image,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      material.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sectionColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        material.missionSection,
                        style: TextStyle(
                          fontSize: 11,
                          color: sectionColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
