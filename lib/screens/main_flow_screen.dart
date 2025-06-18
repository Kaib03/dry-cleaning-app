import 'package:flutter/material.dart';

import '01_address_entry/address_entry_screen.dart';
import '02_schedule_picker/schedule_picker_screen.dart';
import '03_service_selection/service_selection_screen.dart';
import '04_order_summary/order_summary_screen.dart';
import '../widgets/common/step_progress_bar.dart';

class MainFlowScreen extends StatefulWidget {
  const MainFlowScreen({Key? key}) : super(key: key);

  @override
  _MainFlowScreenState createState() => _MainFlowScreenState();
}

class _MainFlowScreenState extends State<MainFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // Add this to track the current page
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    _screens = [
      AddressEntryScreen(
          onNext: () =>
              _navigateToPage(1)), // First screen doesn't get a back button
      SchedulePickerScreen(
          onNext: () => _navigateToPage(2), onBack: _navigateBack),
      ServiceSelectionScreen(
          onNext: () => _navigateToPage(3), onBack: _navigateBack),
      OrderSummaryScreen(
          onBack: _navigateBack), // Summary screen only needs a back button
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
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            // Wrap PageView in a Column
            children: [
              // Add the progress bar here
              if (_currentPage < 3) // Don't show on summary screen
                StepProgressBar(currentStep: _currentPage + 1),

              Expanded(
                // Make PageView take the remaining space
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _screens,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
