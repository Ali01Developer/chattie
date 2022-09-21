import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.userName,
    required this.userImage,
  }) : super(key: key);

  final String message;
  final bool isMe;
  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(isMe ? 12 : 0),
                  bottomRight: Radius.circular(!isMe ? 12 : 0),
                ),
                border: Border.all(
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              width: 200,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? 200 : null,
          right: isMe ? null : 200,
          child: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
