import 'package:flutter/material.dart';
import 'package:flutter_survey_engine/extenssion/jalali_extenstions.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'app_colors.dart';
import 'app_strings.dart';
import 'custom_text.dart';

/// Jalali date picker dialog (basic)
class JalaliDatePickerDialog extends StatefulWidget {
  final Jalali initialDate;

  const JalaliDatePickerDialog({super.key, required this.initialDate});

  @override
  State<JalaliDatePickerDialog> createState() => _JalaliDatePickerDialogState();
}

class _JalaliDatePickerDialogState extends State<JalaliDatePickerDialog> {
  late Jalali selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  void _incrementMonth() {
    setState(() {
      selectedDate = selectedDate.addMonths(1);
    });
  }

  void _decrementMonth() {
    setState(() {
      selectedDate = selectedDate.addMonths(-1);
    });
  }

  void _selectDay(int day) {
    setState(() {
      selectedDate = Jalali(selectedDate.year, selectedDate.month, day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalDays = selectedDate.monthLength;
    return AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      title: Text(
        selectedDate.formatFullDate(),
        textAlign: TextAlign.right,
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _decrementMonth,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('${selectedDate.formatter.mN} ${selectedDate.year}'),
                  IconButton(
                    onPressed: _incrementMonth,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                  itemCount: totalDays,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final isSelected = selectedDate.day == day;
                    return GestureDetector(
                      onTap: () => _selectDay(day),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primaryColor : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$day',
                              style: TextStyle(
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const CustomText(text: AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedDate),
          child: const CustomText(text: AppStrings.confirm),
        ),
      ],
    );
  }
}
