import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/custom_button.dart';
import '../common/custom_text.dart';
import '../engine/survey_engine.dart';
import '../models/form_models.dart';
import 'elements/boolean_toggle.dart';
import 'elements/checkbox_multi.dart';
import 'elements/comment_input.dart';
import 'elements/dropdown.dart';
import 'elements/expression.dart';
import 'elements/matrix.dart';
import 'elements/matrix_dynamic.dart';
import 'elements/panel_card.dart';
import 'elements/persian_date_picker.dart';
import 'elements/question_title.dart';
import 'elements/radio_group.dart';
import 'elements/signature_pad.dart';
import 'elements/text_input.dart';
import 'elements/time_picker.dart';

class SurveyRenderer extends StatefulWidget {
  final TaskFormDataDto dto;
  final SurveyEngine engine;

  /// Called whenever a field changes
  final void Function(String name, dynamic value)? onChange;

  /// Called when user clicks an action button
  /// Returns: outcomeType + current form values
  final void Function(String outcomeType, Map<String, dynamic> data)? onOutcome;

  final TextDirection textDirection;

  const SurveyRenderer({
    super.key,
    required this.dto,
    required this.engine,
    this.onChange,
    this.onOutcome,
    this.textDirection = TextDirection.rtl,
  });

  @override
  State<SurveyRenderer> createState() => _SurveyRendererState();
}

class _SurveyRendererState extends State<SurveyRenderer> {
  @override
  void initState() {
    super.initState();

    widget.engine.setInitial(widget.dto.formData);
    widget.engine.globalReadOnly = widget.dto.readOnly;

    widget.engine.onValueChanged = (name, value) {
      widget.onChange?.call(name, value);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: AnimatedBuilder(
        animation: widget.engine,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 0),
            children: [
              CustomText(
                text: widget.dto.formSchema.title,
                textAlign: TextAlign.right,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                padding: EdgeInsets.all(12),
              ),
              // Render pages and their elements
              for (final page in widget.dto.formSchema.pages)
                Card(
                  color: AppColors.greyLightPanelColor,
                  elevation: 0,
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: page.name,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        for (final el in page.elements) _buildElement(el),
                      ],
                    ),
                  ),
                ),

              //  Render outcome/action buttons
              if (!widget.dto.readOnly) _actionButtons(context),
            ],
          );
        },
      ),
    );
  }

  // ---------------- ACTION BUTTONS ----------------
  Widget _actionButtons(BuildContext context) {
    final outcomeList = widget.dto.formSchema.outcomeType;

    if (outcomeList.isEmpty) return const SizedBox.shrink();

    // Define icons for common outcomes (customize as needed)
    final Map<String, IconData> outcomeIcons = {
      'SUBMIT': Icons.send,
      'NO': Icons.close,
      'ACCEPT': Icons.check_circle,
      'COMPLETED': Icons.done_all,
      'OK': Icons.thumb_up,
      'REJECT': Icons.cancel,
      'APPROVE': Icons.check,
      'DEFER': Icons.schedule,
      'SendToExport': Icons.upload_file,
    };

    // Custom text mapping if you want to display different labels
    final Map<String, String> outcomeTexts = {
      'SUBMIT': 'ارسال',
      'NO': 'نه',
      'ACCEPT': 'پذیرش',
      'COMPLETED': 'تکمیل',
      'OK': 'تایید',
      'REJECT': 'رد',
      'APPROVE': 'موافقت',
      'DEFER': 'به تعویق انداختن',
      'SendToExpert': 'ارسال به کارشناس',
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: outcomeList.map((action) {
          final icon = outcomeIcons[action] ?? Icons.check;
          final text = outcomeTexts[action] ?? action;

          return CustomButton(
            onClick: () async {
              final ok = await widget.engine.trySubmit();
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('لطفاً فیلدهای اجباری را تکمیل کنید'),
                  ),
                );
                return;
              }

              // Return selected outcome + form data
              widget.onOutcome?.call(action, widget.engine.values);

              /*ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$text انجام شد')));*/
            },
            icon: Icon(icon).icon,
            text: text,
            width: text.split("").length == 3 ? 250 : 150,
            height: 50,
          );
        }).toList(),
      ),
    );
  }

  // ---------------- ELEMENT RENDERER ----------------
  Widget _buildElement(FormElement el /*, {int level = 0}*/) {
    // Panel (recursive)
    if (el.type == 'panel') {
      return PanelCard(
        title: el.title ?? el.name,
        children: [for (final child in el.elements ?? []) _buildElement(child)],
      );
    }

    // Normal question
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (el.title != null && widget.engine.isVisible(el))
            QuestionTitle(
              title: el.title ?? "",
              isRequired: el.isRequired ?? false,
            ),
          _buildQuestion(el),
        ],
      ),
    );
  }

  Widget _buildQuestion(FormElement el) {
    switch (el.type) {
      case 'text':
        return TextInputWidget(el: el, engine: widget.engine);

      case 'comment':
        return CommentInputWidget(el: el, engine: widget.engine);

      case 'radiogroup':
        return RadioGroupWidget(el: el, engine: widget.engine);

      case 'checkbox':
        return CheckboxMultiWidget(el: el, engine: widget.engine);

      case 'dropdown':
      case 'tagbox':
        return DropdownWidget(el: el, engine: widget.engine);

      case 'boolean':
        return BooleanToggleWidget(el: el, engine: widget.engine);

      case 'date':
      case 'date-picker':
        {
          if (el.dateAndTime != null && el.dateAndTime == "time") {
            return TimePickerWidget(el: el, engine: widget.engine);
          }
          return PersianDatePickerWidget(el: el, engine: widget.engine);
        }

      case 'matrix':
        return MatrixWidget(el: el, engine: widget.engine);

      case 'matrixdynamic':
        return MatrixDynamicWidget(el: el, engine: widget.engine);

      case 'signaturepad':
        return SignaturePadWidget(el: el, engine: widget.engine);

      case 'expression':
        return Expression(el: el, engine: widget.engine);

      default:
        return Text('Unsupported: ${el.type}');
    }
  }
}
