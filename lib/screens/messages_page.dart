import 'dart:ui';

import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/models/friends_module.dart';
import 'package:SailWithMe/widgets/chat_widgets/chat_body_widget.dart';
import 'package:SailWithMe/widgets/chat_widgets/chat_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context){

    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: StreamBuilder<List<Friends>>(
            stream: ApiCalls.getAllFriendsByStream(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try later');
                  } else {
                    final users = snapshot.data;

                    if (users.isEmpty) {
                      return buildText('No Users Found');
                    } else
                      return Column(
                        children: [
                          ChatHeaderWidget(),
                          ChatBodyWidget(users: users)
                        ],
                      );
                  }
              }
            },
          ),
        ),
      );
  }
  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
}
