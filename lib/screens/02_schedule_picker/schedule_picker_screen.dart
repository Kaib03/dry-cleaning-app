// Purpose: UI for Step 2: Date & Time Selection.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule_slot.dart';
import '../../repositories/mock_schedule_repository.dart';
import '../../widgets/common/primary_button.dart';
import '../../state/order_provider.dart';

class SchedulePickerScreen extends StatefulWidget {
  final VoidCallback onNext;

  const SchedulePickerScreen({Key? key, required this.onNext})
      : super(key: key);

  @override
  _SchedulePickerScreenState createState() => _SchedulePickerScreenState();
}

class _SchedulePickerScreenState extends State<SchedulePickerScreen> {
  DateTime _selectedDate = DateTime.now();
  ScheduleSlot? _selectedSlot;
  final _repository = MockScheduleRepository();
  late Future<List<ScheduleSlot>> _slotsFuture;

  @override
  void initState() {
    super.initState();
    _slotsFuture = _repository.getAvailableSlotsForDate(_selectedDate);
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _selectedSlot = null; // Reset selected slot when date changes
      _slotsFuture = _repository
          .getAvailableSlotsForDate(newDate); // Update the future here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          appBar: AppBar(title: const Text("Select Pickup Schedule")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Pickup Date",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                    onDateChanged: _onDateChanged,
                  ),
                ),
                const SizedBox(height: 24),
                Text("Select Time Slot",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                FutureBuilder<List<ScheduleSlot>>(
                  future: _slotsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No available slots."));
                    }
                    final slots = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                          onTap: () => setState(() => _selectedSlot = slot),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
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
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: "Continue",
              onPressed: _selectedSlot != null
                  ? () {
                      final orderProvider =
                          Provider.of<OrderProvider>(context, listen: false);
                      orderProvider.setSchedule(_selectedSlot!);
                      widget.onNext();
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
