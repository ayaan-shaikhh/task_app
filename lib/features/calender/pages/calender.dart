import 'package:flutter/material.dart';
import '../../../core/stores/task_store.dart';
import '../../../core/stores/habit_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../tasks/widgets/section_card.dart';
import '../../habits/widgets/habit_section_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.taskstore,
    required this.habitstore,
  });

  final TaskStore taskstore;
  final HabitStore habitstore;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const _gradTop = Color(0xFFF8CBA9);
  static const _gradBottom = Color(0xFFEE9DB4);
  static const _sheetColor = Color(0xFF050505);
  static const _ink = Color(0xFF111111);

  static const _animDuration = Duration(milliseconds: 320);

  String _selectedView = 'tasks';
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  // false = collapsed (week strip only), true = full month calendar
  bool _expanded = false;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _setExpanded(bool value) {
    if (_expanded == value) return;
    setState(() {
      _expanded = value;
      // Keep the visible month in sync with the selected day.
      if (!value) {
        _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month);
      }
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  void _changeWeek(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 7 * delta));
      _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
      _focusedMonth = DateTime(date.year, date.month);
    });
    // Let the selection register visually, then close the calendar.
    if (_expanded) {
      Future.delayed(const Duration(milliseconds: 220), () {
        if (mounted) _setExpanded(false);
      });
    }
  }

  Future<void> _pickYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _focusedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    return Column(
      children: [
        // ---------- Gradient calendar area (pull down / push up) ----------
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (details) {
            final v = details.primaryVelocity ?? 0;
            if (v > 200) _setExpanded(true); // pull down
            if (v < -200) _setExpanded(false); // push up
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_gradTop, _gradBottom],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    AnimatedDefaultTextStyle(
                      duration: _animDuration,
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontSize: _expanded ? 38 : 26,
                        fontWeight: FontWeight.w400,
                        color: _ink,
                        height: 1.1,
                      ),
                      child: Text(_monthName(_focusedMonth.month)),
                    ),
                    const SizedBox(height: 16),
                    _buildWeekdayHeader(),
                    const SizedBox(height: 6),
                    AnimatedCrossFade(
                      duration: _animDuration,
                      sizeCurve: Curves.easeInOut,
                      firstCurve: Curves.easeOut,
                      secondCurve: Curves.easeIn,
                      alignment: Alignment.topCenter,
                      crossFadeState: _expanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: _buildWeekStrip(),
                      secondChild: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragEnd: (details) {
                          final v = details.primaryVelocity ?? 0;
                          if (v < -200) _changeMonth(1);
                          if (v > 200) _changeMonth(-1);
                        },
                        child: _buildMonthGrid(),
                      ),
                    ),
                    _buildHandle(),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ---------- Dark bottom sheet ----------
        Expanded(
          child: Container(
            color: _gradBottom, // shows behind the rounded sheet corners
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: _sheetColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  _buildSheetHeader(),
                  const Divider(height: 1, color: Colors.white12),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: _buildToggle(),
                  ),
                  Expanded(
                    // Pulling down on an already-top list also opens the calendar.
                    child: NotificationListener<OverscrollNotification>(
                      onNotification: (n) {
                        if (n.overscroll < -8) _setExpanded(true);
                        return false;
                      },
                      child: _buildSheetContent(customColors),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Small pill at the bottom of the gradient: tap or drag to open/close.
  Widget _buildHandle() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _setExpanded(!_expanded),
      child: SizedBox(
        height: 28,
        width: double.infinity,
        child: Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _ink.withOpacity(0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: _pickYear,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_focusedMonth.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: _ink,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: _ink),
              ],
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: _ink),
              onPressed: () {}, // TODO: search
            ),
            IconButton(
              icon: const Icon(Icons.add, color: _ink),
              onPressed: () {}, // TODO: add task / habit
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Row(
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: _ink,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // Collapsed state: just the week containing the selected date.
  Widget _buildWeekStrip() {
    final monday = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day - (_selectedDate.weekday - 1),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v < -200) _changeWeek(1);
        if (v > 200) _changeWeek(-1);
      },
      child: Row(
        children: List.generate(7, (i) {
          final date = DateTime(monday.year, monday.month, monday.day + i);
          return Expanded(child: _buildDayCell(date, dimOutsideMonth: false));
        }),
      ),
    );
  }

  // Expanded state: the full month.
  Widget _buildMonthGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final startingWeekday = firstDay.weekday - 1; // Mon = 0
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final totalRows = ((startingWeekday + daysInMonth) / 7).ceil();
    final gridStart = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1 - startingWeekday,
    );

    return Column(
      children: List.generate(totalRows, (week) {
        return Row(
          children: List.generate(7, (dow) {
            final date = gridStart.add(Duration(days: week * 7 + dow));
            return Expanded(child: _buildDayCell(date, dimOutsideMonth: true));
          }),
        );
      }),
    );
  }

  Widget _buildDayCell(DateTime date, {required bool dimOutsideMonth}) {
    final now = DateTime.now();
    final inMonth = !dimOutsideMonth || date.month == _focusedMonth.month;
    final isToday = _sameDay(date, now);
    final isSelected = _sameDay(date, _selectedDate);

    final hasTasks =
        widget.taskstore.tasks.any((t) => _sameDay(t.deadline, date));
    // Habit scheduling isn't date-based yet, so only mark today.
    final hasHabits = widget.habitstore.todayhabits.isNotEmpty && isToday;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onDateTap(date),
      child: SizedBox(
        height: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : Colors.transparent,
                border: isToday && !isSelected
                    ? Border.all(color: _ink, width: 1)
                    : null,
              ),
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : inMonth
                          ? _ink
                          : Colors.white.withOpacity(0.55),
                ),
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasTasks) _dot(_ink.withOpacity(inMonth ? 0.85 : 0.35)),
                  if (hasHabits) _dot(const Color(0xFF8E2C4A)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 4,
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  Widget _buildSheetHeader() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _setExpanded(true),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_weekdayName(_selectedDate.weekday)} ${_selectedDate.day}, '
              '${_monthName(_selectedDate.month)}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime.now();
                  _focusedMonth = DateTime.now();
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 28),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('Today', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return SegmentedButton<String>(
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white70,
        selectedBackgroundColor: Colors.white,
        selectedForegroundColor: Colors.black,
        side: const BorderSide(color: Colors.white24),
      ),
      segments: const [
        ButtonSegment(
          value: 'tasks',
          label: Text('Tasks'),
          icon: Icon(Icons.flag_rounded, size: 16),
        ),
        ButtonSegment(
          value: 'habits',
          label: Text('Habits'),
          icon: Icon(Icons.check_rounded, size: 16),
        ),
      ],
      selected: {_selectedView},
      onSelectionChanged: (s) => setState(() => _selectedView = s.first),
    );
  }

  Widget _buildSheetContent(AppCustomColors customColors) {
    final dateLabel = '${_selectedDate.day} ${_monthName(_selectedDate.month)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: _selectedView == 'tasks'
          ? ListenableBuilder(
              listenable: widget.taskstore,
              builder: (context, _) {
                final tasks = widget.taskstore.tasks
                    .where((t) => _sameDay(t.deadline, _selectedDate))
                    .toList();
                return SectionCard(
                  title: 'Tasks',
                  subtitle: dateLabel,
                  icon: Icons.flag_rounded,
                  accent: customColors.warningText,
                  accentText: customColors.warningText,
                  tint: customColors.warningTint,
                  border: customColors.warningBorder,
                  tasks: tasks,
                  onToggle: widget.taskstore.toggle,
                  taskstore: widget.taskstore,
                  // onOpen: () {},
                );
              },
            )
          : ListenableBuilder(
              listenable: widget.habitstore,
              builder: (context, _) {
                final habits = widget.habitstore.todayhabits;
                return HabitSectionCard(
                  title: 'Habits',
                  subtitle: dateLabel,
                  icon: Icons.check_rounded,
                  accent: customColors.successText,
                  accentText: customColors.successText,
                  tint: customColors.successTint,
                  border: customColors.successBorder,
                  onToggle: widget.habitstore.toggle,
                  habits: habits,
                  habitstore: widget.habitstore,
                  // onOpen: () {},
                );
              },
            ),
    );
  }

  String _weekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}