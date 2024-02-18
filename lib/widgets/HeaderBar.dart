
import 'package:flutter/material.dart';

import '../theme/CustomColors.dart';
import '../theme/Dimens.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {

  final Color? customBackgroundColor ;
  final String? title ;
  final bool backButton ;
  final Widget? rightButton ;
  final Function? onBackButtonPressed;

  const HeaderBar({
    this.customBackgroundColor,
    this.onBackButtonPressed,
    this.backButton = false,
    this.rightButton,
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return PreferredSize(
      preferredSize: Size.fromHeight(Dimens.appBarHeight),
      child: AppBar(
        centerTitle: true,
        backgroundColor: customBackgroundColor ?? Theme.of(context).colorScheme.surfaceVariant,
        leading: backButton ? IconButton(
          onPressed: ()=>onBackButtonPressed!(),
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.SECONDARY, size: 30,),
        ) : Container(),

        actions: [
          Padding(padding: EdgeInsets.only(right: Dimens.font_size_medium_16), child: rightButton ?? Container())

        ],
        title: Text(title ?? "", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1, color: CustomColors.SECONDARY)
        ),
      )
      )
    ;
  }



  @override
  Size get preferredSize => Size.fromHeight(Dimens.appBarHeight);

}
