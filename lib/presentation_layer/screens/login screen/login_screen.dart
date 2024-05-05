import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:study_minder/application_layer/App_colors.dart';
import '../../../application_layer/app_images.dart';
import '../../../application_layer/app_strings.dart';
import '../../../application_layer/app_functions.dart';
import '../../../application_layer/my_icons.dart';
import '../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../widgets/default_button.dart';
import '../../widgets/default_text_form_field.dart';
import '../../widgets/loading.dart';
import '../layout/layout_screen.dart';
import '../register screen/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key})
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginScreenCubit(),
      child: BlocConsumer<LoginScreenCubit, LoginScreenStates>(
        listener: (BuildContext context, state) {
          if (state is LoginSuccessState) {
            AppStrings.uId = state.uId;
            AppStrings.name=state.name;
            CashHelper.putStringData(key: 'name', value: state.name);
            CashHelper.putStringData(key: 'uId', value: state.uId).then((value){
              AppFunctions.navigateToAndRemove(context, const LayoutScreen());
            });
            }

          if (state is LoginErrorState) {
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
        },
        builder: (BuildContext context, Object? state) {
          LoginScreenCubit cubit = LoginScreenCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loginAnimation(),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40.h),
                              loginScreenTitle(context),
                              SizedBox(height: 30.h),
                              emailLoginField(),
                              SizedBox(height: 20.h),
                              passwordLoginField(cubit),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  state is SendPasswordResetEmailLoadingState
                                      ? Padding(
                                        padding: EdgeInsets.only(top: 8.h,left: 30.w),
                                        child: const LoadingWidget(size: 30),
                                      )
                                      : forgetPasswordTextButton(context, cubit),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              state is LoginLoadingState
                                  ? const LoadingWidget()
                                  : loginButton(context, cubit),
                              noAccountRegisterNow(context),
                            ],
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

  Widget loginAnimation() {
    return Expanded(
      flex: 1,
      child: Lottie.asset(AppAnimation.loginAnimation),
    );
  }

  Widget loginScreenTitle(context) {
    return RichText(
      text: TextSpan(
        text: 'Welcome back to  ',
        style: Theme.of(context).textTheme.displaySmall,
        children: <TextSpan>[
          TextSpan(
            text: AppStrings.appName,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: AppColors.thirdColor,
                fontSize: 22,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailLoginField() {
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

  Widget passwordLoginField(LoginScreenCubit cubit) {
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

  Widget loginButton(context, LoginScreenCubit cubit) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.w),
      child: DefaultButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            cubit.loginWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
          }
        },
        child: Row(
          children: [
            Text(
              'login',
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

  Widget forgetPasswordTextButton(context, LoginScreenCubit cubit){
    return TextButton(
      onPressed: (){
        if(emailController.text.isNotEmpty){
          cubit.sendPasswordResetEmail(context, emailController.text);
        }
        else{
          AppFunctions.showSnackBar(context, 'Please enter the email', error: true);
        }
      },
      child: Text(
        'forget Password',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          decoration: TextDecoration.underline,
            color: Colors.pink,
            fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget noAccountRegisterNow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'you don\'t have an Account',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextButton(
            onPressed: () {
              AppFunctions.navigateToAndRemove(context, RegisterScreen());
            },
            child: Text(
              'Sign up here',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.w500),
            )),
      ],
    );
  }
}

