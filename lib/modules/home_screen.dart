import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todoapp/bloc/app_cubit/cubit.dart';
import 'package:todoapp/bloc/app_cubit/states.dart';
import 'package:todoapp/shared/components/components.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController tasksController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, states) {},
          builder: (BuildContext context, states) {
            AppCubit cubit = AppCubit.getCubit(context);
            return Scaffold(
              key: scaffoldKey,
              body: cubit.pages[cubit.currentPage],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    Navigator.pop(context);
                    cubit.changeBottomSheet(icon: Icons.edit, isShow: false);
                  } else {
                    tasksController.text = '';
                    timeController.text = '';
                    dateController.text = '';
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) {
                            return Container(
                              color: Colors.grey[200],
                              padding: const EdgeInsetsDirectional.only(
                                  top: 20, end: 20, start: 20, bottom: 10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 8.0),
                                      child: defaultTextForm(
                                        label: 'Task Title',
                                        prefixIcon: Icons.title,
                                        controller: tasksController,
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Tasks is Empty';
                                          }
                                          return null;
                                        },
                                        textInputType: TextInputType.text,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 12.0),
                                      child: defaultTextForm(
                                        label: 'Task Time',
                                        onTap: () {
                                          showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            builder: (context,child){
                                                return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false,boldText: true,), child: child!);
                                            }
                                          ).then((value) {
                                            timeController.text = value!.format(context);   // 21:12

                                          });
                                        },
                                        prefixIcon: Icons.more_time_outlined,
                                        controller: timeController,
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Time is Empty';
                                          }
                                          return null;
                                        },
                                        textInputType: TextInputType.none,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 12.0),
                                      child: defaultTextForm(
                                        label: 'Task Date',
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(value!);
                                          });
                                        },
                                        prefixIcon: Icons.date_range_outlined,
                                        controller: dateController,
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Date is Empty';
                                          }
                                          return null;
                                        },
                                        textInputType: TextInputType.none,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 12.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            color: Colors.blue),
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit
                                                  .insertDatabase(
                                                title: tasksController.text
                                                    .toString(),
                                                time: timeController.text
                                                    .toString(),
                                                date: dateController.text
                                                    .toString(),
                                              )
                                                  .then((value) {
                                                Navigator.pop(context);
                                                cubit.changeBottomSheet(
                                                    icon: Icons.edit,
                                                    isShow: false);
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Add Task',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          elevation: 20,
                        )
                        .closed
                        .then((value) {
                          cubit.changeBottomSheet(
                              icon: Icons.edit, isShow: false);
                          // علشان لما اقفل الشيت بايدي يبقي زي ما اقفله بالبوتون
                        });
                    cubit.changeBottomSheet(
                        icon: Icons.close_outlined, isShow: true);
                  }
                },
                child: Icon(cubit.iconBottomSheet),
              ),
              bottomNavigationBar: BottomNavigationBar(
                elevation: 10,
                currentIndex: cubit.currentPage,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 14,
                onTap: (index) {
                  cubit.changeNavBar(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done_outline_outlined), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archive')
                ],
              ),
            );
          }),
    );
  }
}
