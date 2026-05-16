import 'package:flutter/material.dart';

/// Central place for all app-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Mission Exhibition 5K';
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';

  /// The 6 mission sections of the exhibition
  static const List<MissionSection> missionSections = [
    MissionSection(
      name: 'Mission in Old Testament',
      icon: Icons.auto_stories,
      color: Color(0xFF5C4033),
      subtitle: 'Discover missions in the Old Testament',
    ),
    MissionSection(
      name: 'Mission in New Testament',
      icon: Icons.church,
      color: Color(0xFF2E7D32),
      subtitle: 'Explore missions in the New Testament',
    ),
    MissionSection(
      name: 'Mission History',
      icon: Icons.history_edu,
      color: Color(0xFF1565C0),
      subtitle: 'Trace the history of missions',
    ),
    MissionSection(
      name: 'Ethiopian Missionaries',
      icon: Icons.people,
      color: Color(0xFFE65100),
      subtitle: 'Learn about Ethiopian missionaries',
    ),
    MissionSection(
      name: '10/40 Window Unreached People',
      icon: Icons.public,
      color: Color(0xFF6A1B9A),
      subtitle: 'Reaching the unreached in 10/40 Window',
    ),
    MissionSection(
      name: 'Mission in Campus',
      icon: Icons.school,
      color: Color(0xFFB71C1C),
      subtitle: 'Campus mission initiatives',
    ),
  ];
}

/// Model for each mission section's display data
class MissionSection {
  final String name;
  final IconData icon;
  final Color color;
  final String subtitle;

  const MissionSection({
    required this.name,
    required this.icon,
    required this.color,
    required this.subtitle,
  });
}
