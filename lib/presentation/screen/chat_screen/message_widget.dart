import 'package:flutter/material.dart';
import 'package:rest_app/constant/themes.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        //!isCurrentUser ? 64.0 : 16.0,
        0,
        4,
        0,
        //!isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment:
            !isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? kPrimaryColor : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(16),
              topLeft: const Radius.circular(16),
              bottomLeft: Radius.circular(!isCurrentUser ? 16 : 0),
              bottomRight: Radius.circular(isCurrentUser ? 16 : 0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isCurrentUser ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
