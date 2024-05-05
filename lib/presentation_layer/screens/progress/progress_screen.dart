import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:study_minder/application_layer/App_colors.dart';
import 'package:study_minder/application_layer/app_functions.dart';
import 'package:study_minder/presentation_layer/widgets/loading.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocProvider(
        create: (BuildContext context) => ProgressScreenCubit()
          ..getProgressData(DateFormat('yyyy-MM-dd').format(DateTime.now())),
        child: BlocBuilder<ProgressScreenCubit, ProgressScreenStates>(
          builder: (context, state) {
            if (state is GetProgressLoadingState) {
              return Center(
                child: Center(child: LoadingWidget()),
              );
            } else if (state is GetProgressSuccessState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildBarGraph(context),
              );
            } else if (state is GetProgressErrorState) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            } else {
              return Center(
                child: Text('Unknown state'),
              );
            }
          },
        ),
      ),
    );
  }

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 0,
      title: Text(
        'my progress',
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(fontWeight: FontWeight.w600, color: AppColors.thirdColor),
      ),
      leading: AppFunctions.backButton(context),
    );
  }

  Widget _buildBarGraph(BuildContext context) {
    final cubit = ProgressScreenCubit.get(context);
    final List<Map<String, dynamic>> percentageList = cubit.percentageList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: percentageList.map<Widget>((data) {
        final String date = data['date'];
        final double percentage = data['percentage'];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(date), // Display the date
              SizedBox(width: 16), // Add spacing between date and bar
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                          color: AppColors.fifthColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      alignment: Alignment.center,
                      child: percentage==0
                          ?Text(
                        '${percentage.toStringAsFixed(1)} %',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.firstColor
                        ),
                      )
                      : SizedBox(),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage / 100,
                      child: Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                            color: AppColors.secondColor,
                            borderRadius: BorderRadius.circular(20.r)),
                        alignment: Alignment.center,
                        child: Text(
                            '${percentage.toStringAsFixed(1)} %',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.firstColor
                          ),
                        ), // Display the percentage
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
