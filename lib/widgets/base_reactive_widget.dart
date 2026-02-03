import 'package:flutter/material.dart';

import '../engine/survey_engine.dart';
import '../models/form_models.dart';

/// Base class for all survey widgets that react to SurveyEngine changes
abstract class ReactiveSurveyWidget extends StatefulWidget {
  final FormElement el;
  final SurveyEngine engine;

  const ReactiveSurveyWidget({Key? key, required this.el, required this.engine})
    : super(key: key);
}

/// Base state for ReactiveSurveyWidget
abstract class ReactiveSurveyWidgetState<W extends ReactiveSurveyWidget>
    extends State<W> {
  bool _pendingRebuild = false;

  @override
  void initState() {
    super.initState();

    widget.engine.addListener(_onEngineChange);

    // sync initial engine state after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scheduleRebuild();
    });
  }

  @override
  void dispose() {
    widget.engine.removeListener(_onEngineChange);
    super.dispose();
  }

  // -----------------------------
  //  ENGINE → WIDGET UPDATE PIPE
  // -----------------------------
  void _onEngineChange() {
    if (!mounted) return;

    onEngineUpdate();
    _scheduleRebuild();
  }

  // batch multiple rebuild requests into ONE per frame
  void _scheduleRebuild() {
    if (_pendingRebuild) return;
    _pendingRebuild = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pendingRebuild = false;
        setState(() {});
      }
    });
  }

  /// Subclasses override this only if needed
  void onEngineUpdate() {}

  bool get isVisible => widget.engine.isVisible(widget.el);

  bool get isReadOnly => widget.engine.isReadOnly(widget.el);

  dynamic get value => widget.engine.getValue(widget.el.name);

  String? get error => widget.engine.errors[widget.el.name];

  void setValue(dynamic v) => widget.engine.setValue(widget.el.name, v);

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      // <-- prevents dropdown losing overlay attach
      key: ValueKey(widget.el.name),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: ConstrainedBox(
          constraints: isVisible
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 0),
          child: Visibility(
            visible: isVisible,
            maintainState: true,
            maintainAnimation: true,
            child: buildContent(context),
          ),
        ),
      ),
    );
  }
}
