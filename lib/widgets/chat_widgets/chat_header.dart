import 'package:flutter/material.dart';

class ChatHeaderWidget extends StatelessWidget {

  const ChatHeaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        width: double.infinity,
        child:   
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Text(
                'Chats with your friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                    );
                  }
                
