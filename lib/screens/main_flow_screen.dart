import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '01_address_entry/address_entry_screen.dart';
import '02_schedule_picker/schedule_picker_screen.dart';
import '03_service_selection/service_selection_screen.dart';
import '04_order_summary/order_summary_screen.dart';
import '../app_localizations.dart';
import '../state/order_provider.dart';
import '../widgets/common/primary_button.dart';
import '../widgets/common/step_progress_bar.dart';
import '../widgets/common/language_toggle.dart';

class MainFlowScreen extends StatefulWidget {
  const MainFlowScreen({super.key});

  @override
  _MainFlowScreenState createState() => _MainFlowScreenState();
}

class _MainFlowScreenState extends State<MainFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // GlobalKeys to access child state
  final _addressKey = GlobalKey<AddressEntryScreenState>();
  final _scheduleKey = GlobalKey<SchedulePickerScreenState>();
  final _serviceKey = GlobalKey<ServiceSelectionScreenState>();
  // OrderSummaryScreen is stateless, so no key needed.

  List<Widget> _screens = [];
  List<String> _titles = [];
  List<VoidCallback> _submitActions = [];
  List<bool Function()> _canContinue = [];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page!.round();
      if (_currentPage != page) {
        // This is a workaround to force rebuild and update button state
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // It's important to define screen-related data here
    // because it depends on `context` for localizations.
    _buildScreenData();
  }

  void _buildScreenData() {
    final localizations = AppLocalizations.of(context)!;
    _screens = [
      AddressEntryScreen(
        key: _addressKey,
        onNext: () => _navigateToPage(1),
        onValidationChanged: () {
          // Force rebuild when validation state changes
          setState(() {});
        },
      ),
      SchedulePickerScreen(
        key: _scheduleKey,
        onNext: () => _navigateToPage(2),
        onBack: _navigateBack,
        onValidationChanged: () {
          // Force rebuild when validation state changes
          setState(() {});
        },
      ),
      ServiceSelectionScreen(
        key: _serviceKey,
        onNext: () => _navigateToPage(3),
        onBack: _navigateBack,
        onValidationChanged: () {
          // Force rebuild when validation state changes
          setState(() {});
        },
      ),
      OrderSummaryScreen(
        onBack: _navigateBack,
        onEditStep: (step) => _navigateToPage(step),
      ),
    ];

    _titles = [
      localizations.personal_information_title,
      localizations.schedule_pickup_title,
      localizations.select_services_title,
      localizations.order_summary_title,
    ];

    _submitActions = [
      () => _addressKey.currentState?.submitAddress(),
      () => _scheduleKey.currentState?.submit(),
      () => _serviceKey.currentState?.submit(),
      () {
        // Handle order confirmation logic
        print("Order Confirmed!");
        // Potentially navigate to a success screen or back to the start
        _navigateToPage(0); // Go back to start for now
        // You might want to clear the order provider here
      },
    ];

    _canContinue = [
      () {
        final state = _addressKey.currentState;
        return state?.canContinue() ?? false;
      },
      () {
        final state = _scheduleKey.currentState;
        return state?.canContinue() ?? false;
      },
      () {
        final state = _serviceKey.currentState;
        return state?.canContinue() ?? false;
      },
      () => true, // Always can confirm on the summary screen
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
    // Rebuild screen data if context (and thus localizations) changes
    _buildScreenData();

    // Safety check to prevent accessing empty lists
    if (_screens.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final localizations = AppLocalizations.of(context)!;
    final bool canProceed = _canContinue[_currentPage]();
    print(
        'Current page: $_currentPage, Can proceed: $canProceed'); // Debug print

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          appBar: AppBar(
            leading: _currentPage == 0
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _navigateBack),
            automaticallyImplyLeading: _currentPage != 0,
            title: Text(_titles[_currentPage]),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: const LanguageToggle(),
              ),
            ],
          ),
          body: Column(
            children: [
              if (_currentPage < 3) // Hide progress on the last step
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: StepProgressBar(
                      currentStep: _currentPage + 1, totalSteps: 4),
                ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    // We need to call setState to rebuild the button
                    // when the user swipes (if swiping were enabled).
                    // Although physics is NeverScrollableScrollPhysics,
                    // this is good practice.
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: _screens,
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: _currentPage == 3
                  ? localizations.confirm_place_order
                  : localizations.continue_button,
              onPressed: canProceed ? _submitActions[_currentPage] : null,
            ),
          ),
        ),
      ),
    );
  }
}
