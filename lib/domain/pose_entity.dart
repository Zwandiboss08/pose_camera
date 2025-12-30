import 'package:equatable/equatable.dart';

class PoseEntity extends Equatable {
  final String id;
  final String category;
  final String title;
  final String assetPath;

  const PoseEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.assetPath,
  });

  @override
  List<Object?> get props => [id, category, title, assetPath];
}
