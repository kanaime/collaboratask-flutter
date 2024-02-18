
import 'package:flutter/material.dart';

import '../../utils/navigation_utils.dart';
import '../../utils/network_utils.dart';
import '../views/MessageView.dart';
import 'MainNavigationControlller.dart';

class MessageViewController extends StatefulWidget {
  const MessageViewController({super.key});

  @override
  MessageController createState() {
    return MessageController();
  }
}

class MessageController extends State<MessageViewController> {
  //region Variables
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? versionText;

  //endregion

  // region Init
  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MessageView(this);
  }

  //endregion

  //region Data
  void _loadData() async {
    isLoading.value = true;



    // effectue la synchro des données

  }


//endregion

//region Navigation

//endregion


//endregion
}
