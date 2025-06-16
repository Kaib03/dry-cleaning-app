import 'package:flutter/material.dart';
import '01_address_entry/address_entry_screen.dart';
import '02_schedule_picker/schedule_picker_screen.dart';
import '03_service_selection/service_selection_screen.dart';
import '04_order_summary/order_summary_screen.dart';

class MainFlowScreen extends StatefulWidget {
  const MainFlowScreen({Key? key}) : super(key: key);

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
      AddressEntryScreen(onNext: () => _navigateToPage(1)), // Pass the function
      SchedulePickerScreen(), // Other screens remain for now
      ServiceSelectionScreen(),
      OrderSummaryScreen(),
    ];
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // Disable swiping for now
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
    );
  }
}
