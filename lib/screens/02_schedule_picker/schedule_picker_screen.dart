// Purpose: UI for Step 2: Date & Time Selection.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../models/schedule_slot.dart';
import '../../repositories/mock_schedule_repository.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/step_progress_bar.dart';
import '../../state/order_provider.dart';
import 'package:intl/intl.dart';
import '../../state/locale_provider.dart';

class SchedulePickerScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback? onValidationChanged;

  const SchedulePickerScreen(
      {super.key,
      required this.onNext,
      required this.onBack,
      this.onValidationChanged});

  @override
  State<SchedulePickerScreen> createState() => SchedulePickerScreenState();
}

class SchedulePickerScreenState extends State<SchedulePickerScreen> {
  DateTime _selectedDate = DateTime.now();
  ScheduleSlot? _selectedSlot;
  final _repository = MockScheduleRepository();
  late Future<List<ScheduleSlot>> _slotsFuture;
  final _specialInstructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize with existing data from OrderProvider if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      if (orderProvider.scheduleSlot != null) {
        setState(() {
          _selectedDate = orderProvider.scheduleSlot!.date;
          _selectedSlot = orderProvider.scheduleSlot;
        });
        _slotsFuture = _repository.getAvailableSlotsForDate(_selectedDate);
      } else {
        _slotsFuture = _repository.getAvailableSlotsForDate(_selectedDate);
      }

      // Load special instructions if they exist
      if (orderProvider.specialInstructions != null) {
        _specialInstructionsController.text =
            orderProvider.specialInstructions!;
      }

      // Notify parent about validation state
      widget.onValidationChanged?.call();
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _selectedSlot = null; // Reset selected slot when date changes
      _slotsFuture = _repository
          .getAvailableSlotsForDate(newDate); // Update the future here
    });
    // Notify parent that validation state changed (slot was reset)
    widget.onValidationChanged?.call();
  }

  bool canContinue() => _selectedSlot != null;

  void submit() {
    if (!canContinue()) return;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.setSchedule(_selectedSlot!);
    orderProvider.setSpecialInstructions(
        _specialInstructionsController.text.trim().isEmpty
            ? null
            : _specialInstructionsController.text.trim());
    widget.onNext();
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.select_pickup_date,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)),
              onDateChanged: _onDateChanged,
            ),
          ),
          const SizedBox(height: 24),
          _buildSummaryBox(
            context,
            icon: Icons.calendar_today,
            title: localizations.selected_date,
            content:
                DateFormat('EEEE, MMMM d', localeProvider.locale.languageCode)
                    .format(_selectedDate),
          ),
          const SizedBox(height: 24),
          Text(localizations.select_time_slot,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          FutureBuilder<List<ScheduleSlot>>(
            future: _slotsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(localizations.no_available_slots));
              }
              final slots = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  final isSelected = _selectedSlot == slot;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedSlot = slot);
                      // Notify parent that validation state changed
                      widget.onValidationChanged?.call();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                      ),
                      child: Center(
                        child: Text(
                          "${slot.startTime.format(context)} - ${slot.endTime.format(context)}",
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          if (_selectedSlot != null)
            _buildSummaryBox(
              context,
              icon: Icons.access_time,
              title: localizations.selected_time,
              content:
                  "${_selectedSlot!.startTime.format(context)} - ${_selectedSlot!.endTime.format(context)}",
            ),
          const SizedBox(height: 24),
          Text(localizations.special_instructions_optional,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _specialInstructionsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: localizations.special_instructions_hint,
            ),
          ),
          const SizedBox(height: 100), // Pushes content up from bottom button
        ],
      ),
    );
  }

  Widget _buildSummaryBox(BuildContext context,
      {required IconData icon,
      required String title,
      required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(content, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
