import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vip_connect/constants.dart';
import 'package:vip_connect/helper/app_colors.dart';
import 'package:vip_connect/helper/app_text_styles.dart';
import 'package:vip_connect/screens/components/spacer.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.mainTitle,
    this.hideMainTitle,
    this.labelText,
    this.initialText,
    this.iconPrefixData,
    this.iconSuffixData,
    this.hintText,
    this.prefixText,
    this.textInputType,
    this.inputFormatters,
    required this.onSaved,
    required this.validator,
    this.onTap,
    this.readOnly,
    this.obscureText,
    this.enabled,
    this.suffixOnTap,
    this.controller,
    this.autoValidateMode,
    this.onChanged,
    this.maxLines,
    this.height,
    this.disableBorder,
    this.fillColor,
    this.filled,
    this.textStyle,
    this.hintTextStyle,
    this.cursorColor,
    this.autoFocused,
    this.onFieldSubmit,
    this.prefixWidget,
    this.isWeb,
  }) : super(key: key);
  final String mainTitle;
  final bool? hideMainTitle;
  final String? labelText;
  final String? initialText;
  final String? iconPrefixData, iconSuffixData;
  final Widget? prefixWidget;
  final String? hintText;
  final String? prefixText;
  final TextInputType? textInputType;
  final int? maxLines;
  final double? height;
  final TextStyle? textStyle, hintTextStyle;
  final List<TextInputFormatter>? inputFormatters;
  bool? readOnly,
      obscureText,
      enabled,
      disableBorder,
      filled,
      autoFocused,
      isWeb;
  final String? Function(String?)? validator;
  // FormFieldValidator<String>? validator;
  FormFieldSetter<String>? onSaved, onFieldSubmit;
  VoidCallback? onTap;
  VoidCallback? suffixOnTap;
  TextEditingController? controller;
  AutovalidateMode? autoValidateMode;
  void Function(String? text)? onChanged;
  final Color? fillColor, cursorColor;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return widget.isWeb ?? false

        /// For Web
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hideMainTitle == null || widget.hideMainTitle == false)
                Text(
                  widget.mainTitle,
                  style: AppTextStyle.web2.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (widget.hideMainTitle == null || widget.hideMainTitle == false)
                VerticalSpacer(height: 10.h),
              SizedBox(
                height: widget.maxLines != null && widget.maxLines! > 1
                    ? null
                    : 56.h,
                child: TextFormField(
                  maxLines:
                      widget.obscureText ?? false ? 1 : widget.maxLines ?? 1,
                  enabled: widget.enabled,
                  initialValue: widget.initialText,
                  controller: widget.controller,
                  style: widget.textStyle ?? AppTextStyle.bodyRegularWeb,
                  obscureText:
                      (widget.obscureText ?? false) ? hidePassword : false,
                  onChanged: widget.onChanged,
                  cursorColor: widget.cursorColor ?? AppColors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: widget.textInputType,
                  inputFormatters: widget.inputFormatters,
                  autofocus: widget.autoFocused ?? false,
                  decoration: InputDecoration(
                    fillColor: widget.fillColor,
                    filled: widget.filled,
                    focusedBorder: widget.disableBorder == true
                        ? null
                        : OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius:
                                BorderRadius.circular(kBorderRadius20),
                          ),
                    hintStyle: widget.hintTextStyle ??
                        AppTextStyle.bodyRegularWeb
                            .copyWith(color: AppColors.hintText),
                    // contentPadding: EdgeInsets.symmetric(
                    //     horizontal: 10.w,
                    //     vertical: (widget.prefixWidget != null &&
                    //             widget.maxLines != null)
                    //         ? 0
                    //         : 10.h),
                    enabledBorder: widget.disableBorder == true
                        ? null
                        : OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius:
                                BorderRadius.circular(kBorderRadius20),
                          ),
                    border: widget.disableBorder == true
                        ? InputBorder.none
                        : OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius:
                                BorderRadius.circular(kBorderRadius20),
                          ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                      ),
                    ),
                    errorStyle:
                        AppTextStyle.h3Web.copyWith(color: AppColors.red),
                    alignLabelWithHint: true,
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    prefixText: widget.prefixText,
                    suffixIcon: widget.obscureText ?? false
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 0),
                            child: IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    if (hidePassword) {
                                      hidePassword = false;
                                    } else {
                                      hidePassword = true;
                                    }
                                  },
                                );
                              },
                              splashRadius: kBorderRadius20,
                              iconSize: 24.h,
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.secondary,
                              ),
                              color: AppColors.primary,
                            ),
                          )
                        : widget.iconSuffixData != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: IconButton(
                                  onPressed: widget.suffixOnTap ?? () {},
                                  splashRadius: kBorderRadius20,
                                  icon: Image.asset(
                                    widget.iconSuffixData!,
                                    height: 20.h,
                                    width: 20.h,
                                    color: AppColors.primary,
                                  ),
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                    prefixIcon: widget.iconPrefixData != null &&
                            widget.prefixWidget == null
                        ? IconButton(
                            onPressed: widget.suffixOnTap ?? () {},
                            splashRadius: kBorderRadius20,
                            icon: Image.asset(
                              widget.iconPrefixData!,
                              height: 20.h,
                              width: 20.h,
                              color: AppColors.primary,
                            ),
                            color: AppColors.primary,
                          )
                        : widget.prefixWidget,
                  ),
                  readOnly: widget.readOnly ?? false,
                  onSaved: widget.onSaved,
                  validator: widget.validator,
                  onTap: widget.onTap,
                  onFieldSubmitted: widget.onFieldSubmit,
                ),
              ),
            ],
          )

        /// For Mobile
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hideMainTitle == null || widget.hideMainTitle == false)
                Text(
                  widget.mainTitle,
                  style: AppTextStyle.bodyRegular
                      .copyWith(color: AppColors.primary),
                ),
              if (widget.hideMainTitle == null || widget.hideMainTitle == false)
                VerticalSpacer(height: 10.h),
              SizedBox(
                // height: widget.maxLines != null && widget.maxLines! > 1
                //     ? null
                //     : widget.height ?? 56.h,
                child: TextFormField(
                  maxLines:
                      widget.obscureText ?? false ? 1 : widget.maxLines ?? 1,
                  enabled: widget.enabled,
                  initialValue: widget.initialText,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: widget.controller,
                  style: widget.textStyle ?? AppTextStyle.bodyRegular,
                  obscureText:
                      (widget.obscureText ?? false) ? hidePassword : false,
                  onChanged: widget.onChanged,
                  cursorColor: widget.cursorColor ?? AppColors.black,
                  keyboardType: widget.textInputType,
                  inputFormatters: widget.inputFormatters,
                  autofocus: widget.autoFocused ?? false,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    fillColor: widget.fillColor,
                    filled: widget.filled,
                    focusedBorder: widget.disableBorder == true
                        ? null
                        : OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                    hintStyle: widget.hintTextStyle ??
                        AppTextStyle.bodyRegular
                            .copyWith(color: AppColors.hintText),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: (widget.prefixWidget != null &&
                                widget.maxLines != null)
                            ? 0.h
                            : 16.h),
                    enabledBorder: widget.disableBorder == true
                        ? null
                        : OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                    border: widget.disableBorder == true
                        ? InputBorder.none
                        : OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),

                    // focusedErrorBorder: OutlineInputBorder(
                    //   // gapPadding: 1,
                    //   borderRadius: BorderRadius.circular(5.r),
                    //   borderSide: const BorderSide(
                    //     color: AppColors.red,
                    //     width: 1,
                    //
                    //   ),
                    // ),
                    errorBorder: OutlineInputBorder(
                      // gapPadding: 1,
                      borderRadius: BorderRadius.circular(5.r),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 1,
                      ),
                    ),

                    // errorStyle: TextStyle,
                    alignLabelWithHint: true,
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    prefixText: widget.prefixText,
                    suffixIcon: widget.obscureText ?? false
                        ? Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    if (hidePassword) {
                                      hidePassword = false;
                                    } else {
                                      hidePassword = true;
                                    }
                                  },
                                );
                              },
                              splashRadius: 20.h,
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.secondary,
                              ),
                              color: AppColors.primary,
                            ),
                          )
                        : widget.iconSuffixData != null
                            ? Padding(
                                padding: EdgeInsets.only(right: 4.w),
                                child: IconButton(
                                  onPressed: widget.suffixOnTap ?? () {},
                                  splashRadius: 20.h,
                                  icon: Image.asset(
                                    widget.iconSuffixData!,
                                    height: 20.h,
                                    width: 20.w,
                                    color: AppColors.primary,
                                  ),
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                    prefixIcon: widget.iconPrefixData != null &&
                            widget.prefixWidget == null
                        ? IconButton(
                            onPressed: widget.suffixOnTap ?? () {},
                            splashRadius: 20.h,
                            icon: Image.asset(
                              widget.iconPrefixData!,
                              height: 20.h,
                              width: 20.w,
                              color: AppColors.primary,
                            ),
                            color: AppColors.primary,
                          )
                        : widget.prefixWidget,
                  ),
                  readOnly: widget.readOnly ?? false,
                  onSaved: widget.onSaved,
                  onTap: widget.onTap,
                  onFieldSubmitted: widget.onFieldSubmit,
                ),
              ),
            ],
          );
  }
}
