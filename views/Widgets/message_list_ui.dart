import 'package:flutter/material.dart';
import 'package:service_app/model/app_constant.dart';
import 'package:service_app/model/message_model.dart';

class MessageListUi extends StatelessWidget {
  final MessageModel? message;

  const MessageListUi({super.key, this.message});

  bool get _isCurrentUser => message?.sender?.id == AppConstants.currentUser.id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: _isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isCurrentUser) ...[
            CircleAvatar(
              backgroundImage: message?.sender?.displayImage,
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: _isCurrentUser 
                    ? Colors.blue[100]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isCurrentUser)
                    Text(
                      message?.sender?.getFullNameofUser() ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    message?.text ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      message?.getMessageDateTime() ?? "",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: AppConstants.currentUser.displayImage,
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }
}