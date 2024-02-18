import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../base_view.dart';
import '../controllers/SplashController.dart';


class SplashView extends WidgetView<SplashViewController, SplashController> {
  const SplashView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _content(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //region Main content
  Widget _content(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(left: Dimens.spacing_large_16, right: Dimens.spacing_large_16, bottom: Dimens.spacing_xlarge_32),
          child: Column(
            children: [
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 1,
                        child: Image(
                          image: const AssetImage("images/logo.png"),
                          width: Dimens.fromScreenWidth(context, coef: 0.7),
                        ),
                      ),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.TEST_COLOR_BLUE),
                      ),
                    ]),
              ),
              if (kDebugMode)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_large_16),
                  child: Text(
                      controller.versionText ?? "",
                      style: const TextStyle(
                        color: CustomColors.SECONDARY,
                        fontSize: Dimens.font_size_small_12,
                      )
                  ),
                ),
            ],
          )),
    );
  }

//endregion


}
