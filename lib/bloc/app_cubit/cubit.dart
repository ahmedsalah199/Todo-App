import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/bloc/app_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/network/local/local_notification.dart';

import '../../modules/archive_screen.dart';
import '../../modules/done_screen.dart';
import '../../modules/tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit getCubit(context) => BlocProvider.of(context);
  int currentPage = 0;
  List<Widget> pages = [
    TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen(),
  ];

  void changeNavBar(index) {
    currentPage = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map<String, dynamic>> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  Future<void> createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
      try {
        await database.execute(
            'CREATE TABLE todo (id INTEGER PRIMARY KEY , title TEXT , date TEXT ,time TEXT , status TEXT)');
        print('table created');
      } catch (error) {
        print('Error When Creating DataBase ${error.toString()}');
      }
      emit(AppCreateDatabaseState());
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('DataBase opened');
    });
  }

  Future insertDatabase(
      {required String title,
      required String time,
      required String date}) async {
    try {
      await database!.transaction((txn) async {
        txn
            .rawInsert(
                'INSERT INTO todo (title,time,date,status) VALUES ("$title","$time","$date","new")')
            .then((value) {
          emit(AppInsertDatabaseState());
          print('inserted Successfully');
          getDataFromDatabase(database!);
        });
        return null;
      });
    } catch (error) {
      print('Error When Inserting New Data ${error.toString()}');
    }
  }

  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database.rawQuery("SELECT * FROM todo").then((value) {
      for (var element in value) {
        if (element['status'] == "new") {
          newTasks.add(element);
          String strDate = element['date'].toString();
          var date = strDate.split('-');
          String strTime = element['time'].toString();
          var isAm = strTime.contains('AM');
          var replaceAmAndPm =
              strTime.replaceAll('PM', '').replaceAll('AM', '');
          var time = replaceAmAndPm.split(':');
          //   كل ال فوق ده علشان التاريخ جاي نص وعايز افصل كل حاجة لوحدها
          NotificationServices().displayNotification(
              id: int.parse(element['id'].toString()),
              title: element["title"].toString(),
              dateTime: DateTime(
                  int.parse(date[0]),
                  int.parse(date[1]),
                  int.parse(date[2]),
                  strTime.contains('AM') ? int.parse(time[0].toString().padLeft(0)) : strTime.contains('PM') ?
                  int.parse(time[0]) + 12 : int.parse(time[0]),
                  int.parse(time[1])));
        } else if (element["status"] == "done") {
          doneTasks.add(element);
        } else if (element["status"] == "archive") {
          archiveTasks.add(element);
        }
        emit(AppGetDatabaseState());
        print('New Tasks  $newTasks');
        print('Done Tasks  $doneTasks');
        print('Archive Tasks  $archiveTasks');
      }
    });
  }

  bool isBottomSheetShown = false;
  IconData iconBottomSheet = Icons.edit;

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
  }) {
    iconBottomSheet = icon;
    isBottomSheetShown = isShow;
    emit(AppChangeBottomSheetState());
  }

  updateData(status, id) {
    database!
        .rawUpdate('UPDATE todo SET status ="$status"  WHERE id = "$id"')
        .then((value) {
      emit(AppUpdateDatabaseState());
      print("Update Database Success");
      getDataFromDatabase(database!);
    });
  }

  deleteData(id) async {
    database!.rawDelete('DELETE FROM todo WHERE id = "$id"').then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database!);
    });
  }
}
