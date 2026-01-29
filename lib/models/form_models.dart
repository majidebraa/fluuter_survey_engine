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
        dataSourceType: json['dataSourceId'] ?? '',
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
  final Map<String, dynamic>? maskSettings; // new
  final bool? visible;
  final String? clearIfInvisible;
  final bool? isPayload;
  final String? expression;
  final String? calculatedValue;
  final String? maxWidth;
  final bool? startWithNewLine; // new
  final String? dateAndTime; // new

  final DataBinding? dataBinding;
  final List<DataSourceMapping>? dataSourceMapping;
  final List<FormElement>? elements;
  final List<Validator>? validators; // new

  List<dynamic>? choices;
  dynamic defaultValue;
  final String? placeholder;

  final List<ColumnSchema>? columns;
  final List<RowSchema>? rows;

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
        // This supports strings and objects
        columns: _parseColumns(json['columns']),
        rows: _parseRows(json['rows']),

        defaultValue: json['defaultValue'],
        placeholder: json['placeholder'],
      );

  static List<ColumnSchema>? _parseColumns(dynamic data) {
    if (data == null) return null;
    return (data as List).map((e) {
      if (e is String) return ColumnSchema(name: e);
      return ColumnSchema.fromJson(e);
    }).toList();
  }

  static List<RowSchema>? _parseRows(dynamic data) {
    if (data == null) return null;
    return (data as List).map((e) {
      if (e is String) return RowSchema(name: e);
      return RowSchema.fromJson(e);
    }).toList();
  }

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

  ColumnSchema({required this.name});

  factory ColumnSchema.fromJson(Map<String, dynamic> json) =>
      ColumnSchema(name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'name': name};
}

class RowSchema {
  final String name;

  RowSchema({required this.name});

  factory RowSchema.fromJson(Map<String, dynamic> json) =>
      RowSchema(name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'name': name};
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
