import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a quick-action service tile on the dashboard.
///
/// The [destination] field is an optional widget builder. When null, the service
/// tile is rendered but navigates nowhere (useful for WIP features).
class ServiceItem extends Equatable {
  final IconData icon;
  final String label;
  final Color color;

  /// The widget to push when this service is tapped.
  /// Passed as a builder so we defer widget instantiation until navigation.
  final WidgetBuilder? destination;

  const ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    this.destination,
  });

  @override
  List<Object?> get props => [icon, label, color];
}
