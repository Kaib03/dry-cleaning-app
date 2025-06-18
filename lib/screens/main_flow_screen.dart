import 'package:flutter/material.dart';

import '01_address_entry/address_entry_screen.dart';
import '02_schedule_picker/schedule_picker_screen.dart';
import '03_service_selection/service_selection_screen.dart';
import '04_order_summary/order_summary_screen.dart';

class MainFlowScreen extends StatefulWidget {
  const MainFlowScreen({super.key});

  @override
  _MainFlowScreenState createState() => _MainFlowScreenState();
}

class _MainFlowScreenState extends State<MainFlowScreen> {
  final PageController _pageController = PageController();
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AddressEntryScreen(currentStep: 1, onNext: () => _navigateToPage(1)),
      SchedulePickerScreen(
          currentStep: 2,
          onNext: () => _navigateToPage(2),
          onBack: _navigateBack),
      ServiceSelectionScreen(
          currentStep: 3,
          onNext: () => _navigateToPage(3),
          onBack: _navigateBack),
      OrderSummaryScreen(
          onBack: _navigateBack), // Summary doesn't have a progress bar
    ];
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _navigateBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: _screens,
    );
  }
}
