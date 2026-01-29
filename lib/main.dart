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
                    "type": "dropdown",
                    "name": "FULL_NAME",
                    "minWidth": "49%",
                    "maxWidth": "50%",
                    "title": "FULL_NAME",
                    "isBinding": true,
                    "isRequired": true,
                    "questionId": "a1788b94-0e3f-4e66-ad6b-21fdd078feb5",
                    "dataBinding": {
                      "title": "نام و نام خانوادگی",
                      "value": "\${CURRENT_USER.FULL_NAME}",
                      "type": "ENGINE_VARIABLE",
                    },
                    "dataSourceMapping": [
                      {
                        "id": "cd6577c9-adea-48d3-b73c-c4915c3939ee",
                        "event": "onOpened",
                        "dataSourceId": "b08a0a80-e22e-4cd5-bceb-8b4ede48ab73",
                        "dataMapping": [
                          {
                            "id": 1,
                            "questionName": "FULL_NAME",
                            "responseKey":
                                "{\"text\":\"response[i].BUYER_FULL_NAME\",\"value\":\"response[i].BUYER_EMPLOYEE_NUMBER\"}",
                            "type": "questionName",
                          },
                        ],
                      },
                    ],
                    "choices": ["Item 1", "Item 2", "Item 3"],
                  },
                  {
                    "type": "text",
                    "name": "PERSONAL_CODE",
                    "minWidth": "49%",
                    "maxWidth": "50%",
                    "startWithNewLine": false,
                    "title": "شماره قرارداد",
                    "isBinding": true,
                    "questionId": "2cb08934-aced-4b13-8fd4-5bd954cc883a",
                    "dataBinding": {
                      "title": "کد پرسنلی",
                      "value": "\${CURRENT_USER.PERSONAL_CODE}",
                      "type": "ENGINE_VARIABLE",
                    },
                    "dataSourceMapping": [
                      {
                        "id": "19b63f53-977d-4c70-ab1e-ef684b16f8ee",
                        "event": "onChange",
                        "dataSourceId": "b08a0a80-e22e-4cd5-bceb-8b4ede48ab73",
                        "dataMapping": [
                          {
                            "id": 1,
                            "questionName": "vendoer",
                            "responseKey": "response[0].VENDOR_NAME",
                            "type": "questionName",
                          },
                          {
                            "id": 2,
                            "questionName": "bu",
                            "responseKey": "response[0].BU",
                            "type": "questionName",
                          },
                        ],
                      },
                    ],
                  },
                  {
                    "type": "text",
                    "name": "vendoer",
                    "title": "آیتم2",
                    "questionId": "3f9a8713-4c11-48e3-b115-d52ac16090d6",
                  },
                  {
                    "type": "text",
                    "name": "bu",
                    "startWithNewLine": false,
                    "title": "آیتم1",
                    "questionId": "f33ab69d-6e1e-472f-9237-6972927be9a8",
                  },
                ],
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
                    "questionId": "36477c48-bdb3-4c6e-8ed1-988a443df26e",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 1,
                    },
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
                    "questionId": "fb7063ec-031a-4542-870b-cd935e428297",
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
                    "questionId": "0bf36849-c3ca-4804-a488-5e2d71ac2177",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 0,
                    },
                  },
                  {
                    "type": "text",
                    "name": "MINIBUS_NUMBER",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "تعداد مینی بوس",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "dfff24aa-74cd-425f-982e-35ba9afc1cff",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 0,
                    },
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
                    "questionId": "649d7aed-2808-48c7-bd2e-b32acba18899",
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
                    "questionId": "e0b9fc61-1c72-4868-9d25-ea99911d83d9",
                  },
                  {
                    "type": "date-picker",
                    "name": "DEPARTURE_TIME",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "DEPARTURE_TIME",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "7a335be5-eb33-4cd6-83bd-4f255ed60ab7",
                    "dateAndTime": "time",
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
                    "questionId": "10670cb7-0c17-4c77-a351-ebfeec32b924",
                    "dateAndTime": "time",
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
                    "questionId": "62ea8fa9-af6f-4669-8a45-e8370ccf65fd",
                    "maskType": "numeric",
                    "maskSettings": {"precision": 0},
                  },
                  {
                    "type": "text",
                    "name": "STOP_DAY",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "تعداد روز توقف",
                    "isRequired": true,
                    "isBinding": true,
                    "questionId": "35d34afa-d32c-40cd-b62e-734216d4ade3",
                    "maskType": "numeric",
                    "maskSettings": {
                      "allowNegativeValues": false,
                      "precision": 0,
                      "min": 0,
                    },
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
                    "questionId": "7f7f8b4a-f909-4a73-8d6d-8beba7376bcd",
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
                        "expression": "{RETURN_DATE} \n=> \n{DEPARTURE_DATE}",
                      },
                    ],
                    "isBinding": true,
                    "questionId": "1bb55958-a6fb-4fd6-ad75-973a42fe38ba",
                  },
                  {
                    "type": "text",
                    "name": "RESPONSIBLE_NUMBER",
                    "minWidth": "30%",
                    "maxWidth": "33%",
                    "title": "شماره همراه هماهنگ کننده",
                    "isRequired": true,
                    "questionId": "c977a669-9986-4b3f-84bf-63be52b934d8",
                    "maskType": "pattern",
                    "maskSettings": {"pattern": "99999999999"},
                  },
                  {
                    "type": "comment",
                    "name": "DESCRIPTION",
                    "startWithNewLine": false,
                    "title": "توضیحات تکمیلی",
                    "readOnly": true,
                    "questionId": "282becda-4159-4389-8643-194e2f67776d",
                  },
                ],
              },
              {
                "type": "expression",
                "name": "_requestId",
                "title": "_requestId",
                "clearIfInvisible": "none",
                "isPayload": true,
                "questionId": "8425bbdd-17e3-484d-ab8c-194d05fb37cf",
                "dataBinding": {
                  "title": "شناسه یکتا",
                  "value": "\${UNIQUE_RANDOM_CODE}",
                  "type": "ENGINE_VARIABLE",
                },
              },
              {
                "type": "expression",
                "name": "_requestNumber",
                "startWithNewLine": false,
                "title": "_requestNumber",
                "clearIfInvisible": "none",
                "isPayload": true,
                "questionId": "f0957faa-6a83-4d62-8124-2e407c4672d6",
                "dataBinding": {
                  "title": "شناسه یکتا",
                  "value": "\${UNIQUE_RANDOM_CODE}",
                  "type": "ENGINE_VARIABLE",
                },
                "expression": "\"test_\"+{RESPONSIBLE_NUMBER}",
              },
              {
                "type": "expression",
                "name": "_requestTitle",
                "visible": false,
                "startWithNewLine": false,
                "title": "_requestTitle",
                "clearIfInvisible": "none",
                "isPayload": true,
                "questionId": "47afbc26-88f3-4faf-ab70-11f44bdbc50d",
                "expression": "test",
              },
            ],
          },
        ],
        "outcomeType": ["SUBMIT"],
        "dataSources": [
          {
            "title": "users",
            "dataSourceId": "b08a0a80-e22e-4cd5-bceb-8b4ede48ab73",
            "dataSourceType": "REST_API",
            "RestApi_Header": [],
            "RestApi_Url":
                "https://em-stage.irisaco.com/dis/api/public/v2.0/proxy?pn=IRISA_PO_CONTRACT_INFO_V&page=0&size=500000",
            "bodyType": "Json",
            "RestApi_Method": "POST",
            "RestApi_JsonBody":
                "{\r\n \"filter\": {\r\n \"PO_NUMBER\": \"\${PERSONAL_CODE}\"\r\n }\r\n}",
          },
        ],
      },
      "formData": {
        "FULL_NAME": "Majid Ebrahimi",
        "PERSONAL_CODE": "4000595",
        "_requestId": "140410307826",
        "_requestNumber": "140410306485",
      },
      "isClaimed": true,
      "formMetadata": {
        "requestDate": 1768918207359,
        "requestNumber": null,
        "requester": "مجید ابراهیمی افارانی",
      },
    });
    engine = SurveyEngine(dto.formSchema, evaluator: DartSafeEvaluator());
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
        onSubmit: (values) {
          debugPrint('Submitted: ' + jsonEncode(values));
          debugPrint('Submitted: ' + jsonEncode(values));
        },
        onChange: (name, value) {
          debugPrint('Changed: $name = $value');
        },
      ),
    );
  }
}
