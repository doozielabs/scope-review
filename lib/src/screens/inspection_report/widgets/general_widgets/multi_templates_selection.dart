import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/inspection_report.dart';

class MultiTemplatesSelection extends StatefulWidget {
  final List<Template> templates;
  final Template? selectedTemplate;
  final Function(int val)? switchServiceMethod;
  const MultiTemplatesSelection(
      {Key? key,
      required this.templates,
      this.switchServiceMethod,
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
      widget.templates.forEach((element) {
        if (widget.selectedTemplate!.id == element.id) {
          _currVal = widget.templates.indexOf(element);
        }
      });
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
    final List<Template> templates = widget.templates;
    return
        // Expanded(
        //     flex: 1,
        //     child:
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: ProjectColors.aliceBlue,
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: Offset(0, 7),
                      ),
                    ],
                    color: ProjectColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Switch Services",
                              style: h1,
                            ),
                            const SizedBox(height: 18),

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
                            for (var i = 0; i < templates.length; i++)
                              RadioListTile(
                                title: Text(templates[i].name),
                                groupValue: _currVal,
                                value: i,
                                onChanged: (val) {
                                  setState(() {
                                    _currVal = i;
                                    // _currText = templates[i].name;
                                    setSelectedRadioTile(i);
                                    widget.switchServiceMethod?.call(i);
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
                          ])))
            ]));
    // );
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     DropdownButton(
    //       // Initial Value
    //       value: dropdownvalue,

    //       // Down Arrow Icon
    //       icon: const Icon(Icons.keyboard_arrow_down),

    //       // Array list of items
    //       items: items.map((String items) {
    //         return DropdownMenuItem(
    //           value: items,
    //           child: Text(items),
    //         );
    //       }).toList(),
    //       // After selecting the desired option,it will
    //       // change button value to selected value
    //       onChanged: (String? newValue) {
    //         setState(() {
    //           dropdownvalue = newValue!;
    //         });
    //       },
    //     ),
    //   ],
    // );
  }
}
