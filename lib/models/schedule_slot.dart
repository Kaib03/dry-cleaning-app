// Purpose: Data model for a single pickup/delivery time slot.
import 'package:flutter/material.dart';

class ScheduleSlot {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  ScheduleSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
  });
} 