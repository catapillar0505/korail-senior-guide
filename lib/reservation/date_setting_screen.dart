import 'package:flutter/material.dart';

class DateSettingScreen extends StatefulWidget {
  final DateTime initialDate;
  final int initialHour;

  const DateSettingScreen({
    super.key,
    required this.initialDate,
    required this.initialHour,
  });

  @override
  State<DateSettingScreen> createState() => _DateSettingScreenState();
}

class _DateSettingScreenState extends State<DateSettingScreen> {
  late DateTime selectedDate;
  late int selectedHour;
  late PageController _hourController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedHour = widget.initialHour;
    _hourController = PageController(
      initialPage: selectedHour,
      viewportFraction: 0.25,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    super.dispose();
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  }

  bool _isWeekend(int day, int month, int year) {
    final date = DateTime(year, month, day);
    return date.weekday == 6 || date.weekday == 7;
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = selectedDate.month;
    final currentYear = selectedDate.year;
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final firstWeekday = DateTime(currentYear, currentMonth, 1).weekday;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Navigation Bar
                Image.asset(
                  'assets/figma_images/reservation/date-top-navbar.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),


          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Previous/Next Month Navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month - 1,
                                selectedDate.day,
                              );
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0288D1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                          child: const Text(
                            '이전달',
                            style: TextStyle(
                              color: Color(0xFF0288D1),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${currentYear}년 ${currentMonth}월',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D5B),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month + 1,
                                selectedDate.day,
                              );
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0288D1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                          child: const Text(
                            '다음달',
                            style: TextStyle(
                              color: Color(0xFF0288D1),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Calendar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        // Weekday Headers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildWeekdayHeader('일', true),
                            _buildWeekdayHeader('월', false),
                            _buildWeekdayHeader('화', false),
                            _buildWeekdayHeader('수', false),
                            _buildWeekdayHeader('목', false),
                            _buildWeekdayHeader('금', false),
                            _buildWeekdayHeader('토', true),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Calendar Grid
                        _buildCalendarGrid(
                          daysInMonth,
                          firstWeekday,
                          currentYear,
                          currentMonth,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Time Label
                  const Text(
                    '시간',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0288D1),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hour Selector
                  Container(
                    height: 60,
                    color: const Color(0xFFE3E3E3),
                    child: PageView.builder(
                      controller: _hourController,
                      onPageChanged: (index) {
                        setState(() {
                          selectedHour = index;
                        });
                      },
                      itemCount: 24, // 00 ~ 23
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedHour;
                        return GestureDetector(
                          onTap: () {
                            _hourController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 80),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0288D1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                '${index.toString().padLeft(2, '0')}시',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSelected ? 20 : 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF666666),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),

          // Selected Date Display and Buttons
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4B5963),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Date Display Section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    color: const Color(0xFF4B5963),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '가는날',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            '${currentYear}년 ${currentMonth.toString().padLeft(2, '0')}월 ${selectedDate.day.toString().padLeft(2, '0')}일 (${_getWeekday(selectedDate)}) ${selectedHour.toString().padLeft(2, '0')}:00',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Buttons Section
                  Container(
                    color: const Color(0xFFB8CDD9),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: const Text(
                              '이전',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF003D5B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context, {
                                'date': selectedDate,
                                'hour': selectedHour,
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: const Text(
                              '확인',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF003D5B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader(String day, bool isWeekend) {
    return Expanded(
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isWeekend ? Colors.red : const Color(0xFF0288D1),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(
    int daysInMonth,
    int firstWeekday,
    int year,
    int month,
  ) {
    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday % 7; i++) {
      dayWidgets.add(Expanded(child: SizedBox(height: 44)));
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected = day == selectedDate.day;
      final isWeekend = _isWeekend(day, month, year);

      dayWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = DateTime(year, month, day);
              });
            },
            child: Container(
              height: 44,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0288D1) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : isWeekend
                          ? Colors.red
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Build rows
    List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: dayWidgets.sublist(
              i,
              i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
            ),
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}
