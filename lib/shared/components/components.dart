import 'package:flutter/material.dart';
import 'package:todoapp/bloc/app_cubit/cubit.dart';

Widget defaultTextForm({
  required String label,
  required IconData prefixIcon,
  VoidCallback? onTap,
  IconData? suffixIcon,
  required TextEditingController controller,
  required String? Function(String?) validate,
  Function(String)? onChanged,
  required TextInputType textInputType,
  bool isObscure = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isObscure,
    validator: validate,
    keyboardType: textInputType,
    onTap: onTap,
    onChanged: onChanged,
    decoration: InputDecoration(
      label: Text(label),
      border: const OutlineInputBorder(),
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
    ),
  );
}

Container buildTaskItem(Map tasks, context) {
  AppCubit cubit = AppCubit.getCubit(context);
  return Container(
    height: 166,
    padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 10),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
        children: [
      SizedBox(
        height: 50,
        child: Text(
          '${tasks["title"]}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(height: 4,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 2,
              child: ListTile(
                title: Text(
                  '${tasks["date"]}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.redAccent),
                ),
                leading: const Icon(Icons.date_range_outlined),
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.all(0),
              )),
          Expanded(
              child: ListTile(
                title: Text(
                  '${tasks["time"]}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.redAccent),
                ),
                leading: const Icon(Icons.access_time_outlined),
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: -4,
              )),
        ],
      ),
      Expanded(
        child: Row(
          mainAxisAlignment:
          cubit.currentPage == 0 ? MainAxisAlignment.spaceAround : cubit.currentPage == 1 ? MainAxisAlignment.spaceEvenly :MainAxisAlignment.center,
          children: [
            cubit.currentPage == 0 ? IconButton(
                onPressed: () {
                  cubit.updateData("done", tasks["id"]);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                  size: 30,
                )) : Container(),
            cubit.currentPage == 0 || cubit.currentPage == 1
                ? IconButton(
                onPressed: () {
                  cubit.updateData("archive", tasks["id"]);
                },
                icon: const Icon(Icons.archive, color: Colors.green, size: 30))
                : Container(),
            cubit.currentPage == 0 || cubit.currentPage == 1 ||
                cubit.currentPage == 2
                ? IconButton(
                onPressed: () {
                  cubit.deleteData(tasks["id"]);
                },
                icon: const Icon(Icons.delete, color: Colors.green, size: 30))
                : Container(),
          ],
        ),
      )
    ]),
  );
}
String getGreeting(DateTime dateTime) {
  if (dateTime.hour >= 4 && dateTime.hour < 12) {
    return "Good Morning ! \n It's a ToDo Time ";
  } else if (dateTime.hour >= 12 && dateTime.hour < 18) {
    return "Good Afternoon ! \n It's a ToDo Time ";
  } else {
    return "Good Evening ! \n It's a ToDo Time ";
  }
}
