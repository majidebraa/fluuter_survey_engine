import 'package:flutter/material.dart';

import '../engine/survey_engine.dart';
import '../models/form_models.dart';

/// Base class for all survey widgets that react to SurveyEngine changes
abstract class ReactiveSurveyWidget extends StatefulWidget {
  final FormElement el;
  final SurveyEngine engine;

  const ReactiveSurveyWidget({
    Key? key,
    required this.el,
    required this.engine,
  }) : super(key: key);
}

/// Base state for ReactiveSurveyWidget
abstract class ReactiveSurveyWidgetState<W extends ReactiveSurveyWidget>
    extends State<W> {
  @mustCallSuper
  @override
  void initState() {
    super.initState();

    widget.engine.addListener(_update);

    // Defer sync until subclass initState finishes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _update();
    });
  }

  @mustCallSuper
  @override
  void dispose() {
    widget.engine.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (!mounted) return;

    // First update local state (controllers, etc.)
    onEngineUpdate();

    // Then rebuild widget tree
    setState(() {});
  }

  /// Hook for subclasses to react to engine updates
  void onEngineUpdate() {}

  bool get isVisible => widget.engine.isVisible(widget.el);
  bool get isReadOnly => widget.engine.isReadOnly(widget.el);
  dynamic get value => widget.engine.getValue(widget.el.name);
  String? get error => widget.engine.errors[widget.el.name];
  void setValue(dynamic v) => widget.engine.setValue(widget.el.name, v);

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: ConstrainedBox(
        constraints: isVisible
            ? const BoxConstraints()
            : const BoxConstraints(maxHeight: 0),
        child: Visibility(
          visible: isVisible,
          maintainState: true,
          child: buildContent(context),
        ),
      ),
    );
  }
}

