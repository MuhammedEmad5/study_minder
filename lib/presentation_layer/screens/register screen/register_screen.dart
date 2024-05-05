import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../application_layer/App_colors.dart';
import '../../../application_layer/app_images.dart';
import '../../../application_layer/app_strings.dart';
import '../../../application_layer/app_functions.dart';
import '../../../application_layer/my_icons.dart';
import '../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../widgets/default_button.dart';
import '../../widgets/default_text_form_field.dart';
import '../../widgets/loading.dart';
import '../layout/layout_screen.dart';
import '../login screen/login_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterScreenCubit(),
      child: BlocConsumer<RegisterScreenCubit, RegisterScreenStates>(
        listener: (BuildContext context, state) {
          if (state is SaveUserDataSuccessState) {
            AppStrings.uId = state.uId;
            AppStrings.name=nameController.text;
            CashHelper.putStringData(key: 'name', value:nameController.text);
            CashHelper.putStringData(key: 'uId', value: state.uId)
                .then((value) {
              AppFunctions.navigateToAndRemove(context, const LayoutScreen());
            });
          }
          if (state is RegisterEmailErrorState) {
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
          if (state is SaveUserDataErrorState) {
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
        },
        builder: (BuildContext context, Object? state) {
          RegisterScreenCubit cubit = RegisterScreenCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                      child: registerAnimation()),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 15.h),
                                registerScreenTitle(context),
                                SizedBox(height: 15.h),
                                nameRegisterField(),
                                SizedBox(height: 15.h),
                                phoneRegisterField(),
                                SizedBox(height: 15.h),
                                emailRegisterField(),
                                SizedBox(height: 15.h),
                                passwordRegisterField(cubit),
                                SizedBox(height: 25.h),
                                state is RegisterEmailLoadingState
                                ? const LoadingWidget()
                                : registerButton(context, cubit),
                                SizedBox(height: 15.h),
                                noAccountRegisterNow(context)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget registerAnimation() {
    return Lottie.asset(AppAnimation.loginAnimation);
  }

  Widget registerScreenTitle(context) {
    return RichText(
      text: TextSpan(
        text: 'Create a new account on  ',
        style: Theme.of(context).textTheme.displaySmall,
        children: <TextSpan>[
          TextSpan(
            text: AppStrings.appName,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  height: 1.2,
              fontSize: 22,
              letterSpacing: 1.2,
              color: AppColors.thirdColor,
              fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget nameRegisterField() {
    return DefaultTextFormField(
      controller: nameController,
      inputType: TextInputType.name,
      labelText: 'name',
      prefixIcon: MyIcons.user1,
      validator: (value) {
        if (value!.isEmpty) {
          return 'name can\'t be Empty';
        }
        return null;
      },
    );
  }

  Widget phoneRegisterField() {
    return DefaultTextFormField(
      controller: phoneController,
      inputType: TextInputType.number,
      labelText: 'phone',
      prefixIcon: MyIcons.call,
      validator: (value) {
        if (value!.isEmpty) {
          return 'phone can\'t be empty';
        }
        if (value.length != 11) {
          return 'phone number must be 11 digits';
        }

        return null;
      },
    );
  }

  Widget emailRegisterField() {
    return DefaultTextFormField(
      controller: emailController,
      inputType: TextInputType.emailAddress,
      labelText: 'email',
      prefixIcon: MyIcons.message,
      validator: (value) {
        if (value!.isEmpty) {
          return 'email can\'t be Empty';
        }
        return null;
      },
    );
  }

  Widget passwordRegisterField(RegisterScreenCubit cubit) {
    return DefaultTextFormField(
      controller: passwordController,
      obscureText: !cubit.isPasswordVisible,
      inputType: TextInputType.emailAddress,
      labelText: 'password',
      maxLines: 1,
      prefixIcon: MyIcons.lock,
      suffixIcon: cubit.isPasswordVisible
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      suffixPressed: () {
        cubit.togglePasswordVisibility();
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'password can\'t be Empty';
        }
        return null;
      },
    );
  }

  Widget registerButton(context, RegisterScreenCubit cubit) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 90.w),
      child: DefaultButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            cubit.createNewAccount(
              email: emailController.text,
              password: passwordController.text,
              name: nameController.text,
              phone: phoneController.text,
            );
          }
        },
        child: Row(
          children: [
            Text(
              'register',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 4.w),
            Icon(
              MyIcons.login,
              color: Theme.of(context).disabledColor,
            )
          ],
        ),
      ),
    );
  }

  Widget noAccountRegisterNow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'have an account? ',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextButton(
          onPressed: () {
            AppFunctions.navigateToAndRemove(context, LoginScreen());
          },
          child: Text(
            'Log in here ',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).focusColor,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
