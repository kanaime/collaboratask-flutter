import 'package:collaboratask/widgets/HeaderBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../theme/CustomColors.dart';
import '../../theme/Dimens.dart';
import '../../utils/view_utils.dart';
import '../base_view.dart';
import '../controllers/MessageController.dart';


class MessageView extends WidgetView<MessageViewController, MessageController> {
  const MessageView(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ViewUtils().statusBarColorDark(Colors.transparent),
      child: Scaffold(
        backgroundColor: CustomColors.BACKGROUND_COLOR,
        appBar: const HeaderBar(
          customBackgroundColor: CustomColors.BACKGROUND_COLOR,
          title: "Messages",
          rightButton: Icon(
            Icons.edit_square,
            color: CustomColors.SECONDARY,
          ),

        ),

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              listOfConversation('Jhon Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
              listOfConversation('Joshua Doe', 'Bonjour', () {}),
            ],
          ),
        ),
      ),
    );
  }

  //region Main content
  listOfConversation(String title, String subtitle, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: CustomColors.BACKGROUND_COLOR,
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: CustomColors.BLACK, fontWeight: FontWeight.bold),
                  ),
                  const Row(
                    children: [
                      Text(
                        '05:22',
                        style: TextStyle(
                          color: CustomColors.GRAY,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: CustomColors.GRAY,
                      )
                    ],
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: CustomColors.GRAY,
                    ),
                  ),
                ],
              ),
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: CustomColors.GRAY,
                child: Text('JD'),
              ),
              onTap: () {

                //controller.didTapOnConversation();
              },
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

//endregion


}
