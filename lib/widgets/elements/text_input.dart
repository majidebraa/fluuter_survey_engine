import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../base_reactive_widget.dart';

class TextInputWidget extends ReactiveSurveyWidget {
  final void Function(dynamic)? onChanged; // <-- ADDED

  const TextInputWidget({
    super.key,
    required super.el,
    required super.engine,
    this.onChanged,
  });

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends ReactiveSurveyWidgetState<TextInputWidget> {
  TextEditingController? ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: value?.toString() ?? '');
  }

  @override
  void dispose() {
    ctrl?.dispose();
    super.dispose();
  }

  @override
  void onEngineUpdate() {
    if (ctrl == null) return;

    final newValue = value?.toString() ?? '';
    if (ctrl!.text != newValue) {
      ctrl!.text = newValue;
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: TextField(
        controller: ctrl,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          errorText: error,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor:
              isReadOnly ? AppColors.greyReadOnlyColor : AppColors.whiteColor,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greyReadOnlyColor),
          ),
        ),
        style: TextStyle(
          color: isReadOnly ? AppColors.greyColor : AppColors.blackColor,
        ),
        onChanged: isReadOnly
            ? null
            : (txt) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(txt); // <-- MatrixDropdown update
                  } else {
                    setValue(txt); // <-- Normal field update
                  }
                });
              },
      ),
    );
  }
}
