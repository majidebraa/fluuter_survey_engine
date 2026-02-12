class TaskFormDataDto {
  final FormSchema formSchema;
  final Map<String, dynamic>? formData;
  final bool isClaimed;
  final bool readOnly;
  final FormMetadata formMetadata;

  TaskFormDataDto({
    required this.formSchema,
    required this.formData,
    required this.isClaimed,
    required this.readOnly,
    required this.formMetadata,
  });

  factory TaskFormDataDto.fromJson(Map<String, dynamic> json) =>
      TaskFormDataDto(
        formSchema: FormSchema.fromJson(json['formSchema']),
        formData: json['formData'] != null
            ? Map<String, dynamic>.from(json['formData'])
            : null,
        isClaimed: json['isClaimed'] ?? false,
        readOnly: json['readOnly'] ?? false,
        formMetadata: FormMetadata.fromJson(json['formMetadata']),
      );

  Map<String, dynamic> toJson() => {
        'formSchema': formSchema.toJson(),
        'formData': formData,
        'isClaimed': isClaimed,
        'readOnly': readOnly,
        'formMetadata': formMetadata.toJson(),
      };
}

class FormSchema {
  final String title;
  final String logoPosition;
  final String showQuestionNumbers;
  final List<PageSchema> pages;
  final List<String> outcomeType;
  final List<DataSource> dataSources;

  FormSchema({
    required this.title,
    required this.logoPosition,
    required this.showQuestionNumbers,
    required this.pages,
    required this.outcomeType,
    required this.dataSources,
  });

  factory FormSchema.fromJson(Map<String, dynamic> json) => FormSchema(
        title: json['title'] ?? '',
        logoPosition: json['logoPosition'] ?? '',
        showQuestionNumbers: json['showQuestionNumbers'] ?? 'off',
        pages: (json['pages'] as List<dynamic>? ?? [])
            .map((x) => PageSchema.fromJson(x))
            .toList(),
        outcomeType: (json['outcomeType'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        dataSources: (json['dataSources'] as List<dynamic>? ?? [])
            .map((x) => DataSource.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'logoPosition': logoPosition,
        'showQuestionNumbers': showQuestionNumbers,
        'pages': pages.map((x) => x.toJson()).toList(),
        'outcomeType': outcomeType,
        'dataSources': dataSources.map((x) => x.toJson()).toList(),
      };
}

class PageSchema {
  final String name;
  final List<FormElement> elements;

  PageSchema({required this.name, required this.elements});

  factory PageSchema.fromJson(Map<String, dynamic> json) => PageSchema(
        name: json['name'] ?? '',
        elements: (json['elements'] as List<dynamic>? ?? [])
            .map((x) => FormElement.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'elements': elements.map((x) => x.toJson()).toList(),
      };
}

class DataSource {
  final String title;
  final String dataSourceId;
  final String dataSourceType;
  final List<String> restApiHeader;
  final String restApiUrl;
  final String bodyType;
  final String restApiMethod;
  final String restApiJsonBody;

  DataSource({
    required this.title,
    required this.dataSourceId,
    required this.dataSourceType,
    required this.restApiHeader,
    required this.restApiUrl,
    required this.bodyType,
    required this.restApiMethod,
    required this.restApiJsonBody,
  });

  factory DataSource.fromJson(Map<String, dynamic> json) => DataSource(
        title: json['title'] ?? '',
        dataSourceId: json['dataSourceId'] ?? '',
        dataSourceType: json['dataSourceType'] ?? '',
        restApiHeader: (json['RestApi_Header'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        restApiUrl: json['RestApi_Url'] ?? '',
        bodyType: json['bodyType'] ?? '',
        restApiMethod: json['RestApi_Method'] ?? '',
        restApiJsonBody: json['RestApi_JsonBody'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'dataSourceId': dataSourceId,
        'dataSourceType': dataSourceType,
        'RestApi_Header': restApiHeader,
        'RestApi_Url': restApiUrl,
        'bodyType': bodyType,
        'RestApi_Method': restApiMethod,
        'RestApi_JsonBody': restApiJsonBody,
      };
}

class FormElement {
  final String type;
  final String name;
  final String? title;

  final String? requiredIf;
  final String? visibleIf;
  final bool? readOnly;
  final String? questionId;
  final bool? isRequired;
  final String? inputType;
  final String? maskType;
  final Map<String, dynamic>? maskSettings;
  final bool? visible;
  final String? clearIfInvisible;
  final bool? isPayload;
  final String? expression;
  final String? calculatedValue;
  final String? maxWidth;
  final bool? startWithNewLine;
  final String? dateAndTime;

  final DataBinding? dataBinding;
  final List<DataSourceMapping>? dataSourceMapping;
  final List<FormElement>? elements;
  final List<Validator>? validators;

  List<dynamic>? choices;
  dynamic defaultValue;
  final String? placeholder;

  // MATRIX SUPPORT
  final List<ColumnSchema>? columns; // For Matrix & MatrixDynamic
  final List<RowSchema>? rows; // For Matrix
  final List<Map<String, dynamic>>?
      dynamicRows; // For MatrixDynamic initial values
  final bool? allowAddRows; // For MatrixDynamic
  final bool? allowRemoveRows; // For MatrixDynamic
  final int? minRowCount; // For MatrixDynamic
  final int? maxRowCount; // For MatrixDynamic

  FormElement({
    required this.type,
    required this.name,
    this.title,
    this.requiredIf,
    this.visibleIf,
    this.readOnly,
    this.questionId,
    this.isRequired,
    this.inputType,
    this.maskType,
    this.maskSettings,
    this.visible,
    this.clearIfInvisible,
    this.isPayload,
    this.expression,
    this.calculatedValue,
    this.maxWidth,
    this.startWithNewLine,
    this.dateAndTime,
    this.dataBinding,
    this.dataSourceMapping,
    this.elements,
    this.choices,
    this.validators,
    this.defaultValue,
    this.placeholder,
    this.columns,
    this.rows,
    this.dynamicRows,
    this.allowAddRows,
    this.allowRemoveRows,
    this.minRowCount,
    this.maxRowCount,
  });

  factory FormElement.fromJson(Map<String, dynamic> json) => FormElement(
        type: json['type'] ?? '',
        name: json['name'] ?? '',
        title: json['title'],
        requiredIf: json['requiredIf'],
        visibleIf: json['visibleIf'],
        readOnly: json['readOnly'],
        questionId: json['questionId'],
        isRequired: json['isRequired'],
        inputType: json['inputType'],
        maskType: json['maskType'],
        maskSettings: json['maskSettings'] != null
            ? Map<String, dynamic>.from(json['maskSettings'])
            : null,
        visible: json['visible'],
        clearIfInvisible: json['clearIfInvisible'],
        isPayload: json['isPayload'],
        expression: json['expression'] != null
            ? json['expression'].replaceAll("\"", "")
            : "",
        calculatedValue: json['calculatedValue'],
        maxWidth: json['maxWidth'],
        startWithNewLine: json['startWithNewLine'],
        dateAndTime: json['dateAndTime'],
        dataBinding: json['dataBinding'] != null
            ? DataBinding.fromJson(json['dataBinding'])
            : null,
        dataSourceMapping: json['dataSourceMapping'] != null
            ? (json['dataSourceMapping'] as List)
                .map((e) => DataSourceMapping.fromJson(e))
                .toList()
            : null,
        elements: json['elements'] != null
            ? (json['elements'] as List)
                .map((e) => FormElement.fromJson(e))
                .toList()
            : null,
        choices: json['choices'],
        validators: json['validators'] != null
            ? (json['validators'] as List)
                .map((e) => Validator.fromJson(e))
                .toList()
            : null,
        columns: json['columns'] != null
            ? (json['columns'] as List)
                .map((e) => ColumnSchema.fromJson(e))
                .toList()
            : null,
        rows: json['rows'] != null
            ? (json['rows'] as List).map((e) => RowSchema.fromJson(e)).toList()
            : null,
        dynamicRows: json['dynamicRows'] != null
            ? List<Map<String, dynamic>>.from(json['dynamicRows'])
            : null,
        allowAddRows: json['allowAddRows'],
        allowRemoveRows: json['allowRemoveRows'],
        minRowCount: json['minRowCount'],
        maxRowCount: json['maxRowCount'],
        defaultValue: json['defaultValue'],
        placeholder: json['placeholder'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'title': title,
        'requiredIf': requiredIf,
        'visibleIf': visibleIf,
        'readOnly': readOnly,
        'questionId': questionId,
        'isRequired': isRequired,
        'inputType': inputType,
        'maskType': maskType,
        'maskSettings': maskSettings,
        'visible': visible,
        'clearIfInvisible': clearIfInvisible,
        'isPayload': isPayload,
        'expression': expression,
        'calculatedValue': calculatedValue,
        'maxWidth': maxWidth,
        'startWithNewLine': startWithNewLine,
        'dateAndTime': dateAndTime,
        'dataBinding': dataBinding?.toJson(),
        'elements': elements?.map((e) => e.toJson()).toList(),
        'choices': choices,
        'validators': validators?.map((e) => e.toJson()).toList(),
        'columns': columns?.map((e) => e.toJson()).toList(),
        'rows': rows?.map((e) => e.toJson()).toList(),
        'dynamicRows': dynamicRows,
        'allowAddRows': allowAddRows,
        'allowRemoveRows': allowRemoveRows,
        'minRowCount': minRowCount,
        'maxRowCount': maxRowCount,
        'defaultValue': defaultValue,
        'placeholder': placeholder,
      };
}

class Validator {
  final String type;
  final String? text;
  final String? expression;

  Validator({required this.type, this.text, this.expression});

  factory Validator.fromJson(Map<String, dynamic> json) => Validator(
        type: json['type'] ?? '',
        text: json['text'],
        expression: json['expression'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'text': text,
        'expression': expression,
      };
}

class ColumnSchema {
  final String name;
  final String? text;
  final String? cellType;
  final List<dynamic>? choices;
  final dynamic defaultValue;
  final bool? readOnly;
  final bool? isRequired;
  final String? dateAndTime;

  ColumnSchema({
    required this.name,
    this.text,
    this.cellType,
    this.choices,
    this.defaultValue,
    this.readOnly,
    this.isRequired,
    this.dateAndTime,
  });

  factory ColumnSchema.fromJson(Map<String, dynamic> json) => ColumnSchema(
        name: json['name'] ?? '',
        text: json['text'] ?? '',
        cellType: json['cellType'],
        choices: json['choices'],
        defaultValue: json['defaultValue'],
        readOnly: json['readOnly'],
        isRequired: json['isRequired'],
        dateAndTime: json['dateAndTime'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'text': text,
        'cellType': cellType,
        'choices': choices,
        'defaultValue': defaultValue,
        'readOnly': readOnly,
        'isRequired': isRequired,
        'dateAndTime': dateAndTime,
      };
}

class RowSchema {
  final String name;
  final String? text;
  final String? type;
  final List<dynamic>? choices;
  final dynamic defaultValue;
  final bool? readOnly;
  final bool? isRequired;
  final String? dateAndTime;

  RowSchema({
    required this.name,
    this.text,
    this.type,
    this.choices,
    this.defaultValue,
    this.readOnly,
    this.isRequired,
    this.dateAndTime,
  });

  factory RowSchema.fromJson(dynamic json) {
    if (json is String) {
      return RowSchema(name: json, text: json); // backwards compatibility
    }

    return RowSchema(
      name: json['name'],
      text: json['text'] ?? json['name'],
      type: json['type'],
      choices: json['choices'],
      defaultValue: json['defaultValue'],
      readOnly: json['readOnly'],
      isRequired: json['isRequired'],
      dateAndTime: json['dateAndTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'text': text,
        'choices': choices,
        'defaultValue': defaultValue,
        'readOnly': readOnly,
        'isRequired': isRequired,
        'dateAndTime': dateAndTime,
      };

  factory RowSchema.fromSimple(String text) {
    return RowSchema(name: text, text: text);
  }
}

class DataSourceMapping {
  final String id;
  final String event;
  final String dataSourceId;
  final List<DataMapping>? dataMapping;

  DataSourceMapping({
    required this.id,
    required this.event,
    required this.dataSourceId,
    required this.dataMapping,
  });

  factory DataSourceMapping.fromJson(Map<String, dynamic> json) =>
      DataSourceMapping(
        id: json['id'] ?? '',
        event: json['event'] ?? '',
        dataSourceId: json['dataSourceId'] ?? '',
        dataMapping: json['dataMapping'] != null
            ? (json['dataMapping'] as List)
                .map((e) => DataMapping.fromJson(e))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'event': event,
        'dataSourceId': dataSourceId,
        'dataMapping': dataMapping,
      };
}

class DataMapping {
  final int id;
  final String questionName;
  final String responseKey;
  final String type;

  DataMapping({
    required this.id,
    required this.questionName,
    required this.responseKey,
    required this.type,
  });

  factory DataMapping.fromJson(Map<String, dynamic> json) {
    return DataMapping(
      id: json['id'],
      questionName: json['questionName'] ?? '',
      responseKey: json['responseKey'],
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'questionName': questionName,
        'responseKey': responseKey,
        'type': type,
      };
}

class DataBinding {
  final String contentId;
  final String title;
  final String type;

  DataBinding({
    required this.contentId,
    required this.title,
    required this.type,
  });

  factory DataBinding.fromJson(Map<String, dynamic> json) => DataBinding(
        contentId: json['contentId'] ?? '',
        title: json['title'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'contentId': contentId,
        'title': title,
        'type': type,
      };
}

class FormMetadata {
  final int requestDate;
  final String? requestNumber;
  final String? requester;

  FormMetadata({required this.requestDate, this.requestNumber, this.requester});

  factory FormMetadata.fromJson(Map<String, dynamic> json) => FormMetadata(
        requestDate: json['requestDate'] ?? 0,
        requestNumber: json['requestNumber'],
        requester: json['requester'],
      );

  Map<String, dynamic> toJson() => {
        'requestDate': requestDate,
        'requestNumber': requestNumber,
        'requester': requester,
      };
}
