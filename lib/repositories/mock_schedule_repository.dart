// Purpose: A fake implementation of the schedule repository.
import 'package:flutter/material.dart';
import '../models/schedule_slot.dart';
import 'abstract_schedule_repository.dart';

class MockScheduleRepository implements AbstractScheduleRepository {
  @override
  Future<List<ScheduleSlot>> getAvailableSlotsForDate(DateTime date) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return a fixed list of slots regardless of the date for now
    return [
      ScheduleSlot(
          date: date,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 10, minute: 0)),
      ScheduleSlot(
          date: date,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 12, minute: 0)),
      ScheduleSlot(
          date: date,
          startTime: const TimeOfDay(hour: 12, minute: 0),
          endTime: const TimeOfDay(hour: 14, minute: 0)),
      ScheduleSlot(
          date: date,
          startTime: const TimeOfDay(hour: 14, minute: 0),
          endTime: const TimeOfDay(hour: 16, minute: 0)),
    ];
  }
}
