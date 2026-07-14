import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:final_project/reuse/budget.dart';
import 'package:final_project/reuse/person_count_card.dart';
import 'package:final_project/models/destination_model.dart';
import 'package:final_project/pages/itinerary_page.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';

class TripPlannerPage extends StatefulWidget {
  final List<DestinationModel>? selectedPlaces;
  const TripPlannerPage({super.key, this.selectedPlaces});

  @override
  State<TripPlannerPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripPlannerPage> {
  String selectedCount = "Solo";
  String selectedBudget = "Budget";

  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  int get _dateCount {
    if (_rangeStart == null) return 0;
    final end = _rangeEnd ?? _rangeStart!;
    return end.difference(_rangeStart!).inDays + 1;
  }

  void _handleContinue() {
    final places = widget.selectedPlaces ?? [];
    if (places.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No places selected. Go back and select places to plan a trip.")),
      );
      return;
    }
    if (_rangeStart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your travel dates on the calendar")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItineraryPage(
          places: places,
          startDate: _rangeStart!,
          endDate: _rangeEnd ?? _rangeStart!,
          travellerType: selectedCount,
          budget: selectedBudget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CHANGED: added persistent tab bar (Saved tab, since trip planning starts from Saved Places)
      bottomNavigationBar: const CustomTabBar(currentIndex: 2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Trip Planner",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("Who is Travelling?", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("(Select Travellers...)", style: TextStyle(color: const Color.fromARGB(255, 92, 92, 92), fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 20),
                  PersonCountCard(
                    picIcon: Icons.person,
                    count: "Solo",
                    description: "Just Me",
                    isSelected: selectedCount == "Solo",
                    onTap: () => setState(() => selectedCount = "Solo"),
                  ),
                  const SizedBox(height: 15),
                  PersonCountCard(
                    picIcon: Icons.people,
                    count: "Couple",
                    description: "A romantic gateway",
                    isSelected: selectedCount == "Couple",
                    onTap: () => setState(() => selectedCount = "Couple"),
                  ),
                  const SizedBox(height: 15),
                  PersonCountCard(
                    picIcon: Icons.family_restroom,
                    count: "Family",
                    description: "Fun for whole family",
                    isSelected: selectedCount == "Family",
                    onTap: () => setState(() => selectedCount = "Family"),
                  ),
                  const SizedBox(height: 15),
                  PersonCountCard(
                    picIcon: Icons.group,
                    count: "Friends",
                    description: "Travel with your buddies",
                    isSelected: selectedCount == "Friends",
                    onTap: () => setState(() => selectedCount = "Friends"),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("Set Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      rangeSelectionMode: RangeSelectionMode.toggledOn,
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      calendarStyle: const CalendarStyle(
                        rangeHighlightColor: Color.fromARGB(60, 19, 74, 38),
                        rangeStartDecoration: BoxDecoration(color: Color(0xFF134a26), shape: BoxShape.circle),
                        rangeEndDecoration: BoxDecoration(color: Color(0xFF134a26), shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(color: Color.fromARGB(80, 19, 74, 38), shape: BoxShape.circle),
                      ),
                      onRangeSelected: (start, end, focusedDay) {
                        setState(() {
                          _rangeStart = start;
                          _rangeEnd = end;
                          _focusedDay = focusedDay;
                        });
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _rangeStart = selectedDay;
                          _rangeEnd = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      "Date count: $_dateCount",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF134a26)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("Set Budget", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text("(Select your budget preference...)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 92, 92))),
                  ),
                  const SizedBox(height: 20),
                  Budget(
                    budget: "Budget",
                    description: "Stay concious of costs",
                    price: "LKR 0-25,000",
                    isSelected: selectedBudget == "Budget",
                    onTap: () => setState(() => selectedBudget = "Budget"),
                  ),
                  const SizedBox(height: 15),
                  Budget(
                    budget: "Moderate",
                    description: "Balance of comfort & cost",
                    price: "LKR 25,000-60,000",
                    isSelected: selectedBudget == "Moderate",
                    onTap: () => setState(() => selectedBudget = "Moderate"),
                  ),
                  const SizedBox(height: 15),
                  Budget(
                    budget: "Luxury",
                    description: "Indulgent & Premium",
                    price: "LKR 60,000 +",
                    isSelected: selectedBudget == "Luxury",
                    onTap: () => setState(() => selectedBudget = "Luxury"),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _handleContinue,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(color: const Color(0xFF134a26), borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text("Continue", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
