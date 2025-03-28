import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class MultiTemplatesSelection extends StatefulWidget {
  final List<Template> templates;
  final Template? selectedTemplate;
  final bool? web;
  final Function(int val)? switchServiceMethod;
  const MultiTemplatesSelection(
      {Key? key,
      required this.templates,
      this.switchServiceMethod,
      this.web,
      this.selectedTemplate})
      : super(key: key);

  @override
  _MultiTemplatesSelectionState createState() =>
      _MultiTemplatesSelectionState();
}

class _MultiTemplatesSelectionState extends State<MultiTemplatesSelection> {
  int _currVal = 0;

  setSelectedRadioTile(int val) {
    setState(() {
      _currVal = val;
    });
  }

  @override
  void initState() {
    if (widget.selectedTemplate != null) {
      for (var element in widget.templates) {
        if (widget.selectedTemplate!.id == element.id) {
          _currVal = widget.templates.indexOf(element);
        }
      }
    }
    super.initState();
  }

  // @override
  // void didUpdateWidget(oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   setState(() {
  //     // final index1 = widget.templates
  //     //     .indexWhere((element) => element.uid == widget.selectedTemplate!.uid);
  //     // _currVal = index1;
  //     print(
  //         "$_currVal MultiTemplatesSelection didUpdateWidget ${widget.selectedTemplate!.sections[0].name}");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final List<Template> templates =
        GeneralHelper.sortTemplatesByBase(widget.templates);
    var paddingValue = 0.0;
    widget.web.isNull ? paddingValue = 10.0 : paddingValue = 0.0;
    return
        // Expanded(
        //     flex: 1,
        //     child:
        Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: widget.web.isNull
                            ? Colors.transparent
                            : ProjectColors.aliceBlue,
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: const Offset(0, 7),
                      ),
                    ],
                    color: ProjectColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 0.0, left: 3, right: 3),
                        child: Text("Switch Reports",
                            style: h1.copyWith(
                                color: ProjectColors.black, fontSize: 14)),
                      ),
                      // const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 16.0, left: 3, right: 3),
                        child: SizedBox(
                          height: (templates.length == 2)
                              ? 90
                              : (templates.length == 3)
                                  ? 120
                                  : 150,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: true),
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    // top: 16.0, bottom: 20.0, left: 3, right: 3),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // RadioListTile(
                                          //   title: Text("${templates[0].name}   -- "),
                                          //   groupValue: _currVal,
                                          //   value: 1,
                                          //   onChanged: (val) {
                                          //     setState(() {
                                          //       _currVal = 1;
                                          //       _currText = "name -- ";
                                          //     });
                                          //   },
                                          // ),

                                          // for (var t in templates)
                                          for (var i = 0;
                                              i < templates.length;
                                              i++)
                                            RadioListTile(
                                              dense: true,
                                              activeColor:
                                                  ProjectColors.firefly,
                                              title: Transform.translate(
                                                  offset: const Offset(-20, 0),
                                                  child: Text(
                                                    templates[i].name,
                                                    style: b3Regular.copyWith(
                                                      color:
                                                          ProjectColors.primary,
                                                    ),
                                                  )),
                                              groupValue: _currVal,
                                              value: i,
                                              onChanged: (val) {
                                                setState(() {
                                                  _currVal = i;
                                                  setSelectedRadioTile(i);
                                                  widget.switchServiceMethod
                                                      ?.call(i);
                                                });
                                              },
                                            ),

                                          // Container(child :
                                          // if (templates != null) {
                                          //   templates.map((e){
                                          //                           Text(e.name);
                                          //   // return {
                                          //   //         "name": e.name,
                                          //   //         "rollno": e.rollno,
                                          //   //         "age": e.age,
                                          //   //         "marks": e.marks
                                          //   //     };
                                          // }).toList();
                                          // }

                                          // )

                                          // templates.map((t) => Text(t.name) ).toList();

                                          // templates.map((t) => RadioListTile(
                                          //       title: Text("${t.name}"),
                                          //       groupValue: _currVal,
                                          //       value: t.index,
                                          //       onChanged: (val) {
                                          //         setState(() {
                                          //           _currVal = val.index;
                                          //           _currText = t.name;
                                          //         });
                                          //       },
                                          //     ))
                                          // .toList(),

                                          // RadioListTile<InspectionModel>(
                                          //   title: const Text('Lafayette'),
                                          //   value: widget.inspection,
                                          //   groupValue: _character,
                                          //   onChanged: (SingingCharacter? value) {
                                          //     setState(() {
                                          //       // _character = value;
                                          //     });
                                          //   },
                                          // ),
                                        ])),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ]));
  }
}
