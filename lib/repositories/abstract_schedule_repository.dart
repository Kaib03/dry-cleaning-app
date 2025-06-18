// Purpose: Defines the contract (interface) for schedule-related data operations.
import '../models/schedule_slot.dart';

abstract class AbstractScheduleRepository {
  Future<List<ScheduleSlot>> getAvailableSlotsForDate(DateTime date);
}
