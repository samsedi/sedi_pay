import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a single entry in the recent transactions list.
class TransactionItem extends Equatable {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  /// Formatted amount string, e.g. "-₦1,000.00" or "+₦50,000.00".
  final String amount;

  /// True for debits (outgoing funds), false for credits.
  final bool isDebit;

  const TransactionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.isDebit,
  });

  @override
  List<Object?> get props => [icon, title, subtitle, time, amount, isDebit];
}
