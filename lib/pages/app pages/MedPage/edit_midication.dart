import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:project_8_team3/data/model/medicattion_model.dart';
import 'package:project_8_team3/data/service/supabase_services.dart';
import 'package:project_8_team3/helper/colors.dart';
import 'package:project_8_team3/helper/extintion.dart';
import 'package:project_8_team3/helper/sized.dart';
import 'package:project_8_team3/pages/app%20pages/bloc/data_bloc.dart';
import 'package:project_8_team3/widgets/button_widget.dart';
import 'package:project_8_team3/widgets/custom_widget.dart';
import 'package:project_8_team3/widgets/dropdown_Container_widget.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class EditMedicationPage extends StatelessWidget {
  const EditMedicationPage({super.key, required this.medication});
  final MedicationModel medication;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController.text = medication.medicationName;
    DateTime dateTime = DateTime.now();
    final bloc = context.read<DataBloc>();
    final locator = GetIt.I.get<DBService>();
    locator.days = medication.days;
    locator.pill = medication.pills;
    // bloc.selectedTime = DateTime.parse(medication.time);
    // bloc.selectedTimeText = DateFormat.jm().format(bloc.selectedTime);
    return BlocConsumer<DataBloc, DataState>(
      listener: (context, state) {
        if (state is SuccessEditingState) {
          context.popNav();
          context.showSuccessSnackBar(context, "تم تعديل بيانات الدواء");
          locator.days = 0;
          locator.pill = 0;
          locator.counts = 0;
          bloc.seletctedType = 0;
        }
        if (state is ErrorEditState) {
          context.showErrorSnackBar(context, "هناك مشكلة حاول مجددا");
          locator.days = 0;
          locator.pill = 0;
          locator.counts = 0;
          bloc.seletctedType = 0;
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leadingWidth: 80,
              leading: const CustomAppBar(),
            ),
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "تعديل الدواء",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  gapH50,
                  const Text(
                    "اسم الدواء",
                    style: TextStyle(fontSize: 15),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      icon: Image.asset('assets/images/medIcon.png'),
                      hintText: "اكتب.....",
                      filled: true,
                      fillColor: greyColor,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: transparent),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: transparent),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  gapH60,
                  const Text(
                    "كم حبة باليوم و مدة الدواء",
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    children: [
                      DropDownWidget(
                        title: "يوم",
                        path: 'assets/images/calendar-fill 2.png',
                        type: "days",
                        page: 2,
                      ),
                      gapH15,
                      DropDownWidget(
                        title: "حبة",
                        path: 'assets/images/calendar-fill 1.png',
                        type: "pill",
                        page: 2,
                      ),
                    ],
                  ),
                  gapH40,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            bloc.add(ChangeTypeEvent(num: 1));
                          },
                          child: Row(
                            children: [
                              Radio(
                                fillColor: MaterialStatePropertyAll(
                                    textfieldGreenColor),
                                value: 1,
                                groupValue: bloc.seletctedType,
                                onChanged: (_) {
                                  bloc.add(ChangeTypeEvent(num: 1));
                                },
                              ),
                              const Text("قبل الاكل"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            bloc.add(ChangeTypeEvent(num: 2));
                          },
                          child: Row(
                            children: [
                              Radio(
                                fillColor: MaterialStatePropertyAll(
                                    textfieldGreenColor),
                                value: 2,
                                groupValue: bloc.seletctedType,
                                onChanged: (_) {
                                  bloc.add(ChangeTypeEvent(num: 2));
                                },
                              ),
                              const Text(" بعد الاكل"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH40,
                  const Text(
                    "اشعارات",
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: TimePickerSpinner(
                                          locale: const Locale('en', ''),
                                          time: dateTime,
                                          is24HourMode: false,
                                          itemHeight: 80,
                                          normalTextStyle: const TextStyle(
                                            fontSize: 24,
                                          ),
                                          highlightedTextStyle: TextStyle(
                                            fontSize: 24,
                                            color: greenText,
                                          ),
                                          isForce2Digits: true,
                                          onTimeChange: (time) {
                                            bloc.add(
                                                ChangeTimeEvent(time: time));
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(dateTime);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  bloc.selectedTimeText.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Icon(
                                Icons.notifications,
                                color: darkgreyColor,
                              )
                            ]),
                      )),
                  // const Spacer(),
                  ButtonWidget(
                    backgroundColor: textfieldGreenColor,
                    onPressed: () {
                      bloc.add(EditMedicationEvent(
                          name: nameController.text, med: medication));
                    },
                    text: "حفظ",
                    textColor: whiteColor,
                  ),
                  gapH10,
                  ButtonWidget(
                    backgroundColor: whiteColor,
                    onPressed: () {
                      bloc.add(DeleteMedicationEvent(
                          medID: medication.medicationId));
                    },
                    text: "حذف",
                    textColor: textgreyColor,
                    borderColor: textfieldGreenColor,
                  ),
                ],
              ),
            )));
      },
    );
  }
}
