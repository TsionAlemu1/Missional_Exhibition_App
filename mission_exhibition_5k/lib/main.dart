import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'features/materials/data/repositories/material_repository.dart';
import 'features/materials/domain/repositories/abstract_material_repository.dart';
import 'features/materials/presentation/bloc/material_bloc.dart';
import 'features/materials/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MissionExhibitionApp());
}

/// Root application widget
class MissionExhibitionApp extends StatelessWidget {
  const MissionExhibitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AbstractMaterialRepository>(
      create: (_) => MaterialRepository(dio: DioClient().dio),
      child: BlocProvider<MaterialBloc>(
        create: (context) => MaterialBloc(
          materialRepository: context.read<AbstractMaterialRepository>(),
        ),
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
