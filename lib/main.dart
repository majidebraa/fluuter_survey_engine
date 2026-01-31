import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'engine/expression_evaluator.dart';
import 'engine/survey_engine.dart';
import 'models/form_models.dart';
import 'widgets/survey_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Survey Engine',
      debugShowCheckedModeBanner: false,

      // ✅ Add localization delegates
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ Supported locales
      supportedLocales: const [
        Locale('fa', 'IR'), // Persian
        Locale('en', 'US'), // English
      ],

      home: const SurveyScreen(), // Replace with your survey widget
    );
  }
}

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  late TaskFormDataDto dto;
  late SurveyEngine engine;

  @override
  void initState() {
    super.initState();
    dto = TaskFormDataDto.fromJson({
      "formSchema": {
        "title": "بررسی درخواست تایید توسط رئیس/سرپرست متقاضی",
        "logoPosition": "right",
        "pages": [
          {
            "name": "صفحه1",
            "elements": [
              {
                "type": "panel",
                "name": "پنل4",
                "elements": [
                  {
                    "type": "text",
                    "name": "FULL_NAME",
                    "minWidth": "49%",
                    "maxWidth": "50%",
                    "title": " نام و نام خانوادگی",
                    "readOnly": true,
                    "isBinding": true,
                    "questionId": "9f04197f-338b-474f-b7e1-9cb1cadcd9ea",
                    "dataBinding": {
                      "title": "نام و نام خانوادگی",
                      "value": "\${CURRENT_USER.FULL_NAME}",
                      "type": "ENGINE_VARIABLE"
                    }
                  },
                  {
                    "type": "text",
                    "name": "PERSONAL_CODE",
                    "minWidth": "49%",
                    "maxWidth": "50%",
                    "startWithNewLine": false,
                    "title": "کد پرسنلی",
                    "readOnly": true,
                    "isBinding": true,
                    "questionId": "17585d94-861c-4ebc-9944-4b2e9baa0fca",
                    "dataBinding": {
                      "title": "کد پرسنلی",
                      "value": "\${CURRENT_USER.PERSONAL_CODE}",
                      "type": "ENGINE_VARIABLE"
                    }
                  }
                ]
              },
              {
                "type": "panel",
                "name": "پنل3",
                "elements": [
                  {
                    "type": "text",
                    "name": "MEMBER_NUMBER",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "تعداد نفر جهت جا به جایی",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "6a0c8a06-904e-41d1-ac69-58a16314e2f2",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 1
                    }
                  },
                  {
                    "type": "text",
                    "name": "CAUSE",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "علت جا به جایی",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "926dae30-5468-4693-8436-b2c980badf63"
                  },
                  {
                    "type": "text",
                    "name": "BUS_NUMBER",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "تعداد اتوبوس",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "7b9f4af0-ee2e-47e2-81a5-299d98e5b166",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 0
                    }
                  },
                  {
                    "type": "text",
                    "name": "MINIBUS_NUMBER",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "تعداد مینی بوس",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "464247fd-e1ef-41a1-82fa-6a63ae500aca",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 0
                    }
                  },
                  {
                    "type": "text",
                    "name": "SOURCE",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "مبدا مسیر",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "38335fe9-bd9c-4149-b28e-1262a634fde7"
                  },
                  {
                    "type": "text",
                    "name": "DESTINATION",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "مقصد مسیر",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "f9de3956-3e0d-497e-9546-7a276b3c3943"
                  },
                  {
                    "type": "date-picker",
                    "name": "DEPARTURE_TIME",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "DEPARTURE_TIME",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "c64cbee3-bc63-4062-8fb5-ef2b9e0713bd",
                    "dateAndTime": "time"
                  },
                  {
                    "type": "date-picker",
                    "name": "RETURN_TIME",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "RETURN_TIME",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "7e665dc4-c620-4132-9017-51433836dbed",
                    "dateAndTime": "time"
                  },
                  {
                    "type": "text",
                    "name": "STOP_TIME",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "مدت ساعت توقف",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "50da7327-2162-482a-9d52-006326b87189",
                    "maskType": "numeric",
                    "maskSettings": {
                      "precision": 0
                    }
                  },
                  {
                    "type": "text",
                    "name": "STOP_DAY",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "تعداد روز توقف",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "aecfb957-fd7c-4f47-acc6-b394f5c3a3e6",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 0
                    }
                  },
                  {
                    "type": "date-picker",
                    "name": "DEPARTURE_DATE",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "DEPARTURE_DATE",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "daa3b567-1631-4012-a46f-3773574417c2"
                  },
                  {
                    "type": "date-picker",
                    "name": "RETURN_DATE",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "startWithNewLine": false,
                    "title": "RETURN_DATE",
                    "isRequired": true,
                    "validators": [
                      {
                        "type": "expression",
                        "text": "تاریخ انتخابی باید بعد از تاریخ رفت باشد",
                        "expression": "{RETURN_DATE} \n=> \n{DEPARTURE_DATE}"
                      }
                    ],
                    "isBinding": true,
                    "questionId": "337c899a-8e58-411d-861d-8c91e6653280"
                  },
                  {
                    "type": "text",
                    "name": "RESPONSIBLE_NUMBER",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "شماره همراه هماهنگ کننده",
                    "isRequired": true,
                    "questionId": "06c7f4d2-b905-43d2-97ce-6dc2046b4f52",
                    "maskType": "pattern",
                    "maskSettings": {
                      "pattern": "99999999999"
                    }
                  },
                  {
                    "type": "comment",
                    "name": "DESCRIPTION",
                    "startWithNewLine": false,
                    "title": "توضیحات تکمیلی",
                    "readOnly": true,
                    "questionId": "ee8c1246-1621-4055-8f0a-28f22e1003ef"
                  }
                ]
              }
            ]
          }
        ],
        "outcomeType": [
          "SUBMIT",
          "NO",
          "ACCEPT",
          "COMPLETED",
          "OK",
          "REJECT",
          "APPROVE",
          "DEFER",
          "SendToExport"
        ]
      },
      "formData": {
        "FULL_NAME": "Majid Ebrahimi",
        "PERSONAL_CODE": "4000595",
        "RETURN_DATE": 1769977800,
        "CAUSE": "2",
        "BUS_NUMBER": 2,
        "STOP_TIME": 2,
        "MINIBUS_NUMBER": 2,
        "STOP_DAY": 2,
        "DEPARTURE_TIME": 315523860,
        "DESTINATION": "2",
        "SOURCE": "2",
        "RETURN_TIME": 315527520,
        "DEPARTURE_DATE": 1769805000,
        "MEMBER_NUMBER": 2
      },
      "isClaimed": true,
      "formMetadata": {
        "requestDate": 1769840006761,
        "requestNumber": "test_09132688114",
        "requester": "حسین آصفی"
      }
    });
    engine = SurveyEngine(dto.formSchema, evaluator: DartExpressionEvaluator());
    engine.setInitial(dto.formData);
    engine.onValidation = (errors) {
      // handle validation errors globally if needed
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survey')),
      body: SurveyRenderer(
        dto: dto,
        engine: engine,
        onOutcome: (outcome, values) {
          debugPrint('Outcome: $outcome');
          debugPrint('Form Values: $values' );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Action: $outcome اجرا شد')),
          );
        },
        onChange: (name, value) {
          debugPrint('Changed: $name = $value');
        },
      ),
    );
  }
}
