import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/components.dart';

import '../bloc/app_cubit/cubit.dart';
import '../bloc/app_cubit/states.dart';
class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.getCubit(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context , states ){},
      builder : (BuildContext context , states)=>Container(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 60, 10, 10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.green],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: Text(
                'Archive Tasks',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white),
              ),
            ),
            cubit.archiveTasks.isNotEmpty ? Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      buildTaskItem(cubit.archiveTasks[index],context),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
                  itemCount: cubit.archiveTasks.length),
            ) : const Center(
              child: Text('    No Archive Tasks Yet ', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
