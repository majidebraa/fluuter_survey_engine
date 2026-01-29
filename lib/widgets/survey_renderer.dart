import 'package:flutter/material.dart';
import 'package:flutter_survey_engine/widgets/elements/expression.dart';
import 'package:flutter_survey_engine/widgets/elements/question_title.dart';
import 'package:flutter_survey_engine/widgets/elements/time_picker.dart';

import '../engine/survey_engine.dart';
import '../models/form_models.dart';
import 'elements/boolean_toggle.dart';
import 'elements/checkbox_multi.dart';
import 'elements/comment_input.dart';
import 'elements/dropdown.dart';
import 'elements/matrix.dart';
import 'elements/matrix_dynamic.dart';
import 'elements/panel_card.dart';
import 'elements/persian_date_picker.dart';
import 'elements/radio_group.dart';
import 'elements/signature_pad.dart';
import 'elements/text_input.dart';

class SurveyRenderer extends StatefulWidget {
  final TaskFormDataDto dto;
  final SurveyEngine engine;
  final void Function(Map<String, dynamic>)? onSubmit;
  final void Function(String name, dynamic value)? onChange;
  final TextDirection textDirection;

  const SurveyRenderer({
    Key? key,
    required this.dto,
    required this.engine,
    this.onChange,
    this.onSubmit,
    this.textDirection = TextDirection.rtl,
  }) : super(key: key);

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
            children: [
              for (final page in widget.dto.formSchema.pages)
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(page.name,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        for (final el in page.elements)
                          if (widget.engine.isVisible(el)) _buildElement(el),
                      ],
                    ),
                  ),
                ),
              _submitButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          final ok = await widget.engine.trySubmit();
          if (ok) {
            widget.onSubmit?.call(widget.engine.values);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Submitted')),
            );
          } else {
            print("${widget.engine.values}");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill required fields')),
            );
          }
        },
        child: const Text('Submit'),
      ),
    );
  }

  Widget _buildElement(FormElement el, {int level = 0}) {
    // 🔥 visibility check (important)
    if (!widget.engine.isVisible(el)) {
      return const SizedBox.shrink();
    }

    // 🔹 PANEL (recursive)
    if (el.type == 'panel') {
      return PanelCard(
        title: el.title ?? el.name,
        children: [
          for (final child in el.elements ?? []) _buildElement(child),
        ],
      );
    }

    // 🔹 NORMAL QUESTION
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.engine.isVisible(el) && el.title != null)
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
            return TimePicker(el: el, engine: widget.engine);
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
