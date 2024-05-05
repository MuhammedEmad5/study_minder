import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../application_layer/App_colors.dart';
import '../../../application_layer/app_functions.dart';
import '../../../application_layer/my_icons.dart';
import '../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../../data_layer/models/user_model.dart';
import '../../widgets/default_button.dart';
import '../../widgets/loading.dart';
import '../../widgets/photo_view.dart';
import '../login screen/login_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

 final TextEditingController nameController = TextEditingController();
 final TextEditingController phoneController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>UserProfileCubit()..getUserData(),
      child: BlocConsumer<UserProfileCubit, UserProfileStates>(
        listener: (BuildContext context, state) {
          if(state is LogOutSuccessState){
            CashHelper.deleteData(key: 'uId');
            AppFunctions.navigateToAndRemove(context, LoginScreen());
          }
          if(state is LogOutErrorState){
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
          if(state is GetUserDataErrorState){
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
          if(state is UpdateUserDataErrorState){
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
          if(state is UploadProfileImageErrorState){
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
          if(state is SaveUserProfileImageInFireStoreErrorState){
            AppFunctions.showSnackBar(context, state.error, error: true);
          }
        },
        builder: (BuildContext context, Object? state) {
          UserProfileCubit cubit = UserProfileCubit.get(context);
          final userDataModel = UserProfileCubit.get(context).userDataModel;
          if (userDataModel != null) {
            nameController.text = userDataModel.name ?? '';
            phoneController.text = userDataModel.phone ?? '';
          }

          return Scaffold(
            appBar: appBar(context,cubit),
            body: cubit.userDataModel == null
                ? const Center(child: LoadingWidget())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 16.h),
                          profileImageCircleAvatar(cubit,context),
                          SizedBox(height: 16.h),
                          cubit.pickedImage == null
                              ? const SizedBox()
                              : state is UploadProfileImageLoadingState
                                  ? const LoadingWidget()
                                  : saveProfileImageButton(context,cubit),
                          cubit.pickedImage == null
                              ? const SizedBox()
                              : SizedBox(height: 16.h),
                          cubit.isOpenedToPick
                              ? cameraOrGalleryButtons(context, cubit)
                              : const SizedBox(),
                          cubit.pickedImage == null
                              ? const SizedBox()
                              : SizedBox(height: 16.h),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 80.h),
                          state is UpdateUserDataLoadingState
                              ? const LoadingWidget()
                              : saveUserChangesButton(context,cubit),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget logOutIconButton(context,UserProfileCubit cubit){
    return IconButton(
        onPressed: (){
          cubit.logOut();
        },
        icon: Icon(
          MyIcons.logout,
          color: AppColors.thirdColor,
        )
    );
  }

  AppBar appBar(context,UserProfileCubit cubit){
    return AppBar(
      titleSpacing: 15,
      title: Text(
        'Profile',
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(fontWeight: FontWeight.w600,color: AppColors.thirdColor),
      ),
      actions: [
        logOutIconButton(context,cubit),
      ],
    );
  }

  Widget cameraIconButton(UserProfileCubit cubit){
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: AppColors.thirdColor,
      child: IconButton(
        onPressed: () {
          cubit.isOpen();
        },
        icon: Icon(
          MyIcons.camera,
          size: 25.w,
          color: AppColors.white,
        ),
        splashRadius: 0.1,
      ),
    );
  }

  Widget cameraOrGalleryButtons(context,UserProfileCubit cubit){
    return Row(
      children: [
        Expanded(
          child: DefaultButton(
              onPressed: (){
                cubit.pickProfileImageFromCamera();
              },
              child: Text(
                'Camera',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w500,color: AppColors.firstColor),
              ),
          ),
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: DefaultButton(
            onPressed: (){
              cubit.pickProfileImageFromGallery();
            },
            child: Text(
              'Gallery',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w500,color: AppColors.firstColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget noProfileImageInFireStore(context,UserDataModel userDataModel) {
    return CircleAvatar(
      radius: 75.r,
      backgroundColor: AppColors.secondColor.withOpacity(0.5),
      child: ClipOval(
        child: SizedBox(
          width: 150.w,
          height: 150.h,
          child: Center(
            child: Text(
              userDataModel.name![0],
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontWeight: FontWeight.w500,color: AppColors.firstColor,fontSize: 60),
            ),
          )
        ),
      ),
    );
  }

  Widget userProfileImage(context, UserProfileCubit cubit) {
    return cubit.userDataModel!.userImage == null
        ? noProfileImageInFireStore(context,cubit.userDataModel!)
        : InkWell(
            onTap: () {
              AppFunctions.navigateTo(
                context,
                NetworkPhotoView(
                  imageUrl: cubit.userDataModel!.userImage!,
                ),
              );
            },
            child: CircleAvatar(
              radius: 75.r,
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Image.network(
                    cubit.userDataModel!.userImage!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (BuildContext context, Object object, StackTrace? stackTrace) {
                      return Text(
                        'image can\'t be loaded',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }

  Widget pickedProfileImage(context,cubit){
    return InkWell(
      onTap: () {
        AppFunctions.navigateTo(
            context,
          FilePhotoView(imageFile: cubit.pickedImage!),
        );
      },
      child: CircleAvatar(
        radius: 75.r,
        backgroundColor: Colors.grey,
        child: ClipOval(
          child: SizedBox(
            width: 150.w,
            height: 150.h,
            child: Image.file(
              cubit.pickedImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImageCircleAvatar(UserProfileCubit cubit,context){
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          cubit.pickedImage == null
              ? userProfileImage(context, cubit)
              : pickedProfileImage(context, cubit),
          cameraIconButton(cubit),
        ],
      ),
    );
  }

  Widget saveProfileImageButton(context,UserProfileCubit cubit){
    return DefaultButton(
      onPressed: () {
        cubit.upLoadProfileImage().then((value) {
          cubit.pickedImage=null;
        });
      },
      child: Text(
        'Save Profile Image',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w500,color: AppColors.firstColor),
      ),
    );
  }

  Widget saveUserChangesButton(context,UserProfileCubit cubit){
    return Padding(
      padding: const EdgeInsets.only(left: 150.0),
      child: DefaultButton(
        onPressed: () {
          cubit.updateUserData(name: nameController.text, phone: phoneController.text);
        },
        child: Text(
          'Save',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w500,color: AppColors.firstColor),
        ),
      ),
    );
  }

  Widget deleteProfileImageIconButton(UserProfileCubit cubit){
    return IconButton(
      onPressed: () {
        cubit.deleteProfileImage();
      },
      icon: Icon(
        Icons.delete,
        size: 30.sp,
        color: AppColors.thirdColor,
      ),
    );
  }

}
